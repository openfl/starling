import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Type.BaseType;
import haxe.macro.Type.AbstractType;
import haxe.macro.Context;

class TSExternsGenerator {
	private static final ALWAYS_ALLOWED_REFERENCE_TYPES = [
		"Any",
		"Array",
		"Bool",
		"Class",
		"Date",
		"Dynamic",
		"Float",
		"Int",
		"String",
		"UInt",
		"Void"
	];
	private static final DISALLOWED_TS_NAMES = [];
	private static final eregAccessor = ~/^(g|s)et_[\w]+$/;
	private static final QNAMES_TO_REWRITE:Map<String, String> = [
		"Any" => "any",
		"Bool" => "boolean",
		"Class" => "any",
		"Dynamic" => "any",
		"Float" => "number",
		"Int" => "number",
		"String" => "string",
		"UInt" => "number",
		"Void" => "void"
	];

	public static function generate(?options:TSGeneratorOptions):Void {
		var outputDirPath = Path.join([Path.directory(Compiler.getOutput()), "ts-externs"]);
		if (options != null && options.outputPath != null) {
			outputDirPath = options.outputPath;
		}
		if (!Path.isAbsolute(outputDirPath)) {
			outputDirPath = Path.join([Sys.getCwd(), outputDirPath]);
		}
		Context.onGenerate(types -> {
			var generator = new TSExternsGenerator(options);
			generator.generateForTypes(types, outputDirPath);
		});
	}

	private var importMappings:Map<String, String> = [];

	private var options:TSGeneratorOptions;

	private function new(?options:TSGeneratorOptions) {
		this.options = options;
	}

	public function generateForTypes(types:Array<Type>, outputDirPath:String):Void {
		for (type in types) {
			switch (type) {
				case TInst(t, params):
					var classType = t.get();
					if (shouldSkipBaseType(classType, false)) {
						continue;
					}
					if (classType.isInterface) {
						var generated = generateInterface(classType, params);
						writeGenerated(outputDirPath, classType, generated);
					} else {
						var generated = generateClass(classType, params);
						writeGenerated(outputDirPath, classType, generated);
					}
				case TEnum(t, params):
					var enumType = t.get();
					if (shouldSkipBaseType(enumType, false)) {
						continue;
					}
					var generated = generateEnum(enumType, params);
					writeGenerated(outputDirPath, enumType, generated);
				case TAbstract(t, params):
					var abstractType = t.get();
					if (shouldSkipBaseType(abstractType, false)) {
						continue;
					}
					if (!abstractType.meta.has(":enum")) {
						// ignore non-enum abstracts because they don't exist in openfl-js
						continue;
					}
					var generated = generateAbstractEnum(abstractType, params);
					writeGenerated(outputDirPath, abstractType, generated);
				case TType(t, params):
					// ignore typedefs because they don't exist in openfl-js
				default:
					trace("Unexpected type: " + type);
			}
		}
	}

	private function isInPackage(expected:Array<String>, actual:Array<String>, exact:Bool):Bool {
		if (expected == null) {
			return true;
		}
		if (exact) {
			if (actual.length != expected.length) {
				return false;
			}
		} else if (actual.length < expected.length) {
			return false;
		}
		for (i in 0...expected.length) {
			var actualPart = actual[i];
			var expectedPart = expected[i];
			if (actualPart != expectedPart) {
				return false;
			}
		}
		return true;
	}

	private function isInHiddenPackage(pack:Array<String>):Bool {
		for (part in pack) {
			if (part.charAt(0) == "_") {
				return true;
			}
		}
		return false;
	}

	private function shouldSkipMacroType(type:Type, asReference:Bool):Bool {
		var baseType:BaseType = null;
		while (type != null) {
			switch (type) {
				case TInst(t, params):
					var classType = t.get();
					switch (classType.kind) {
						case KTypeParameter(constraints):
							// don't let Vector<T> become Vector<any>
							return false;
						default:
					}
					baseType = classType;
					break;
				case TEnum(t, params):
					baseType = t.get();
					break;
				case TAbstract(t, params):
					var abstractType = t.get();
					if (abstractType.name == "Null" && abstractType.pack.length == 0) {
						return shouldSkipMacroType(params[0], asReference);
					}
					type = abstractType.type;
					switch (type) {
						case TAbstract(t, params):
							var result = baseTypeToQname(abstractType, params);
							var compareTo = baseTypeToQname(t.get(), params);
							if (result == compareTo) {
								// this avoids an infinite loop
								baseType = abstractType;
								break;
							}
						default:
					}
				case TType(t, params):
					type = t.get().type;
				case TDynamic(t):
					return false;
				case TAnonymous(a):
					return false;
				case TFun(args, ret):
					return false;
				case TLazy(f):
					type = f();
				case TMono(t):
					type = t.get();
				default:
					break;
			}
		}
		if (baseType == null) {
			return true;
		}
		return shouldSkipBaseType(baseType, asReference);
	}

	private function shouldSkipBaseType(baseType:BaseType, asReference:Bool):Bool {
		if (asReference && baseType.pack.length == 0 && ALWAYS_ALLOWED_REFERENCE_TYPES.indexOf(baseType.name) != -1) {
			return false;
		}
		
		if (baseType.isPrivate || (baseType.isExtern && !asReference) || isInHiddenPackage(baseType.pack)) {
			return true;
		}
		final qname = baseTypeToQname(baseType, [], false);
		if ((options == null || options.renameSymbols == null || options.renameSymbols.indexOf(qname) == -1)
				&& baseType.meta.has(":noCompletion")) {
			return true;
		}
		if (options != null) {
			if (options.includedPackages != null) {
				for (includedPackage in options.includedPackages) {
					if (isInPackage(includedPackage.split("."), baseType.pack, false)) {
						if (options.excludeSymbols != null) {
							var qname = baseTypeToQname(baseType, []);
							if (options.excludeSymbols.indexOf(qname) != -1) {
								return true;
							}
						}
						return false;
					}
				}
				if (!asReference) {
					return true;
				}
			} else if (options.excludeSymbols != null) {
				var qname = baseTypeToQname(baseType, []);
				if (options.excludeSymbols.indexOf(qname) != -1) {
					return true;
				}
			}
			if (asReference) {
				if (options.allowedPackageReferences != null) {
					for (allowedPackage in options.allowedPackageReferences) {
						if (isInPackage(allowedPackage.split("."), baseType.pack, false)) {
							return false;
						}
					}
					return true;
				}
			}
		}
		return false;
	}

	private function generateClass(classType:ClassType, params:Array<Type>):String {
		var result = new StringBuf();
		result.add(generateClassTypeImports(classType));
		var packageName:String = null;
		if (classType.pack.length > 0) {
			packageName = classType.pack.join(".");
			result.add('declare namespace $packageName {\n');
		}
		result.add(generateDocs(classType.doc, "\t"));
		var className = baseTypeToUnqualifiedName(classType, []);
		result.add('\texport class $className');
		result.add(generateUnqualifiedParams(params));
		var includeFieldsFrom:ClassType = null;
		if (classType.superClass != null) {
			var superClassType = classType.superClass.t.get();
			if (shouldSkipBaseType(superClassType, true)) {
				includeFieldsFrom = superClassType;
			} else {
				result.add(' extends ${baseTypeToUnqualifiedName(superClassType, classType.superClass.params)}');
			}
		}
		var interfaces = classType.interfaces;
		var foundFirstInterface = false;
		for (i in 0...interfaces.length) {
			var interfaceRef = interfaces[i];
			var implementedInterfaceType = interfaceRef.t.get();
			if (!shouldSkipBaseType(implementedInterfaceType, true)) {
				if (foundFirstInterface) {
					result.add(', ');
				} else {
					foundFirstInterface = true;
					result.add(' implements ');
				}
				result.add(baseTypeToUnqualifiedName(implementedInterfaceType, interfaceRef.params));
			}
		}
		result.add(' {\n');
		if (classType.constructor != null) {
			var constructor = classType.constructor.get();
			if (!shouldSkipField(constructor, classType)) {
				result.add(generateClassField(constructor, classType, false, null));
			}
		}
		while (includeFieldsFrom != null) {
			for (classField in includeFieldsFrom.fields.get()) {
				if (shouldSkipField(classField, includeFieldsFrom)) {
					continue;
				}
				if (Lambda.exists(classType.fields.get(), item -> item.name == classField.name)) {
					continue;
				}
				result.add(generateClassField(classField, includeFieldsFrom, false, interfaces));
			}
			if (includeFieldsFrom.superClass == null) {
				break;
			}
			includeFieldsFrom = includeFieldsFrom.superClass.t.get();
		}
		for (classField in classType.statics.get()) {
			if (shouldSkipField(classField, classType)) {
				continue;
			}
			result.add(generateClassField(classField, classType, true, null));
		}
		for (classField in classType.fields.get()) {
			if (shouldSkipField(classField, classType)) {
				continue;
			}
			result.add(generateClassField(classField, classType, false, interfaces));
		}
		result.add('\t}\n');
		if (classType.pack.length > 0) {
			result.add('}\n');
		}

		var qname = (packageName != null ? '$packageName.' : '') + className;
		result.add('export default ${qname};');
		return result.toString();
	}

	private function generateQnameParams(params:Array<Type>):String {
		if (params.length == 0) {
			return "";
		}
		var result = new StringBuf();
		result.add('<');
		for (i in 0...params.length) {
			var param = params[i];
			if (i > 0) {
				result.add(', ');
			}
			if (shouldSkipMacroType(param, true)) {
				result.add("any");
			} else {
				result.add(macroTypeToQname(param));
			}
		}
		result.add('>');
		return result.toString();
	}

	private function generateUnqualifiedParams(params:Array<Type>):String {
		if (params.length == 0) {
			return "";
		}
		var result = new StringBuf();
		result.add('<');
		for (i in 0...params.length) {
			var param = params[i];
			if (i > 0) {
				result.add(', ');
			}
			if (shouldSkipMacroType(param, true)) {
				result.add("any");
			} else {
				result.add(macroTypeToUnqualifiedName(param));
			}
		}
		result.add('>');
		return result.toString();
	}

	private function generateDocs(doc:String, indent:String):String {
		if (doc == null || StringTools.trim(doc).length == 0) {
			return "";
		}
		
		var result = new StringBuf();
		result.add('$indent/**\n');
		var lines = ~/\r?\n/g.split(doc);
		var addedLine = false;
		var checkedLeadingStar = false;
		var hasLeadingStar = false;
		for (line in lines) {
			if (!addedLine && ~/^\s*$/.match(line)) {
				continue;
			}
			addedLine = true;
			var leadingStar = ~/^(\s*\*\s*)/;
			if ((!checkedLeadingStar || hasLeadingStar) && leadingStar.match(line)) {
				checkedLeadingStar = true;
				hasLeadingStar = true;
				line = line.substr(leadingStar.matchedPos().len);
			} else if (!checkedLeadingStar) {
				checkedLeadingStar = true;
				hasLeadingStar = false;
			}
			result.add('$indent * $line\n');
		}
		result.add('$indent */\n');
		return result.toString();
	}

	private function generateClassField(classField:ClassField, classType:ClassType, isStatic:Bool,
			interfaces:Array<{t:Ref<ClassType>, params:Array<Type>}>):String {
		var result = new StringBuf();
		result.add(generateDocs(classField.doc, "\t\t"));
		result.add("\t\t");
		var superClassType:ClassType = null;
		var skippedSuperClass = false;
		if (classType != null && classType.superClass != null) {
			superClassType = classType.superClass.t.get();
			skippedSuperClass = shouldSkipBaseType(superClassType, true);
		}
		switch (classField.kind) {
			case FMethod(k):
				if (!skippedSuperClass) {
					if (classType != null) {
						for (current in classType.overrides) {
							if (current.get().name == classField.name) {
								result.add('override ');
							}
						}
					}
				}
				if (!classField.isPublic) {
					result.add('protected ');
				}
				if (isStatic) {
					result.add('static ');
				}
				if (classField.name == "new" && classType != null) {
					result.add('constructor');
				} else {
					result.add(classField.name);
				}
				switch (classField.type) {
					case TFun(args, ret):
						var params = classField.params;
						if (params.length > 0) {
							result.add('<');
							for (i in 0...params.length) {
								var param = params[i];
								if (i > 0) {
									result.add(', ');
								}
								result.add(param.name);
							}
							result.add('>');
						}
						result.add('(');
						var hadOpt = false;
						for (i in 0...args.length) {
							var arg = args[i];
							if (i > 0) {
								result.add(', ');
							}
							result.add(arg.name);
							if (arg.opt || hadOpt) {
								hadOpt = true;
								result.add('?');
							}
							result.add(': ');
							if (shouldSkipMacroType(arg.t, true)) {
								result.add('any');
							} else {
								result.add(macroTypeToUnqualifiedName(arg.t));
							}
						}
						result.add(')');
						if (classField.name != "new") {
							result.add(': ');
							if (shouldSkipMacroType(ret, true)) {
								result.add('any');
							} else {
								result.add(macroTypeToUnqualifiedName(ret));
							}
						}
						result.add(";");
					default:
				}
			case FVar(read, write):
				var isAccessor = read == AccCall || write == AccCall || mustBeAccessor(classField.name, interfaces);
				if (isAccessor) {
					var hasGetter = read == AccCall || read == AccNormal;
					var hasSetter = write == AccCall || write == AccNormal;
					if (hasGetter) {
						if (!classField.isPublic) {
							result.add('protected ');
						}
						if (isStatic) {
							result.add('static ');
						}
						result.add('get ');
						result.add(classField.name);
						result.add('(): ');
						if (shouldSkipMacroType(classField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(classField.type));
						}
						result.add(';');
					}
					if (hasSetter) {
						if (hasGetter) {
							result.add('\n\t\t');
						}
						if (!classField.isPublic) {
							result.add('protected ');
						}
						if (isStatic) {
							result.add('static ');
						}
						result.add('set ');
						result.add(classField.name);
						result.add('(value: ');
						if (shouldSkipMacroType(classField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(classField.type));
						}
						result.add(')');
					}
				} else {
					if (!classField.isPublic) {
						result.add('protected ');
					}
					if (isStatic) {
						result.add('static ');
					}
					if (classField.isFinal || read == AccInline || write == AccInline) {
						result.add('readonly ');
					}
					result.add(classField.name);
					var initExpr:String = null;
					if (classField.isFinal || read == AccInline || write == AccInline) {
						initExpr = generateInitExpression(classField);
					}
					if (initExpr != null && initExpr.length > 0) {
						result.add(initExpr);
					} else {
						result.add(': ');
						if (shouldSkipMacroType(classField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(classField.type));
						}
					}
					result.add(";");
				}
		}
		result.add('\n');
		return result.toString();
	}

	private function generateInitExpression(classField:ClassField):String {
		var typedExpr = classField.expr();
		if (typedExpr == null) {
			return "";
		}
		var expr = typedExpr.expr;
		while (true) {
			switch (expr) {
				case TCast(e, m):
					expr = e.expr;
				case TConst(TBool(b)):
					return ' = $b';
					break;
				case TConst(TFloat(f)):
					return ' = $f';
					break;
				case TConst(TInt(i)):
					return ' = $i';
					break;
				case TConst(TString(s)):
					return ' = "$s"';
					break;
				default:
					break;
			}
		}
		return "";
	}

	private function mustBeAccessor(fieldName:String, interfaces:Array<{t:Ref<ClassType>, params:Array<Type>}>):Bool {
		if (interfaces == null) {
			return false;
		}
		for (interfaceRef in interfaces) {
			var implementedInterface = interfaceRef.t.get();
			for (classField in implementedInterface.fields.get()) {
				if (classField.name == fieldName) {
					switch (classField.kind) {
						case FVar(read, write):
							return true;
						default:
							return false;
					}
				}
			}
			if (mustBeAccessor(fieldName, implementedInterface.interfaces)) {
				return true;
			}
		}
		return false;
	}

	private function generateClassTypeImports(classType:ClassType):String {
		var qnames:Map<String, Bool> = [];
		if (classType.constructor != null) {
			var constructor = classType.constructor.get();
			if (!shouldSkipField(constructor, classType)) {
				switch (constructor.type) {
					case TFun(args, ret):
						for (arg in args) {
							var argType = arg.t;
							if (!canSkipMacroTypeImport(argType, classType.pack) && !shouldSkipMacroType(argType, true)) {
								var qname = macroTypeToQname(argType, false);
								qnames.set(qname, true);
							}
						}
					default:
				}
			}
		}
		if (classType.superClass != null) {
			var superClass = classType.superClass.t.get();
			if (!shouldSkipBaseType(superClass, true) && !canSkipBaseTypeImport(superClass, classType.pack)) {
				var qname = baseTypeToQname(superClass, [], false);
				qnames.set(qname, true);
			}
			for (param in classType.superClass.params) {
				addMacroTypeQnamesForImport(param, qnames, classType.pack);
			}
		}
		for (interfaceRef in classType.interfaces) {
			var interfaceType = interfaceRef.t.get();
			if (!shouldSkipBaseType(interfaceType, true) && !canSkipBaseTypeImport(interfaceType, classType.pack)) {
				var qname = baseTypeToQname(interfaceType, [], false);
				qnames.set(qname, true);
			}
			for (param in interfaceRef.params) {
				addMacroTypeQnamesForImport(param, qnames, classType.pack);
			}
		}
		if (classType.constructor != null) {
			var classField = classType.constructor.get();
			switch (classField.type) {
				case TFun(args, ret):
					for (arg in args) {
						addMacroTypeQnamesForImport(arg.t, qnames, classType.pack);
					}
				default:
			}
		}
		for (classField in classType.statics.get()) {
			if (shouldSkipField(classField, classType)) {
				continue;
			}
			switch (classField.type) {
				case TFun(args, ret):
					for (arg in args) {
						addMacroTypeQnamesForImport(arg.t, qnames, classType.pack);
					}
					addMacroTypeQnamesForImport(ret, qnames, classType.pack);
				default:
					addMacroTypeQnamesForImport(classField.type, qnames, classType.pack);
			}
		}
		for (classField in classType.fields.get()) {
			if (shouldSkipField(classField, classType)) {
				continue;
			}
			switch (classField.type) {
				case TFun(args, ret):
					for (arg in args) {
						addMacroTypeQnamesForImport(arg.t, qnames, classType.pack);
					}
					addMacroTypeQnamesForImport(ret, qnames, classType.pack);
				default:
					addMacroTypeQnamesForImport(classField.type, qnames, classType.pack);
			}
		}

		importMappings.clear();
		var originPath = ~/\./g.replace(baseTypeToQname(classType, [], false), "/");
		var result = new StringBuf();
		for (qname in qnames.keys()) {
			var targetPath = ~/\./g.replace(qname, "/");
			if (originPath == targetPath) {
				continue;
			}
			result.add('import ');
			var dotIndex = qname.lastIndexOf(".");
			var unqualifiedName = qname;
			if (dotIndex != -1) {
				unqualifiedName = unqualifiedName.substr(dotIndex + 1);
			}
			if (importMappings.exists(unqualifiedName)) {
				unqualifiedName = ~/\./g.replace(qname, "_");
			}
			importMappings.set(unqualifiedName, qname);
			result.add(unqualifiedName);
			result.add(' from "');
			if (options != null && options.includedPackages != null) {
				var pack = qname.split(".");
				pack.pop();
				if (Lambda.exists(options.includedPackages, includedPack -> isInPackage(includedPack.split("."), pack, false))) {
					result.add(relativizePath(targetPath, originPath));
				} else {
					result.add(targetPath);
				}
			} else {
				result.add(relativizePath(targetPath, originPath));
			}
			result.add('";\n');
		}
		return result.toString();
	}

	private function addMacroTypeQnamesForImport(type:Type, qnames:Map<String, Bool>, pack:Array<String>):Void {
		if (!canSkipMacroTypeImport(type, pack) && !shouldSkipMacroType(type, true)) {
			var qname = macroTypeToQname(type, false);
			qnames.set(qname, true);
		}
		while (type != null) {
			switch (type) {
				case TInst(t, params):
					for (param in params) {
						addMacroTypeQnamesForImport(param, qnames, pack);
					}
					break;
				case TEnum(t, params):
					for (param in params) {
						addMacroTypeQnamesForImport(param, qnames, pack);
					}
					break;
				case TAbstract(t, params):
					for (param in params) {
						addMacroTypeQnamesForImport(param, qnames, pack);
					}
					break;
				case TType(t, params):
					var typedefType = t.get();
					type = typedefType.type;
				case TFun(args, ret):
					for (arg in args) {
						addMacroTypeQnamesForImport(arg.t, qnames, pack);
					}
					addMacroTypeQnamesForImport(ret, qnames, pack);
					break;
				case TLazy(f):
					type = f();
				case TMono(t):
					type = t.get();
				default:
					break;
			}
		}
	}

	private function generateInterface(interfaceType:ClassType, params:Array<Type>):String {
		var result = new StringBuf();
		result.add(generateClassTypeImports(interfaceType));
		var packageName:String = null;
		if (interfaceType.pack.length > 0) {
			packageName = interfaceType.pack.join(".");
			result.add('declare namespace $packageName {\n');
		}
		result.add(generateDocs(interfaceType.doc, "\t"));
		// yes, class instead of interface
		// it allows us to export the interface
		// and TS allows implementing classes
		result.add('\texport class ${interfaceType.name}');
		result.add(generateUnqualifiedParams(params));
		var interfaces = interfaceType.interfaces;
		var firstInterface = false;
		for (i in 0...interfaces.length) {
			var interfaceRef = interfaces[i];
			var implementedInterfaceType = interfaceRef.t.get();
			if (!shouldSkipBaseType(implementedInterfaceType, true)) {
				if (firstInterface) {
					result.add(', ');
				} else {
					firstInterface = true;
					result.add(' extends ');
				}
				result.add(baseTypeToUnqualifiedName(implementedInterfaceType, interfaceRef.params));
			}
		}
		result.add(' {\n');
		for (interfaceField in interfaceType.fields.get()) {
			if (shouldSkipField(interfaceField, interfaceType)) {
				continue;
			}
			result.add(generateInterfaceField(interfaceField));
		}
		result.add('\t}\n');
		if (interfaceType.pack.length > 0) {
			result.add('}\n');
		}

		var qname = (packageName != null ? '$packageName.' : '') + interfaceType.name;
		result.add('export default ${qname};');
		return result.toString();
	}

	private function generateInterfaceField(interfaceField:ClassField):String {
		var result = new StringBuf();
		result.add(generateDocs(interfaceField.doc, "\t\t"));
		result.add("\t\t");
		switch (interfaceField.kind) {
			case FMethod(k):
				result.add(interfaceField.name);
				switch (interfaceField.type) {
					case TFun(args, ret):
						var params = interfaceField.params;
						if (params.length > 0) {
							result.add('<');
							for (i in 0...params.length) {
								var param = params[i];
								if (i > 0) {
									result.add(', ');
								}
								result.add(param.name);
							}
							result.add('>');
						}
						result.add('(');
						var hadOpt = false;
						for (i in 0...args.length) {
							var arg = args[i];
							if (i > 0) {
								result.add(', ');
							}
							result.add(arg.name);
							if (arg.opt || hadOpt) {
								hadOpt = true;
								result.add('?');
							}
							result.add(': ');
							if (shouldSkipMacroType(arg.t, true)) {
								result.add('any');
							} else {
								result.add(macroTypeToUnqualifiedName(arg.t));
							}
						}
						result.add('): ');
						if (shouldSkipMacroType(ret, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(ret));
						}
						result.add(';\n');
					default:
				}
			case FVar(read, write):
				var hasGetter = read == AccCall;
				var hasSetter = write == AccCall;
				if (hasGetter || hasSetter) {
					if (hasGetter) {
						result.add('get ');
						result.add(interfaceField.name);
						result.add('(): ');
						if (shouldSkipMacroType(interfaceField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(interfaceField.type));
						}
						result.add(';\n');
					}
					if (hasSetter) {
						if (hasGetter) {
							result.add('\t\t');
						}
						result.add('set ');
						result.add(interfaceField.name);
						result.add('(value: ');
						if (shouldSkipMacroType(interfaceField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(interfaceField.type));
						}
						result.add(')');
						result.add(';\n');
					}
				} else {
					if (!interfaceField.isPublic) {
						result.add('protected ');
					}
					if (interfaceField.isFinal || read == AccInline || write == AccInline) {
						result.add('readonly ');
					}
					result.add(interfaceField.name);
					var initExpr:String = null;
					if (interfaceField.isFinal || read == AccInline || write == AccInline) {
						initExpr = generateInitExpression(interfaceField);
					}
					if (initExpr != null && initExpr.length > 0) {
						result.add(initExpr);
					} else {
						result.add(': ');
						if (shouldSkipMacroType(interfaceField.type, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(interfaceField.type));
						}
					}
					result.add(";\n");
				}
		}
		return result.toString();
	}

	private function generateEnum(enumType:EnumType, params:Array<Type>):String {
		var result = new StringBuf();
		var packageName:String = null;
		if (enumType.pack.length > 0) {
			packageName = enumType.pack.join(".");
			result.add('declare namespace $packageName {\n');
		}
		result.add(generateDocs(enumType.doc, "\t"));
		result.add('\texport class ${enumType.name}');
		result.add(generateUnqualifiedParams(params));
		result.add(' {\n');
		for (enumField in enumType.constructs) {
			result.add(generateEnumField(enumField, enumType, params));
		}
		result.add('\t}\n');
		if (enumType.pack.length > 0) {
			result.add('}\n');
		}

		var qname = (packageName != null ? '$packageName.' : '') + enumType.name;
		result.add('export default ${qname};');
		return result.toString();
	}

	private function generateEnumField(enumField:EnumField, enumType:EnumType, enumTypeParams:Array<Type>):String {
		var result = new StringBuf();
		result.add(generateDocs(enumField.doc, "\t\t"));
		result.add("\t\t");
		result.add('static ');
		result.add('readonly ');
		result.add(enumField.name);
		result.add(': ');
		result.add(baseTypeToQname(enumType, enumTypeParams));
		result.add(';');
		result.add('\n');
		return result.toString();
	}

	private function generateAbstractEnum(abstractType:AbstractType, params:Array<Type>):String {
		var result = new StringBuf();
		var packageName:String = null;
		if (abstractType.pack.length > 0) {
			packageName = abstractType.pack.join(".");
			result.add('declare namespace ${packageName} {\n');
		}
		result.add(generateDocs(abstractType.doc, "\t"));
		result.add('\texport enum ${abstractType.name}');
		result.add(' {\n');
		if (abstractType.impl != null) {
			var classType = abstractType.impl.get();
			for (classField in classType.statics.get()) {
				if (shouldSkipField(classField, classType)) {
					continue;
				}
				switch (classField.kind) {
					case FVar(read, write):
						if (read == AccInline && write == AccNever) {
							result.add(generateDocs(classField.doc, "\t\t"));
							result.add('\t\t');
							result.add(classField.name);
							result.add(generateInitExpression(classField));
							result.add(',\n');
						}
						// TODO: if TypeScript will unify enums and interfaces,
						// with the same name, we should be able to put other
						// types of vars and methods into an interface.
					default:
				}
			}
		}
		result.add('\t}\n');
		if (abstractType.pack.length > 0) {
			result.add('}\n');
		}

		var qname = (packageName != null ? '$packageName.' : '') + abstractType.name;
		result.add('export default ${qname};');
		return result.toString();
	}

	private function shouldSkipField(classField:ClassField, classType:ClassType):Bool {
		if (classField.name != "new") {
			if (!classField.isPublic
				|| classField.isExtern
				|| classField.meta.has(":noCompletion")
				|| DISALLOWED_TS_NAMES.indexOf(classField.name) != -1) {
				return true;
			}
		}

		if (classType != null && classType.isInterface) {
			if (classField.kind.equals(FieldKind.FMethod(MethNormal)) && eregAccessor.match(classField.name)) {
				return true;
			}
		}
		return false;
	}

	private function canSkipMacroTypeImport(type:Type, currentPackage:Array<String>):Bool {
		var baseType:BaseType = null;
		while (type != null) {
			switch (type) {
				case TInst(t, params):
					var classType = t.get();
					switch (classType.kind) {
						case KTypeParameter(constraints):
							return true;
						default:
					}
					baseType = classType;
					break;
				case TEnum(t, params):
					baseType = t.get();
					break;
				case TAbstract(t, params):
					var abstractType = t.get();
					if (abstractType.meta.has(":enum") && !shouldSkipBaseType(abstractType, true)) {
						baseType = abstractType;
						break;
					} else {
						return canSkipAbstractTypeImport(abstractType, params, currentPackage);
					}
				case TType(t, params):
					var typedefType = t.get();
					type = typedefType.type;
				case TDynamic(t):
					break;
				case TAnonymous(a):
					break;
				case TFun(args, ret):
					break;
				case TLazy(f):
					type = f();
				case TMono(t):
					type = t.get();
				default:
					break;
			}
		}
		if (baseType == null) {
			return true;
		}
		return canSkipBaseTypeImport(baseType, currentPackage);
	}

	private function canSkipAbstractTypeImport(abstractType:AbstractType, params:Array<Type>, currentPackage:Array<String>):Bool {
		var pack = abstractType.pack;
		if (abstractType.name == "Null" && pack.length == 0) {
			return canSkipMacroTypeImport(params[0], currentPackage);
		}
		var underlyingType = abstractType.type;
		switch (underlyingType) {
			case TAbstract(t, underlyingParams):
				var result = baseTypeToQname(abstractType, params, false);
				var compareTo = baseTypeToQname(t.get(), underlyingParams, false);
				if (result == compareTo) {
					// this avoids an infinite loop
					return canSkipBaseTypeImport(abstractType, currentPackage);
				}
			default:
		}
		return canSkipMacroTypeImport(underlyingType, currentPackage);
	}

	private function canSkipBaseTypeImport(baseType:BaseType, currentPackage:Array<String>):Bool {
		if (baseType == null) {
			return true;
		}
		var qname = baseTypeToQname(baseType, []);
		if (qname.indexOf(".") == -1 && ALWAYS_ALLOWED_REFERENCE_TYPES.indexOf(baseType.name) != -1) {
			return true;
		}
		return false;
	}

	private function macroTypeToQname(type:Type, includeParams:Bool = true):String {
		while (type != null) {
			switch (type) {
				case TInst(t, params):
					var classType = t.get();
					switch (classType.kind) {
						case KTypeParameter(constraints):
							return baseTypeToUnqualifiedName(classType, params, includeParams);
						default:
					}
					return baseTypeToQname(classType, params, includeParams);
				case TEnum(t, params):
					return baseTypeToQname(t.get(), params, includeParams);
				case TAbstract(t, params):
					return abstractTypeToQname(t.get(), params, includeParams);
				case TType(t, params):
					var defType = t.get();
					if (options != null && options.renameSymbols != null) {
						var buffer = new StringBuf();
						if (defType.pack.length > 0) {
							buffer.add(defType.pack.join("."));
							buffer.add(".");
						}
						buffer.add(defType.name);
						var qname = buffer.toString();
						var renameSymbols = options.renameSymbols;
						var i = 0;
						while (i < renameSymbols.length) {
							var originalName = renameSymbols[i];
							i++;
							var newName = renameSymbols[i];
							i++;
							if (originalName == qname) {
								qname = newName;
								return qname;
							}
						}
					}
					type = t.get().type;
				case TDynamic(t):
					if (t != null) {
						var valueType = macroTypeToUnqualifiedName(t, includeParams);
						return '{[key: string]: $valueType}';
					}
					return "any";
				case TAnonymous(a):
					return "any";
				case TFun(args, ret):
					var result = new StringBuf();
					result.add('(');
					var hadOpt = false;
					for (i in 0...args.length) {
						var arg = args[i];
						if (i > 0) {
							result.add(', ');
						}
						if (arg.name.length > 0) {
							result.add(arg.name);
						} else {
							result.add('arg$i');
						}
						if (arg.opt || hadOpt) {
							hadOpt = true;
							result.add('?');
						}
						result.add(': ');
						if (shouldSkipMacroType(arg.t, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(arg.t));
						}
					}
					result.add(')');
					result.add(' => ');
					if (shouldSkipMacroType(ret, true)) {
						result.add('any');
					} else {
						result.add(macroTypeToUnqualifiedName(ret));
					}
					return result.toString();
				case TLazy(f):
					type = f();
				case TMono(t):
					type = t.get();
				default:
					return "any";
			}
		}
		return "any";
	}

	private function macroTypeToUnqualifiedName(type:Type, includeParams:Bool = true):String {
		while (type != null) {
			switch (type) {
				case TInst(t, params):
					var classType = t.get();
					switch (classType.kind) {
						case KTypeParameter(constraints):
							return baseTypeToUnqualifiedName(classType, params, includeParams);
						default:
					}
					return baseTypeToUnqualifiedName(classType, params, includeParams);
				case TEnum(t, params):
					return baseTypeToUnqualifiedName(t.get(), params, includeParams);
				case TAbstract(t, params):
					return abstractTypeToUnqualifiedName(t.get(), params, includeParams);
				case TType(t, params):
					var defType = t.get();
					if (options != null && options.renameSymbols != null) {
						var buffer = new StringBuf();
						if (defType.pack.length > 0) {
							buffer.add(defType.pack.join("."));
							buffer.add(".");
						}
						buffer.add(defType.name);
						var qname = buffer.toString();
						var renameSymbols = options.renameSymbols;
						var i = 0;
						while (i < renameSymbols.length) {
							var originalName = renameSymbols[i];
							i++;
							var newName = renameSymbols[i];
							i++;
							if (originalName == qname) {
								qname = newName;
								return qname;
							}
						}
					}
					type = t.get().type;
				case TDynamic(t):
					if (t != null) {
						var valueType = macroTypeToUnqualifiedName(t, includeParams);
						return '{[key: string]: $valueType}';
					}
					return "any";
				case TAnonymous(a):
					return "any";
				case TFun(args, ret):
					var result = new StringBuf();
					result.add('(');
					var hadOpt = false;
					for (i in 0...args.length) {
						var arg = args[i];
						if (i > 0) {
							result.add(', ');
						}
						if (arg.name.length > 0) {
							result.add(arg.name);
						} else {
							result.add('arg$i');
						}
						if (arg.opt || hadOpt) {
							hadOpt = true;
							result.add('?');
						}
						result.add(': ');
						if (shouldSkipMacroType(arg.t, true)) {
							result.add('any');
						} else {
							result.add(macroTypeToUnqualifiedName(arg.t));
						}
					}
					result.add(')');
					result.add(' => ');
					if (shouldSkipMacroType(ret, true)) {
						result.add('any');
					} else {
						result.add(macroTypeToUnqualifiedName(ret));
					}
					return result.toString();
				case TLazy(f):
					type = f();
				case TMono(t):
					type = t.get();
				default:
					return "any";
			}
		}
		return "any";
	}

	private function baseTypeToQname(baseType:BaseType, params:Array<Type>, includeParams:Bool = true):String {
		if (baseType == null) {
			return "any";
		}
		var buffer = new StringBuf();
		if (baseType.pack.length > 0) {
			buffer.add(baseType.pack.join("."));
			buffer.add(".");
		}
		buffer.add(baseType.name);
		var qname = buffer.toString();
		if (options != null && options.renameSymbols != null) {
			var renameSymbols = options.renameSymbols;
			var i = 0;
			while (i < renameSymbols.length) {
				var originalName = renameSymbols[i];
				i++;
				var newName = renameSymbols[i];
				i++;
				if (originalName == qname) {
					qname = newName;
					break;
				}
			}
		}

		if (QNAMES_TO_REWRITE.exists(qname)) {
			qname = QNAMES_TO_REWRITE.get(qname);
		}

		if (!includeParams || params.length == 0) {
			return qname;
		}

		buffer = new StringBuf();
		buffer.add(qname);
		buffer.add(generateQnameParams(params));
		return buffer.toString();
	}

	private function baseTypeToUnqualifiedName(baseType:BaseType, params:Array<Type>, includeParams:Bool = true):String {
		if (baseType == null) {
			return "any";
		}
		var qname = baseTypeToQname(baseType, params, false);
		if (qname == "any") {
			return qname;
		}
		if (options != null && options.renameSymbols != null) {
			var renameSymbols = options.renameSymbols;
			var i = 0;
			while (i < renameSymbols.length) {
				var originalName = renameSymbols[i];
				i++;
				var newName = renameSymbols[i];
				i++;
				if (originalName == qname) {
					qname = newName;
					break;
				}
			}
		}

		if (QNAMES_TO_REWRITE.exists(qname)) {
			qname = QNAMES_TO_REWRITE.get(qname);
		}

		var foundImportMapping = false;
		var unqualifiedName = qname;
		for (key => value in importMappings) {
			if (value == qname) {
				unqualifiedName = key;
				foundImportMapping = true;
				break;
			}
		}
		if (!foundImportMapping) {
			var index = unqualifiedName.lastIndexOf(".");
			if (index != -1) {
				unqualifiedName = unqualifiedName.substr(index + 1);
			}
		}

		if (!includeParams || params.length == 0) {
			return unqualifiedName;
		}

		var buffer = new StringBuf();
		buffer.add(unqualifiedName);
		buffer.add(generateUnqualifiedParams(params));
		return buffer.toString();
	}

	private function abstractTypeToUnqualifiedName(abstractType:AbstractType, abstractTypeParams:Array<Type>, includeParams:Bool = true):String {
		if (abstractType.meta.has(":enum") && !shouldSkipBaseType(abstractType, true)) {
			return baseTypeToUnqualifiedName(abstractType, abstractTypeParams, includeParams);
		}
		if (abstractType.name == "Null" && abstractType.pack.length == 0) {
			return macroTypeToUnqualifiedName(abstractTypeParams[0], includeParams);
		}
		if (abstractType.name == "Function" && abstractType.pack.length == 1 && abstractType.pack[0] == "haxe") {
			return "Function";
		}
		var underlyingType = abstractType.type;
		switch (underlyingType) {
			case TAbstract(t, underlyingParams):
				var result = baseTypeToQname(abstractType, abstractTypeParams, false);
				var compareTo = baseTypeToQname(t.get(), underlyingParams, false);
				if (result == compareTo) {
					// this avoids an infinite loop
					return baseTypeToUnqualifiedName(abstractType, abstractTypeParams, includeParams);
				}
			default:
		}
		
		if (includeParams) {
			var abstractTypeQname = baseTypeToQname(abstractType, abstractTypeParams, false);
			var paramsToInclude:Array<Type> = null;
			switch (underlyingType) {
				case TInst(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams.map((param) -> {
						return translateTypeParam(param, abstractTypeQname, abstractType.params, abstractTypeParams);
					});
				case TAbstract(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				case TEnum(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				case TType(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				default:
					paramsToInclude = [];
			}
			return macroTypeToUnqualifiedName(underlyingType, false) + generateUnqualifiedParams(paramsToInclude);
		}

		return macroTypeToUnqualifiedName(underlyingType, false);
	}

	private function abstractTypeToQname(abstractType:AbstractType, abstractTypeParams:Array<Type>, includeParams:Bool = true):String {
		if (abstractType.meta.has(":enum") && !shouldSkipBaseType(abstractType, true)) {
			return baseTypeToQname(abstractType, abstractTypeParams, includeParams);
		}
		if (abstractType.name == "Null" && abstractType.pack.length == 0) {
			return macroTypeToQname(abstractTypeParams[0], includeParams);
		}
		if (abstractType.name == "Function" && abstractType.pack.length == 1 && abstractType.pack[0] == "haxe") {
			return "Function";
		}
		var underlyingType = abstractType.type;
		switch (underlyingType) {
			case TAbstract(t, underlyingParams):
				var result = baseTypeToQname(abstractType, abstractTypeParams, false);
				var compareTo = baseTypeToQname(t.get(), underlyingParams, false);
				if (result == compareTo) {
					// this avoids an infinite loop
					return baseTypeToQname(abstractType, abstractTypeParams, includeParams);
				}
			default:
		}
		
		if (includeParams) {
			var abstractTypeQname = baseTypeToQname(abstractType, abstractTypeParams, false);
			var paramsToInclude:Array<Type> = null;
			switch (underlyingType) {
				case TInst(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams.map((param) -> {
						return translateTypeParam(param, abstractTypeQname, abstractType.params, abstractTypeParams);
					});
				case TAbstract(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				case TEnum(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				case TType(t, underlyingTypeParams):
					paramsToInclude = underlyingTypeParams;
				default:
					paramsToInclude = [];
			}
			return macroTypeToQname(underlyingType, false) + generateQnameParams(paramsToInclude);
		}

		return macroTypeToQname(underlyingType, includeParams);
	}
	
	private function translateTypeParam(typeParam:Type, typeParametersQname:String, typeParameters:Array<TypeParameter>, params:Array<Type>):Type {
		switch (typeParam) {
			case TInst(t, _):
				var classType = t.get();
				switch (classType.kind) {
					case KTypeParameter(constraints):
						var typeParamSourceQname = classType.pack.join(".");
						if (typeParamSourceQname == typeParametersQname) {
							for (j in 0...typeParameters.length) {
								var param = typeParameters[j];
								if (param.name == classType.name) {
									return params[j];
								}
							}
						}
					default:
				}
			default:
		}
		return typeParam;
	}

	private function writeGenerated(outputDirPath:String, baseType:BaseType, generated:String):Void {
		var outputFilePath = getFileOutputPath(outputDirPath, baseType);
		FileSystem.createDirectory(Path.directory(outputFilePath));
		var fileOutput = File.write(outputFilePath);
		fileOutput.writeString(generated);
		fileOutput.close();
	}

	private function getFileOutputPath(dirPath:String, baseType:BaseType):String {
		var qname = baseTypeToQname(baseType, []);
		var relativePath = qname.split(".").join("/") + ".d.ts";
		return Path.join([dirPath, relativePath]);
	}

	private function relativizePath(path:String, relativeToPath:String):String {
		var currentPath = path;
        var stack:Array<String> = [];
        stack.push(Path.withoutDirectory(currentPath));
        var currentPath = Path.directory(currentPath);
        while (currentPath.length > 0) {
            if (StringTools.startsWith(relativeToPath, currentPath + "/")) {
                var relativeRelativeToFile = relativeToPath.substring(currentPath.length + 1);
                var separatorCount = relativeRelativeToFile.length - ~/\//g.replace(relativeRelativeToFile, "").length;
                var result = "";
                while (separatorCount > 0) {
                    result += "../";
                    separatorCount--;
                }
                while (stack.length > 0) {
                    result += stack.pop();
                }
				if (!StringTools.startsWith(result, ".")) {
					result = "./" + result;
				}
                return result;
            }
            stack.push(Path.withoutDirectory(currentPath) + "/");
            currentPath = Path.directory(currentPath);
        }
        return "";
    }
}

typedef TSGeneratorOptions = {
	/**
		Externs will be generated for symbols in the specified packages only,
		and no externs will be generated for symbols in other packages.

		Types from other packages may still be referenced by fields or method
		signatures. Use `allowedPackageReferences` to restrict those too.
	**/
	?includedPackages:Array<String>,

	/**
		When `includedPackages` is not empty, `allowedPackageReferences` may
		be used to allow types from other packages to be used for field types,
		method parameter types, and method return types. Otherwise, the types
		will be replaced with TS's `any` type.
			
		All package references are allowed by default. If in doubt, pass an
		empty array to restrict all types that don't appear in
		`includedPackages`.
	**/
	?allowedPackageReferences:Array<String>,

	/**
		Gives specific symbols new names. Alternates between the original symbol
		name and its new name.
	**/
	?renameSymbols:Array<String>,

	/**
		Optionally exclude specific symbols.
	**/
	?excludeSymbols:Array<String>,

	/**
		The target directory where externs files will be generated.
	**/
	?outputPath:String
}

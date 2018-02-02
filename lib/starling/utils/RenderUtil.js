// Class: starling.utils.RenderUtil

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this

$global.Object.defineProperty(exports, "__esModule", {value: true});

var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
var $bind = require("./../../bind_stub").default;
function starling_core_Starling() {return require("./../../starling/core/Starling");}
function starling_utils_Color() {return require("./../../starling/utils/Color");}
function openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$() {return require("./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_");}
function openfl_display3D__$Context3DWrapMode_Context3DWrapMode_$Impl_$() {return require("./../../openfl/display3D/_Context3DWrapMode/Context3DWrapMode_Impl_");}
function openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$() {return require("./../../openfl/display3D/_Context3DTextureFilter/Context3DTextureFilter_Impl_");}
function openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$() {return require("./../../openfl/display3D/_Context3DMipFilter/Context3DMipFilter_Impl_");}
function Std() {return require("./../../Std");}
function js_Boot() {return require("./../../js/Boot");}
function js__$Boot_HaxeError() {return require("./../../js/_Boot/HaxeError");}
function openfl_errors_ArgumentError() {return $import(require("openfl/errors/ArgumentError"));}
function starling_utils_Execute() {return require("./../../starling/utils/Execute");}
function openfl_errors_Error() {return $import(require("openfl/errors/Error"));}
function haxe_Timer() {return require("./../../haxe/Timer");}
function openfl_display3D__$Context3DRenderMode_Context3DRenderMode_$Impl_$() {return require("./../../openfl/display3D/_Context3DRenderMode/Context3DRenderMode_Impl_");}

// Constructor

var RenderUtil = function() {
}

// Meta

RenderUtil.__name__ = ["starling","utils","RenderUtil"];
RenderUtil.prototype = {
	
};
RenderUtil.prototype.__class__ = $hxClasses["starling.utils.RenderUtil"] = RenderUtil;

// Init



// Statics

RenderUtil.clear = function(rgb,alpha,depth,stencil) {
	if(stencil == null) {
		stencil = 0;
	}
	if(depth == null) {
		depth = 1.0;
	}
	if(alpha == null) {
		alpha = 0.0;
	}
	if(rgb == null) {
		rgb = 0;
	}
	(starling_core_Starling().default).get_current().get_context().clear((starling_utils_Color().default).getRed(rgb) / 255.0,(starling_utils_Color().default).getGreen(rgb) / 255.0,(starling_utils_Color().default).getBlue(rgb) / 255.0,alpha,depth,stencil);
}
RenderUtil.getTextureLookupFlags = function(format,mipMapping,repeat,smoothing) {
	if(smoothing == null) {
		smoothing = "bilinear";
	}
	if(repeat == null) {
		repeat = false;
	}
	var options = ["2d",repeat ? "repeat" : "clamp"];
	if((openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$().default).fromString(format) == 3) {
		options.push("dxt1");
	} else if(format == "compressedAlpha") {
		options.push("dxt5");
	}
	if(smoothing == "none") {
		options.push("nearest");
		options.push(mipMapping ? "mipnearest" : "mipnone");
	} else if(smoothing == "bilinear") {
		options.push("linear");
		options.push(mipMapping ? "mipnearest" : "mipnone");
	} else {
		options.push("linear");
		options.push(mipMapping ? "miplinear" : "mipnone");
	}
	return "<" + options.join(",") + ">";
}
RenderUtil.getTextureVariantBits = function(texture) {
	if(texture == null) {
		return 0;
	}
	var bitField = 0;
	var formatBits = 0;
	var _g = texture.get_format();
	switch(_g) {
	case 3:
		formatBits = 2;
		break;
	case 4:
		formatBits = 3;
		break;
	default:
		formatBits = 1;
	}
	bitField = bitField | formatBits;
	if(!texture.get_premultipliedAlpha()) {
		bitField = bitField | 4;
	}
	return bitField;
}
RenderUtil.setSamplerStateAt = function(sampler,mipMapping,smoothing,repeat) {
	if(repeat == null) {
		repeat = false;
	}
	if(smoothing == null) {
		smoothing = "bilinear";
	}
	var wrap = repeat ? (openfl_display3D__$Context3DWrapMode_Context3DWrapMode_$Impl_$().default).toString(2) : (openfl_display3D__$Context3DWrapMode_Context3DWrapMode_$Impl_$().default).toString(0);
	var filter;
	var mipFilter;
	if(smoothing == "none") {
		filter = (openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$().default).toString(5);
		if(mipMapping) {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(1);
		} else {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(2);
		}
	} else if(smoothing == "bilinear") {
		filter = (openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$().default).toString(4);
		if(mipMapping) {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(1);
		} else {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(2);
		}
	} else {
		filter = (openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$().default).toString(4);
		if(mipMapping) {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(0);
		} else {
			mipFilter = (openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).toString(2);
		}
	}
	(starling_core_Starling().default).get_current().get_context().setSamplerStateAt(sampler,(openfl_display3D__$Context3DWrapMode_Context3DWrapMode_$Impl_$().default).fromString(wrap),(openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$().default).fromString(filter),(openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$().default).fromString(mipFilter));
}
RenderUtil.createAGALTexOperation = function(resultReg,uvReg,sampler,texture,convertToPmaIfRequired,tempReg) {
	if(tempReg == null) {
		tempReg = "ft0";
	}
	if(convertToPmaIfRequired == null) {
		convertToPmaIfRequired = true;
	}
	var format = texture.get_format();
	var formatFlag;
	switch(format) {
	case 3:
		formatFlag = "dxt1";
		break;
	case 4:
		formatFlag = "dxt5";
		break;
	default:
		formatFlag = "rgba";
	}
	var needsConversion = convertToPmaIfRequired && !texture.get_premultipliedAlpha();
	var texReg = needsConversion && resultReg == "oc" ? tempReg : resultReg;
	var operation = "tex " + texReg + ", " + uvReg + ", fs" + sampler + " <2d, " + formatFlag + ">\n";
	if(needsConversion) {
		if(resultReg == "oc") {
			operation += "mul " + texReg + ".xyz, " + texReg + ".xyz, " + texReg + ".www\n";
			operation += "mov " + resultReg + ", " + texReg;
		} else {
			operation += "mul " + resultReg + ".xyz, " + texReg + ".xyz, " + texReg + ".www\n";
		}
	}
	return operation;
}
RenderUtil.requestContext3D = function(stage3D,renderMode,profile) {
	var profiles;
	var currentProfile;
	if(profile == "auto") {
		profiles = ["standardExtended","standard","standardConstrained","baselineExtended","baseline","baselineConstrained"];
	} else if(typeof(profile) == "string") {
		profiles = [(Std().default).string(profile)];
	} else if((profile instanceof Array) && profile.__enum__ == null) {
		profiles = (js_Boot().default).__cast(profile , Array);
	} else {
		throw new (js__$Boot_HaxeError().default)(new (openfl_errors_ArgumentError().default)("Profile must be of type 'String' or 'Array'"));
	}
	var requestNextProfile = null;
	var onFinished = null;
	var onError = null;
	var onCreated = null;
	requestNextProfile = function() {
		currentProfile = profiles.shift();
		try {
			(starling_utils_Execute().default).execute($bind(stage3D,stage3D.requestContext3D),[renderMode,currentProfile]);
		} catch( error ) {
			if (error instanceof (js__$Boot_HaxeError().default)) error = error.val;
			if( (js_Boot().default).__instanceof(error,(openfl_errors_Error().default)) ) {
				if(profiles.length != 0) {
					(haxe_Timer().default).delay(requestNextProfile,1);
				} else {
					throw new (js__$Boot_HaxeError().default)(error);
				}
			} else throw(error);
		}
	};
	onCreated = function(event) {
		var context = stage3D.context3D;
		if((openfl_display3D__$Context3DRenderMode_Context3DRenderMode_$Impl_$().default).fromString(renderMode) == 0 && profiles.length != 0 && context.driverInfo.indexOf("Software") != -1) {
			onError(event);
		} else {
			onFinished();
		}
	};
	onError = function(event1) {
		if(profiles.length != 0) {
			event1.stopImmediatePropagation();
			(haxe_Timer().default).delay(requestNextProfile,1);
		} else {
			onFinished();
		}
	};
	onFinished = function() {
		stage3D.removeEventListener("context3DCreate",onCreated);
		stage3D.removeEventListener("error",onError);
	};
	stage3D.addEventListener("context3DCreate",onCreated,false,100);
	stage3D.addEventListener("error",onError,false,100);
	requestNextProfile();
}


// Export

exports.default = RenderUtil;
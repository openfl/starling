package starling.rendering;

import starling.core.Starling;
import starling.errors.MissingContextError;

@:jsRequire("starling/rendering/Program", "default")

extern class Program implements Dynamic {

	function new(vertexShader:Dynamic, fragmentShader:Dynamic);
	var _vertexShader:Dynamic;
	var _fragmentShader:Dynamic;
	var _program3D:Dynamic;
	function dispose():Dynamic;
	function activate(?context:Dynamic):Dynamic;
	function onContextCreated(event:Dynamic):Dynamic;
	function disposeProgram():Dynamic;
	static var sAssembler:Dynamic;
	static function fromSource(vertexShader:Dynamic, fragmentShader:Dynamic, ?agalVersion:Dynamic):Dynamic;


}
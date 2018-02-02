package starling.rendering;

import starling.core.Starling;
import starling.errors.MissingContextError;

@:jsRequire("starling/rendering/Program", "default")

extern class Program {
	function new(vertexShader : openfl.utils.ByteArray, fragmentShader : openfl.utils.ByteArray) : Void;
	function activate(?context : openfl.display3D.Context3D) : Void;
	function dispose() : Void;
	static function fromSource(vertexShader : String, fragmentShader : String, agalVersion : UInt = 0) : Program;
}

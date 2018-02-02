package starling.errors;



@:jsRequire("starling/errors/NotSupportedError", "default")

extern class NotSupportedError extends openfl.errors.Error {
	function new(?message : String, id : Int = 0) : Void;
}
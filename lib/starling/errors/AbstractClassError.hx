package starling.errors;



@:jsRequire("starling/errors/AbstractClassError", "default")

extern class AbstractClassError extends openfl.errors.Error {
	function new(?message : String, id : Int = 0) : Void;
}
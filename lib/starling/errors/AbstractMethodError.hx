package starling.errors;



@:jsRequire("starling/errors/AbstractMethodError", "default")

extern class AbstractMethodError extends openfl.errors.Error {
	function new(?message : String, id : Int = 0) : Void;
}
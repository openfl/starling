package starling.errors;



@:jsRequire("starling/errors/MissingContextError", "default")

extern class MissingContextError extends openfl.errors.Error {
	function new(?message : String, id : Int = 0) : Void;
}
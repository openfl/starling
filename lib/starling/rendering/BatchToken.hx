package starling.rendering;

import starling.utils.StringUtil;

@:jsRequire("starling/rendering/BatchToken", "default")

extern class BatchToken {
	var batchID : Int;
	var indexID : Int;
	var vertexID : Int;
	function new(batchID : Int = 0, vertexID : Int = 0, indexID : Int = 0) : Void;
	function copyFrom(token : BatchToken) : Void;
	function equals(other : BatchToken) : Bool;
	function reset() : Void;
	function setTo(batchID : Int = 0, vertexID : Int = 0, indexID : Int = 0) : Void;
	function toString() : String;
}

package starling.rendering;

import haxe.ds.StringMap;

@:jsRequire("starling/rendering/VertexDataAttribute", "default")

extern class VertexDataAttribute {
	var format : String;
	var isColor : Bool;
	var name : String;
	var offset : Int;
	var size : Int;
	function new(name : String, format : String, offset : Int) : Void;
}

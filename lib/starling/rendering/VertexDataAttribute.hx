package starling.rendering;

import haxe.ds.StringMap;

@:jsRequire("starling/rendering/VertexDataAttribute", "default")

extern class VertexDataAttribute implements Dynamic {

	function new(name:Dynamic, format:Dynamic, offset:Dynamic);
	var name:Dynamic;
	var format:Dynamic;
	var isColor:Dynamic;
	var offset:Dynamic;
	var size:Dynamic;
	static var FORMAT_SIZES:Dynamic;


}
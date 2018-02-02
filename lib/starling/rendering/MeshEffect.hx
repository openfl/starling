package starling.rendering;

import starling.rendering.FilterEffect;
import starling.rendering.Program;
import Type;

@:jsRequire("starling/rendering/MeshEffect", "default")

extern class MeshEffect extends FilterEffect {
	var alpha(get,set) : Float;
	var tinted(get,set) : Bool;
	function new() : Void;
	static var VERTEX_FORMAT : VertexDataFormat;
}

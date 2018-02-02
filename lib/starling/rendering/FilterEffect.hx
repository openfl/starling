package starling.rendering;

import starling.rendering.Effect;
import starling.utils.RenderUtil;
import starling.rendering.Program;

@:jsRequire("starling/rendering/FilterEffect", "default")

extern class FilterEffect extends Effect {
	var texture(get,set) : starling.textures.Texture;
	var textureRepeat(get,set) : Bool;
	var textureSmoothing(get,set) : String;
	function new() : Void;
	static var STD_VERTEX_SHADER : String;
	static var VERTEX_FORMAT : VertexDataFormat;
}

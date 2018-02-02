package starling.display;

import starling.display.Mesh;
import starling.utils.RectangleUtil;
import starling.rendering.VertexData;
import starling.styles.MeshStyle;
import starling.rendering.IndexData;

@:jsRequire("starling/display/Quad", "default")

extern class Quad extends Mesh {
	function new(width : Float, height : Float, color : UInt = 0) : Void;
	function readjustSize(width : Float = 0, height : Float = 0) : Void;
	static function fromTexture(texture : starling.textures.Texture) : Quad;
}

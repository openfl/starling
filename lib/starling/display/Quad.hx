package starling.display;

import starling.display.Mesh;
import starling.utils.RectangleUtil;
import starling.rendering.VertexData;
import starling.styles.MeshStyle;
import starling.rendering.IndexData;

@:jsRequire("starling/display/Quad", "default")

extern class Quad extends starling.display.Mesh implements Dynamic {

	function new(width:Dynamic, height:Dynamic, ?color:Dynamic);
	var __bounds:Dynamic;
	function __setupVertices():Dynamic;
	override function getBounds(targetSpace:Dynamic, ?out:Dynamic):Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	function readjustSize(?width:Dynamic, ?height:Dynamic):Dynamic;
	override function set_texture(value:Dynamic):Dynamic;
	static var sPoint3D:Dynamic;
	static var sMatrix:Dynamic;
	static var sMatrix3D:Dynamic;
	static function fromTexture(texture:Dynamic):Dynamic;


}
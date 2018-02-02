package starling.textures;

import starling.textures.SubTexture;
import starling.core.Starling;
import starling.textures.Texture;
import starling.display.Image;

@:jsRequire("starling/textures/RenderTexture", "default")

extern class RenderTexture extends SubTexture {
	var isPersistent(get,never) : Bool;
	function new(width : Int, height : Int, persistent : Bool = false, scale : Float = 0, ?format : String) : Void;
	function clear(color : UInt = 0, alpha : Float = 0) : Void;
	function draw(object : starling.display.DisplayObject, ?matrix : openfl.geom.Matrix, alpha : Float = 0, antiAliasing : Int = 0) : Void;
	function drawBundled(drawingBlock : Void -> Void, antiAliasing : Int = 0) : Void;
	static var useDoubleBuffering(get,set) : Bool;
}

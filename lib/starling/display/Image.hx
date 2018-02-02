package starling.display;

import starling.display.Quad;
import starling.utils.MathUtil;
import starling.utils.Pool;
import starling.utils.RectangleUtil;
import Std;
import haxe.ds.ObjectMap;
import starling.utils.Padding;
// import starling.display.TextureSetupSettings;

@:jsRequire("starling/display/Image", "default")

extern class Image extends Quad {
	var scale9Grid(get,set) : openfl.geom.Rectangle;
	var tileGrid(get,set) : openfl.geom.Rectangle;
	function new(texture : starling.textures.Texture) : Void;
	static function automateSetupForTexture(texture : starling.textures.Texture, onAssign : Image -> Void, onRelease : Null<Image -> Void> = null) : Void;
	static function bindPivotPointToTexture(texture : starling.textures.Texture, pivotX : Float, pivotY : Float) : Void;
	static function bindScale9GridToTexture(texture : starling.textures.Texture, scale9Grid : openfl.geom.Rectangle) : Void;
	static function resetSetupForTexture(texture : starling.textures.Texture) : Void;
}

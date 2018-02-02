package starling.textures;

import starling.textures.Texture;
import starling.errors.NotSupportedError;
import starling.errors.AbstractMethodError;
import starling.utils.Color;
import Std;
import starling.core.Starling;
import js.Boot;

@:jsRequire("starling/textures/ConcreteTexture", "default")

extern class ConcreteTexture extends Texture {
	var isPotTexture(get,never) : Bool;
	var onRestore(get,set) : ConcreteTexture -> Void;
	var optimizedForRenderTexture(get,never) : Bool;
	function attachNetStream(netStream : openfl.net.NetStream, onComplete : Null<ConcreteTexture -> Void> = null) : Void;
	function clear(color : UInt = 0, alpha : Float = 0) : Void;
	function uploadAtfData(data : openfl.utils.ByteArray, offset : Int = 0, async : Null<ConcreteTexture -> Void> = null) : Void;
	function uploadBitmap(bitmap : openfl.display.Bitmap, async : Null<ConcreteTexture -> Void> = null) : Void;
	function uploadBitmapData(data : openfl.display.BitmapData, async : Null<ConcreteTexture -> Void> = null) : Void;
}

package starling.textures {

	import openfl.display.Bitmap;
	import openfl.display.BitmapData;
	import openfl.net.NetStream;
	import openfl.utils.ByteArray;
	import starling.textures.Texture;
	import starling.errors.NotSupportedError;
	import starling.errors.AbstractMethodError;
	import starling.utils.Color;
	import starling.core.Starling;

	/**
	 * @externs
	 */
	public class ConcreteTexture extends Texture {
		public function get isPotTexture():Boolean { return false; }
		public var onRestore:Function;
		public function get optimizedForRenderTexture():Boolean { return false; }
		public function attachNetStream(netStream:openfl.net.NetStream, onComplete:Function = null):void {}
		public function clear(color:uint = 0, alpha:Number = 0):void {}
		public function uploadAtfData(data:openfl.utils.ByteArray, offset:int = 0, async:Function = null):void {}
		public function uploadBitmap(bitmap:openfl.display.Bitmap, async:Function = null):void {}
		public function uploadBitmapData(data:openfl.display.BitmapData, async:Function = null):void {}
	}

}
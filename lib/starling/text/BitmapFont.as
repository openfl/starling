package starling.text {

	// import openfl.Vector;
	import starling.text.ITextCompositor;
	import starling.textures.Texture;
	import starling.text.BitmapChar;
	import starling.display.MeshBatch;
	import starling.display.Sprite;
	// import starling.text.CharLocation;
	// import starling.utils.ArrayUtil;
	import starling.text.TextOptions;
	// import starling.text.MiniBitmapFont;
	import starling.textures.Texture;
	import starling.display.Image;

	/**
	 * @externs
	 */
	public class BitmapFont implements ITextCompositor {
		public var baseline:Number;
		public function get lineHeight():Number { return 0; }
		public function get name():String { return null; }
		public var offsetX:Number;
		public var offsetY:Number;
		public var padding:Number;
		public function get size():Number { return 0; }
		public var smoothing:String;
		public function BitmapFont(texture:starling.textures.Texture = null, fontXml:Object = null):void {}
		public function addChar(charID:int, bitmapChar:BitmapChar):void {}
		public function clearMeshBatch(meshBatch:starling.display.MeshBatch):void {}
		public function createSprite(width:Number, height:Number, text:String, format:TextFormat, options:TextOptions = null):starling.display.Sprite { return null; }
		public function dispose():void {}
		public function fillMeshBatch(meshBatch:starling.display.MeshBatch, width:Number, height:Number, text:String, format:TextFormat, options:TextOptions = null):void {}
		public function getChar(charID:int):BitmapChar { return null; }
		public function getCharIDs(result:Vector.<int> = null):Vector.<int> { return null; }
		public function hasChars(text:String):Boolean { return false; }
		public static function get MINI ():String { return null; }
		public static function get NATIVE_SIZE ():int { return 0; }
	}

}
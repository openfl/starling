package starling.textures {

	import openfl.display.Bitmap;
	import openfl.display.BitmapData;
	import openfl.display3D.textures.TextureBase;
	import openfl.geom.Matrix;
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	import openfl.net.NetStream;
	import openfl.utils.ByteArray;
	import starling.utils.MatrixUtil;
	import starling.textures.TextureOptions;
	import starling.textures.ConcretePotTexture;
	import starling.textures.ConcreteRectangleTexture;
	import starling.textures.ConcreteVideoTexture;
	import starling.core.Starling;
	import starling.errors.MissingContextError;
	import starling.textures.AtfData;
	import starling.utils.SystemUtil;
	import starling.errors.NotSupportedError;
	import starling.utils.MathUtil;
	import starling.rendering.VertexData;
	import starling.textures.SubTexture;

	/**
	 * @externs
	 */
	public class Texture {
		public function get base():openfl.display3D.textures.TextureBase { return null; }
		public function get format():String { return null; }
		public function get frame():openfl.geom.Rectangle { return null; }
		public function get frameHeight():Number { return 0; }
		public function get frameWidth():Number { return 0; }
		public function get height():Number { return 0; }
		public function get mipMapping():Boolean { return false; }
		public function get nativeHeight():Number { return 0; }
		public function get nativeWidth():Number { return 0; }
		public function get premultipliedAlpha():Boolean { return false; }
		public function get root():ConcreteTexture { return null; }
		public function get scale():Number { return 0; }
		public function get transformationMatrix():openfl.geom.Matrix { return null; }
		public function get transformationMatrixToRoot():openfl.geom.Matrix { return null; }
		public function get width():Number { return 0; }
		public function dispose():void {}
		public function getTexCoords(vertexData:starling.rendering.VertexData, vertexID:int, attrName:String = null, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function globalToLocal(u:Number, v:Number, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function localToGlobal(u:Number, v:Number, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function setTexCoords(vertexData:starling.rendering.VertexData, vertexID:int, attrName:String, u:Number, v:Number):void {}
		public function setupTextureCoordinates(vertexData:starling.rendering.VertexData, vertexID:int = 0, attrName:String = null):void {}
		public function setupVertexPositions(vertexData:starling.rendering.VertexData, vertexID:int = 0, attrName:String = null, bounds:openfl.geom.Rectangle = null):void {}
		public static var asyncBitmapUploadEnabled:Boolean;
		public static function get maxSize():int { return 0; }
		public static function empty(width:Number, height:Number, premultipliedAlpha:Boolean = false, mipMapping:Boolean = false, optimizeForRenderToTexture:Boolean = false, scale:Number = 0, format:String = null, forcePotTexture:Boolean = false):Texture { return null; }
		public static function fromAtfData(data:openfl.utils.ByteArray, scale:Number = 0, useMipMaps:Boolean = false, async:Function = null, premultipliedAlpha:Boolean = false):Texture { return null; }
		public static function fromBitmap(bitmap:openfl.display.Bitmap, generateMipMaps:Boolean = false, optimizeForRenderToTexture:Boolean = false, scale:Number = 0, format:String = null, forcePotTexture:Boolean = false, async:Function = null):Texture { return null; }
		public static function fromBitmapData(data:openfl.display.BitmapData, generateMipMaps:Boolean = false, optimizeForRenderToTexture:Boolean = false, scale:Number = 0, format:String = null, forcePotTexture:Boolean = false, async:Function = null):Texture { return null; }
		public static function fromColor(width:Number, height:Number, color:uint = 0, alpha:Number = 0, optimizeForRenderToTexture:Boolean = false, scale:Number = 0, format:String = null, forcePotTexture:Boolean = false):Texture { return null; }
		public static function fromData(data:Object, options:TextureOptions = null):Texture { return null; }
		public static function fromEmbeddedAsset(assetClass:Class, mipMapping:Boolean = false, optimizeForRenderToTexture:Boolean = false, scale:Number = 0, format:String = null, forcePotTexture:Boolean = false):Texture { return null; }
		public static function fromNetStream(stream:openfl.net.NetStream, scale:Number = 0, onComplete:Function = null):Texture { return null; }
		public static function fromTexture(texture:Texture, region:openfl.geom.Rectangle = null, frame:openfl.geom.Rectangle = null, rotated:Boolean = false, scaleModifier:Number = 0):Texture { return null; }
		public static function fromTextureBase(base:openfl.display3D.textures.TextureBase, width:int, height:int, options:TextureOptions = null):ConcreteTexture { return null; }
	}

}
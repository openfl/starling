package starling.utils {

	import openfl.display.Stage3D;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.Execute;

	/**
	 * @externs
	 */
	public class RenderUtil {
		public static function clear(rgb:uint = 0, alpha:Number = 0, depth:Number = 0, stencil:uint = 0):void {}
		public static function createAGALTexOperation(resultReg:String, uvReg:String, sampler:int, texture:starling.textures.Texture, convertToPmaIfRequired:Boolean = false, tempReg:String = null):String { return null; }
		public static function getTextureLookupFlags(format:String, mipMapping:Boolean, repeat:Boolean = false, smoothing:String = null):String { return null; }
		public static function getTextureVariantBits(texture:starling.textures.Texture):uint { return 0; }
		public static function requestContext3D(stage3D:openfl.display.Stage3D, renderMode:String, profile:Object):void {}
		public static function setSamplerStateAt(sampler:int, mipMapping:Boolean, smoothing:String = null, repeat:Boolean = false):void {}
	}

}
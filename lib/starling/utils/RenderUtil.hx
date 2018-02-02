package starling.utils;

import starling.core.Starling;
import starling.utils.Color;
import Std;
import js.Boot;
import starling.utils.Execute;
import haxe.Timer;

@:jsRequire("starling/utils/RenderUtil", "default")

extern class RenderUtil {
	static function clear(rgb : UInt = 0, alpha : Float = 0, depth : Float = 0, stencil : UInt = 0) : Void;
	static function createAGALTexOperation(resultReg : String, uvReg : String, sampler : Int, texture : starling.textures.Texture, convertToPmaIfRequired : Bool = false, ?tempReg : String) : String;
	static function getTextureLookupFlags(format : String, mipMapping : Bool, repeat : Bool = false, ?smoothing : String) : String;
	static function getTextureVariantBits(texture : starling.textures.Texture) : UInt;
	static function requestContext3D(stage3D : openfl.display.Stage3D, renderMode : String, profile : Dynamic) : Void;
	static function setSamplerStateAt(sampler : Int, mipMapping : Bool, ?smoothing : String, repeat : Bool = false) : Void;
}

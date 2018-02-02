package starling.utils;

import starling.core.Starling;
import starling.utils.Color;
import Std;
import js.Boot;
import starling.utils.Execute;
import haxe.Timer;

@:jsRequire("starling/utils/RenderUtil", "default")

extern class RenderUtil implements Dynamic {

	function new();
	static function clear(?rgb:Dynamic, ?alpha:Dynamic, ?depth:Dynamic, ?stencil:Dynamic):Dynamic;
	static function getTextureLookupFlags(format:Dynamic, mipMapping:Dynamic, ?repeat:Dynamic, ?smoothing:Dynamic):Dynamic;
	static function getTextureVariantBits(texture:Dynamic):Dynamic;
	static function setSamplerStateAt(sampler:Dynamic, mipMapping:Dynamic, ?smoothing:Dynamic, ?repeat:Dynamic):Dynamic;
	static function createAGALTexOperation(resultReg:Dynamic, uvReg:Dynamic, sampler:Dynamic, texture:Dynamic, ?convertToPmaIfRequired:Dynamic, ?tempReg:Dynamic):Dynamic;
	static function requestContext3D(stage3D:Dynamic, renderMode:Dynamic, profile:Dynamic):Dynamic;


}
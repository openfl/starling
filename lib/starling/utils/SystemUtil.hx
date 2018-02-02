package starling.utils;

import HxOverrides;
import js.Boot;
import Reflect;
import haxe.Log;

@:jsRequire("starling/utils/SystemUtil", "default")

extern class SystemUtil implements Dynamic {

	static var sInitialized:Dynamic;
	static var sApplicationActive:Dynamic;
	static var sWaitingCalls:Dynamic;
	static var sPlatform:Dynamic;
	static var sVersion:Dynamic;
	static var sAIR:Dynamic;
	static var sEmbeddedFonts:Dynamic;
	static var sSupportsDepthAndStencil:Dynamic;
	static function initialize():Dynamic;
	static function onActivate(event:Dynamic):Dynamic;
	static function onDeactivate(event:Dynamic):Dynamic;
	static function executeWhenApplicationIsActive(call:Dynamic, args:Dynamic):Dynamic;
	static var isApplicationActive:Dynamic;
	static function get_isApplicationActive():Dynamic;
	static var isAIR:Dynamic;
	static function get_isAIR():Dynamic;
	static var version:Dynamic;
	static function get_version():Dynamic;
	static var platform:Dynamic;
	static function get_platform():Dynamic;
	static function set_platform(value:Dynamic):Dynamic;
	static var supportsDepthAndStencil:Dynamic;
	static function get_supportsDepthAndStencil():Dynamic;
	static var supportsVideoTexture:Dynamic;
	static function get_supportsVideoTexture():Dynamic;
	static function updateEmbeddedFonts():Dynamic;
	static function isEmbeddedFont(fontName:Dynamic, ?bold:Dynamic, ?italic:Dynamic, ?fontType:Dynamic):Dynamic;
	static var isIOS:Dynamic;
	static function get_isIOS():Dynamic;
	static var isAndroid:Dynamic;
	static function get_isAndroid():Dynamic;
	static var isMac:Dynamic;
	static function get_isMac():Dynamic;
	static var isWindows:Dynamic;
	static function get_isWindows():Dynamic;
	static var isDesktop:Dynamic;
	static function get_isDesktop():Dynamic;


}
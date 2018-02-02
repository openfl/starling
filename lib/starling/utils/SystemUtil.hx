package starling.utils;

import HxOverrides;
import js.Boot;
import Reflect;
import haxe.Log;

@:jsRequire("starling/utils/SystemUtil", "default")

extern class SystemUtil {
	static var isAIR(get,never) : Bool;
	static var isAndroid(get,never) : Bool;
	static var isApplicationActive(get,never) : Bool;
	static var isDesktop(get,never) : Bool;
	static var isIOS(get,never) : Bool;
	static var isMac(get,never) : Bool;
	static var isWindows(get,never) : Bool;
	static var platform(get,set) : String;
	static var supportsDepthAndStencil(get,never) : Bool;
	static var supportsVideoTexture(get,never) : Bool;
	static var version(get,never) : String;
	static function executeWhenApplicationIsActive(call : haxe.Constraints.Function, args : Array<Dynamic>) : Void;
	static function initialize() : Void;
	static function isEmbeddedFont(fontName : String, bold : Bool = false, italic : Bool = false, ?fontType : String) : Bool;
	static function updateEmbeddedFonts() : Void;
}

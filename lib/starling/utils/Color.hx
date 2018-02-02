package starling.utils;

import Std;

@:jsRequire("starling/utils/Color", "default")

extern class Color implements Dynamic {

	static var WHITE:Dynamic;
	static var SILVER:Dynamic;
	static var GRAY:Dynamic;
	static var BLACK:Dynamic;
	static var RED:Dynamic;
	static var MAROON:Dynamic;
	static var YELLOW:Dynamic;
	static var OLIVE:Dynamic;
	static var LIME:Dynamic;
	static var GREEN:Dynamic;
	static var AQUA:Dynamic;
	static var TEAL:Dynamic;
	static var BLUE:Dynamic;
	static var NAVY:Dynamic;
	static var FUCHSIA:Dynamic;
	static var PURPLE:Dynamic;
	static function getAlpha(color:Dynamic):Dynamic;
	static function getRed(color:Dynamic):Dynamic;
	static function getGreen(color:Dynamic):Dynamic;
	static function getBlue(color:Dynamic):Dynamic;
	static function setAlpha(color:Dynamic, alpha:Dynamic):Dynamic;
	static function setRed(color:Dynamic, red:Dynamic):Dynamic;
	static function setGreen(color:Dynamic, green:Dynamic):Dynamic;
	static function setBlue(color:Dynamic, blue:Dynamic):Dynamic;
	static function rgb(red:Dynamic, green:Dynamic, blue:Dynamic):Dynamic;
	static function argb(alpha:Dynamic, red:Dynamic, green:Dynamic, blue:Dynamic):Dynamic;
	static function toVector(color:Dynamic, ?out:Dynamic):Dynamic;
	static function multiply(color:Dynamic, factor:Dynamic):Dynamic;
	static function interpolate(startColor:Dynamic, endColor:Dynamic, ratio:Dynamic):Dynamic;


}
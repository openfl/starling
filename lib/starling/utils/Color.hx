package starling.utils;

import Std;

@:jsRequire("starling/utils/Color", "default")

extern class Color {
	static var AQUA(default,never) : UInt;
	static var BLACK(default,never) : UInt;
	static var BLUE(default,never) : UInt;
	static var FUCHSIA(default,never) : UInt;
	static var GRAY(default,never) : UInt;
	static var GREEN(default,never) : UInt;
	static var LIME(default,never) : UInt;
	static var MAROON(default,never) : UInt;
	static var NAVY(default,never) : UInt;
	static var OLIVE(default,never) : UInt;
	static var PURPLE(default,never) : UInt;
	static var RED(default,never) : UInt;
	static var SILVER(default,never) : UInt;
	static var TEAL(default,never) : UInt;
	static var WHITE(default,never) : UInt;
	static var YELLOW(default,never) : UInt;
	static function argb(alpha : Int, red : Int, green : Int, blue : Int) : UInt;
	static function getAlpha(color : UInt) : Int;
	static function getBlue(color : UInt) : Int;
	static function getGreen(color : UInt) : Int;
	static function getRed(color : UInt) : Int;
	static function interpolate(startColor : UInt, endColor : UInt, ratio : Float) : UInt;
	static function multiply(color : UInt, factor : Float) : UInt;
	static function rgb(red : Int, green : Int, blue : Int) : UInt;
	static function setAlpha(color : UInt, alpha : Int) : UInt;
	static function setBlue(color : UInt, blue : Int) : UInt;
	static function setGreen(color : UInt, green : Int) : UInt;
	static function setRed(color : UInt, red : Int) : UInt;
	static function toVector(color : UInt, ?out : openfl.Vector<Float>) : openfl.Vector<Float>;
}

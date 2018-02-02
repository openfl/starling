package starling.utils;

import Std;

@:jsRequire("starling/utils/MathUtil", "default")

extern class MathUtil implements Dynamic {

	static var TWO_PI:Dynamic;
	static function intersectLineWithXYPlane(pointA:Dynamic, pointB:Dynamic, ?out:Dynamic):Dynamic;
	static function isPointInTriangle(p:Dynamic, a:Dynamic, b:Dynamic, c:Dynamic):Dynamic;
	static function normalizeAngle(angle:Dynamic):Dynamic;
	static function getNextPowerOfTwo(number:Dynamic):Dynamic;
	static function isEquivalent(a:Dynamic, b:Dynamic, ?epsilon:Dynamic):Dynamic;
	static function max(a:Dynamic, b:Dynamic):Dynamic;
	static function min(a:Dynamic, b:Dynamic):Dynamic;
	static function clamp(value:Dynamic, min:Dynamic, max:Dynamic):Dynamic;
	static function minValues(values:Dynamic):Dynamic;
	static function deg2rad(deg:Dynamic):Dynamic;
	static function rad2deg(rad:Dynamic):Dynamic;
	static function toFixed(value:Dynamic, precision:Dynamic):Dynamic;


}
package starling.utils;

import Std;

@:jsRequire("starling/utils/MathUtil", "default")

extern class MathUtil {
	static function clamp(value : Float, min : Float, max : Float) : Float;
	static function deg2rad(deg : Float) : Float;
	static function getNextPowerOfTwo(number : Float) : Int;
	static function intersectLineWithXYPlane(pointA : openfl.geom.Vector3D, pointB : openfl.geom.Vector3D, ?out : openfl.geom.Point) : openfl.geom.Point;
	static function isEquivalent(a : Float, b : Float, epsilon : Float = 0) : Bool;
	static function isPointInTriangle(p : openfl.geom.Point, a : openfl.geom.Point, b : openfl.geom.Point, c : openfl.geom.Point) : Bool;
	static function max(a : Float, b : Float) : Float;
	static function min(a : Float, b : Float) : Float;
	static function minValues(values : Array<Float>) : Float;
	static function normalizeAngle(angle : Float) : Float;
	static function rad2deg(rad : Float) : Float;
	static function toFixed(value : Float, precision : Int) : String;
}

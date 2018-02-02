package starling.utils;

import starling.utils.ScaleMode;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;

@:jsRequire("starling/utils/RectangleUtil", "default")

extern class RectangleUtil {
	static function compare(r1 : openfl.geom.Rectangle, r2 : openfl.geom.Rectangle, e : Float = 0) : Bool;
	static function extend(rect : openfl.geom.Rectangle, left : Float = 0, right : Float = 0, top : Float = 0, bottom : Float = 0) : Void;
	static function extendToWholePixels(rect : openfl.geom.Rectangle, scaleFactor : Float = 0) : Void;
	static function fit(rectangle : openfl.geom.Rectangle, into : openfl.geom.Rectangle, ?scaleMode : String, pixelPerfect : Bool = false, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	static function getBounds(rectangle : openfl.geom.Rectangle, matrix : openfl.geom.Matrix, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	static function getBoundsProjected(rectangle : openfl.geom.Rectangle, matrix : openfl.geom.Matrix3D, camPos : openfl.geom.Vector3D, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	static function getPositions(rectangle : openfl.geom.Rectangle, ?out : openfl.Vector<openfl.geom.Point>) : openfl.Vector<openfl.geom.Point>;
	static function intersect(rect1 : openfl.geom.Rectangle, rect2 : openfl.geom.Rectangle, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	static function normalize(rect : openfl.geom.Rectangle) : Void;
}

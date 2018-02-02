package starling.utils;

import starling.utils.ScaleMode;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;

@:jsRequire("starling/utils/RectangleUtil", "default")

extern class RectangleUtil implements Dynamic {

	static var sPoint:Dynamic;
	static var sPoint3D:Dynamic;
	static var sPositions:Dynamic;
	static function intersect(rect1:Dynamic, rect2:Dynamic, ?out:Dynamic):Dynamic;
	static function fit(rectangle:Dynamic, into:Dynamic, ?scaleMode:Dynamic, ?pixelPerfect:Dynamic, ?out:Dynamic):Dynamic;
	static function nextSuitableScaleFactor(factor:Dynamic, up:Dynamic):Dynamic;
	static function normalize(rect:Dynamic):Dynamic;
	static function extend(rect:Dynamic, ?left:Dynamic, ?right:Dynamic, ?top:Dynamic, ?bottom:Dynamic):Dynamic;
	static function extendToWholePixels(rect:Dynamic, ?scaleFactor:Dynamic):Dynamic;
	static function getBounds(rectangle:Dynamic, matrix:Dynamic, ?out:Dynamic):Dynamic;
	static function getBoundsProjected(rectangle:Dynamic, matrix:Dynamic, camPos:Dynamic, ?out:Dynamic):Dynamic;
	static function getPositions(rectangle:Dynamic, ?out:Dynamic):Dynamic;
	static function compare(r1:Dynamic, r2:Dynamic, ?e:Dynamic):Dynamic;


}
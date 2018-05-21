package starling.utils {

	import openfl.geom.Matrix3D;
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	// import openfl.Vector;
	import starling.utils.ScaleMode;
	import starling.utils.MatrixUtil;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class RectangleUtil {
		public static function compare(r1:openfl.geom.Rectangle, r2:openfl.geom.Rectangle, e:Number = 0):Boolean { return false; }
		public static function extend(rect:openfl.geom.Rectangle, left:Number = 0, right:Number = 0, top:Number = 0, bottom:Number = 0):void {}
		public static function extendToWholePixels(rect:openfl.geom.Rectangle, scaleFactor:Number = 0):void {}
		public static function fit(rectangle:openfl.geom.Rectangle, into:openfl.geom.Rectangle, scaleMode:String = null, pixelPerfect:Boolean = false, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public static function getBounds(rectangle:openfl.geom.Rectangle, matrix:openfl.geom.Matrix, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public static function getBoundsProjected(rectangle:openfl.geom.Rectangle, matrix:openfl.geom.Matrix3D, camPos:openfl.geom.Vector3D, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public static function getPositions(rectangle:openfl.geom.Rectangle, out:Vector<Point> = null):Vector<Point> { return null; }
		public static function intersect(rect1:openfl.geom.Rectangle, rect2:openfl.geom.Rectangle, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public static function normalize(rect:openfl.geom.Rectangle):void {}
	}

}
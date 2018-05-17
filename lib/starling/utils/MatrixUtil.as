package starling.utils {

	import openfl.geom.Matrix;
	import openfl.geom.Matrix3D;
	import openfl.geom.Point;
	import openfl.geom.Vector3D;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class MatrixUtil {
		public static function convertTo2D(matrix3D:openfl.geom.Matrix3D, out:openfl.geom.Matrix = null):openfl.geom.Matrix { return null; }
		public static function convertTo3D(matrix:openfl.geom.Matrix, out:openfl.geom.Matrix3D = null):openfl.geom.Matrix3D { return null; }
		public static function createOrthographicProjectionMatrix(x:Number, y:Number, width:Number, height:Number, out:openfl.geom.Matrix = null):openfl.geom.Matrix { return null; }
		public static function createPerspectiveProjectionMatrix(x:Number, y:Number, width:Number, height:Number, stageWidth:Number = 0, stageHeight:Number = 0, cameraPos:openfl.geom.Vector3D = null, out:openfl.geom.Matrix3D = null):openfl.geom.Matrix3D { return null; }
		public static function isIdentity(matrix:openfl.geom.Matrix):Boolean { return false; }
		public static function isIdentity3D(matrix:openfl.geom.Matrix3D):Boolean { return false; }
		public static function prependMatrix(base:openfl.geom.Matrix, prep:openfl.geom.Matrix):void {}
		public static function prependRotation(matrix:openfl.geom.Matrix, angle:Number):void {}
		public static function prependScale(matrix:openfl.geom.Matrix, sx:Number, sy:Number):void {}
		public static function prependSkew(matrix:openfl.geom.Matrix, skewX:Number, skewY:Number):void {}
		public static function prependTranslation(matrix:openfl.geom.Matrix, tx:Number, ty:Number):void {}
		public static function skew(matrix:openfl.geom.Matrix, skewX:Number, skewY:Number):void {}
		public static function snapToPixels(matrix:openfl.geom.Matrix, pixelSize:Number):void {}
		public static function toString(matrix:openfl.geom.Matrix, precision:int = 0):String { return null; }
		public static function toString3D(matrix:openfl.geom.Matrix3D, transpose:Boolean = false, precision:int = 0):String { return null; }
		public static function transformCoords(matrix:openfl.geom.Matrix, x:Number, y:Number, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public static function transformCoords3D(matrix:openfl.geom.Matrix3D, x:Number, y:Number, z:Number, out:openfl.geom.Vector3D = null):openfl.geom.Vector3D { return null; }
		public static function transformPoint(matrix:openfl.geom.Matrix, point:openfl.geom.Point, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public static function transformPoint3D(matrix:openfl.geom.Matrix3D, point:openfl.geom.Vector3D, out:openfl.geom.Vector3D = null):openfl.geom.Vector3D { return null; }
	}

}
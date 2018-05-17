package starling.utils {
	
	import openfl.geom.Matrix;
	import openfl.geom.Matrix3D;
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	import openfl.geom.Vector3D;
	
	/**
	 * @externs
	 */
	public class Pool {
		public static function getMatrix(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0, tx:Number = 0, ty:Number = 0):openfl.geom.Matrix { return null; }
		public static function getMatrix3D(identity:Boolean = false):openfl.geom.Matrix3D { return null; }
		public static function getPoint(x:Number = 0, y:Number = 0):openfl.geom.Point { return null; }
		public static function getPoint3D(x:Number = 0, y:Number = 0, z:Number = 0):openfl.geom.Vector3D { return null; }
		public static function getRectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):openfl.geom.Rectangle { return null; }
		public static function putMatrix(matrix:openfl.geom.Matrix):void {}
		public static function putMatrix3D(matrix:openfl.geom.Matrix3D):void {}
		public static function putPoint(point:openfl.geom.Point):void {}
		public static function putPoint3D(point:openfl.geom.Vector3D):void {}
		public static function putRectangle(rectangle:openfl.geom.Rectangle):void {}
	}

}
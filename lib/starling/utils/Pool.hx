package starling.utils;



@:jsRequire("starling/utils/Pool", "default")

extern class Pool {
	static function getMatrix(a : Float = 0, b : Float = 0, c : Float = 0, d : Float = 0, tx : Float = 0, ty : Float = 0) : openfl.geom.Matrix;
	static function getMatrix3D(identity : Bool = false) : openfl.geom.Matrix3D;
	static function getPoint(x : Float = 0, y : Float = 0) : openfl.geom.Point;
	static function getPoint3D(x : Float = 0, y : Float = 0, z : Float = 0) : openfl.geom.Vector3D;
	static function getRectangle(x : Float = 0, y : Float = 0, width : Float = 0, height : Float = 0) : openfl.geom.Rectangle;
	static function putMatrix(matrix : openfl.geom.Matrix) : Void;
	static function putMatrix3D(matrix : openfl.geom.Matrix3D) : Void;
	static function putPoint(point : openfl.geom.Point) : Void;
	static function putPoint3D(point : openfl.geom.Vector3D) : Void;
	static function putRectangle(rectangle : openfl.geom.Rectangle) : Void;
}

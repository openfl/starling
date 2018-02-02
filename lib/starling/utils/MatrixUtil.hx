package starling.utils;

import starling.utils.MathUtil;

@:jsRequire("starling/utils/MatrixUtil", "default")

extern class MatrixUtil {
	static function convertTo2D(matrix3D : openfl.geom.Matrix3D, ?out : openfl.geom.Matrix) : openfl.geom.Matrix;
	static function convertTo3D(matrix : openfl.geom.Matrix, ?out : openfl.geom.Matrix3D) : openfl.geom.Matrix3D;
	static function createOrthographicProjectionMatrix(x : Float, y : Float, width : Float, height : Float, ?out : openfl.geom.Matrix) : openfl.geom.Matrix;
	static function createPerspectiveProjectionMatrix(x : Float, y : Float, width : Float, height : Float, stageWidth : Float = 0, stageHeight : Float = 0, ?cameraPos : openfl.geom.Vector3D, ?out : openfl.geom.Matrix3D) : openfl.geom.Matrix3D;
	static function isIdentity(matrix : openfl.geom.Matrix) : Bool;
	static function isIdentity3D(matrix : openfl.geom.Matrix3D) : Bool;
	static function prependMatrix(base : openfl.geom.Matrix, prep : openfl.geom.Matrix) : Void;
	static function prependRotation(matrix : openfl.geom.Matrix, angle : Float) : Void;
	static function prependScale(matrix : openfl.geom.Matrix, sx : Float, sy : Float) : Void;
	static function prependSkew(matrix : openfl.geom.Matrix, skewX : Float, skewY : Float) : Void;
	static function prependTranslation(matrix : openfl.geom.Matrix, tx : Float, ty : Float) : Void;
	static function skew(matrix : openfl.geom.Matrix, skewX : Float, skewY : Float) : Void;
	static function snapToPixels(matrix : openfl.geom.Matrix, pixelSize : Float) : Void;
	static function toString(matrix : openfl.geom.Matrix, precision : Int = 0) : String;
	static function toString3D(matrix : openfl.geom.Matrix3D, transpose : Bool = false, precision : Int = 0) : String;
	static function transformCoords(matrix : openfl.geom.Matrix, x : Float, y : Float, ?out : openfl.geom.Point) : openfl.geom.Point;
	static function transformCoords3D(matrix : openfl.geom.Matrix3D, x : Float, y : Float, z : Float, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
	static function transformPoint(matrix : openfl.geom.Matrix, point : openfl.geom.Point, ?out : openfl.geom.Point) : openfl.geom.Point;
	static function transformPoint3D(matrix : openfl.geom.Matrix3D, point : openfl.geom.Vector3D, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
}

package starling.utils;

import starling.utils.MathUtil;

@:jsRequire("starling/utils/MatrixUtil", "default")

extern class MatrixUtil implements Dynamic {

	static var sRawData:Dynamic;
	static var sRawData2:Dynamic;
	static var sPoint3D:Dynamic;
	static var sMatrixData:Dynamic;
	static function convertTo3D(matrix:Dynamic, ?out:Dynamic):Dynamic;
	static function convertTo2D(matrix3D:Dynamic, ?out:Dynamic):Dynamic;
	static function isIdentity(matrix:Dynamic):Dynamic;
	static function isIdentity3D(matrix:Dynamic):Dynamic;
	static function transformPoint(matrix:Dynamic, point:Dynamic, ?out:Dynamic):Dynamic;
	static function transformPoint3D(matrix:Dynamic, point:Dynamic, ?out:Dynamic):Dynamic;
	static function transformCoords(matrix:Dynamic, x:Dynamic, y:Dynamic, ?out:Dynamic):Dynamic;
	static function transformCoords3D(matrix:Dynamic, x:Dynamic, y:Dynamic, z:Dynamic, ?out:Dynamic):Dynamic;
	static function skew(matrix:Dynamic, skewX:Dynamic, skewY:Dynamic):Dynamic;
	static function prependMatrix(base:Dynamic, prep:Dynamic):Dynamic;
	static function prependTranslation(matrix:Dynamic, tx:Dynamic, ty:Dynamic):Dynamic;
	static function prependScale(matrix:Dynamic, sx:Dynamic, sy:Dynamic):Dynamic;
	static function prependRotation(matrix:Dynamic, angle:Dynamic):Dynamic;
	static function prependSkew(matrix:Dynamic, skewX:Dynamic, skewY:Dynamic):Dynamic;
	static function toString3D(matrix:Dynamic, ?transpose:Dynamic, ?precision:Dynamic):Dynamic;
	static function toString(matrix:Dynamic, ?precision:Dynamic):Dynamic;
	static function formatRawData(data:Dynamic, numCols:Dynamic, numRows:Dynamic, precision:Dynamic, ?indent:Dynamic):Dynamic;
	static function snapToPixels(matrix:Dynamic, pixelSize:Dynamic):Dynamic;
	static function createPerspectiveProjectionMatrix(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic, ?stageWidth:Dynamic, ?stageHeight:Dynamic, ?cameraPos:Dynamic, ?out:Dynamic):Dynamic;
	static function createOrthographicProjectionMatrix(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic, ?out:Dynamic):Dynamic;


}
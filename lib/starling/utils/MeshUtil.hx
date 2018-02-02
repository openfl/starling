package starling.utils;

import starling.errors.AbstractClassError;
import starling.utils.Pool;
import starling.utils.MathUtil;

@:jsRequire("starling/utils/MeshUtil", "default")

extern class MeshUtil implements Dynamic {

	function MeshUtil():Dynamic;
	static var sPoint3D:Dynamic;
	static var sMatrix:Dynamic;
	static var sMatrix3D:Dynamic;
	static function containsPoint(vertexData:Dynamic, indexData:Dynamic, point:Dynamic):Dynamic;
	static function calculateBounds(vertexData:Dynamic, sourceSpace:Dynamic, targetSpace:Dynamic, ?out:Dynamic):Dynamic;


}
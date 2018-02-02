package starling.utils;

import starling.errors.AbstractClassError;
import starling.utils.Pool;
import starling.utils.MathUtil;

@:jsRequire("starling/utils/MeshUtil", "default")

extern class MeshUtil {
	function MeshUtil() : Void;
	static function calculateBounds(vertexData : starling.rendering.VertexData, sourceSpace : starling.display.DisplayObject, targetSpace : starling.display.DisplayObject, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	static function containsPoint(vertexData : starling.rendering.VertexData, indexData : starling.rendering.IndexData, point : openfl.geom.Point) : Bool;
}

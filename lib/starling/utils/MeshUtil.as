package starling.utils {

	import openfl.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.errors.AbstractClassError;
	import starling.rendering.VertexData;
	import starling.utils.Pool;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class MeshUtil {
		public function MeshUtil():void {}
		public static function calculateBounds(vertexData:starling.rendering.VertexData, sourceSpace:starling.display.DisplayObject, targetSpace:starling.display.DisplayObject, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public static function containsPoint(vertexData:starling.rendering.VertexData, indexData:starling.rendering.IndexData, point:openfl.geom.Point):Boolean { return false; }
	}

}
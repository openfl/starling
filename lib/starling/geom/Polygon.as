package starling.geom {

	import openfl.geom.Point;
	import starling.rendering.IndexData;
	import starling.rendering.VertexData;
	import starling.utils.Pool;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class Polygon {
		public function get area():Number { return 0; }
		public function get isConvex():Boolean { return false; }
		public function get isSimple():Boolean { return false; }
		public function get numTriangles():int { return 0; }
		public var numVertices:int;
		public function Polygon(vertices:Array = null):void {}
		public function addVertices(args:Array):void {}
		public function clone():Polygon { return null; }
		public function contains(x:Number, y:Number):Boolean { return false; }
		public function containsPoint(point:openfl.geom.Point):Boolean { return false; }
		public function copyToVertexData(target:starling.rendering.VertexData, targetVertexID:int = 0, attrName:String = null):void {}
		public function getVertex(index:int, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function reverse():void {}
		public function setVertex(index:int, x:Number, y:Number):void {}
		public function toString():String { return null; }
		public function triangulate(indexData:starling.rendering.IndexData = null, offset:int = 0):starling.rendering.IndexData { return null; }
		public static function createCircle(x:Number, y:Number, radius:Number, numSides:int = 0):Polygon { return null; }
		public static function createEllipse(x:Number, y:Number, radiusX:Number, radiusY:Number, numSides:int = 0):Polygon { return null; }
		public static function createRectangle(x:Number, y:Number, width:Number, height:Number):Polygon { return null; }
	}

}
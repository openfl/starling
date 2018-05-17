package starling.display {
	
	import openfl.geom.Point;
	import starling.display.DisplayObject;
	import starling.geom.Polygon;
	import starling.utils.MeshUtil;
	import starling.utils.MatrixUtil;
	import starling.styles.MeshStyle;
	import starling.textures.Texture;
	import starling.rendering.VertexData;
	import starling.rendering.VertexDataFormat;
	import starling.rendering.IndexData;
	
	/**
	 * @externs
	 */
	public class Mesh extends DisplayObject {
		public var color:uint;
		public function get numIndices():int { return 0; }
		public function get numTriangles():int { return 0; }
		public function get numVertices():int { return 0; }
		public var pixelSnapping:Boolean;
		public var style:MeshStyle;
		public var texture:Texture;
		public var textureRepeat:Boolean;
		public var textureSmoothing:String;
		public function get vertexFormat():VertexDataFormat { return null; }
		public function Mesh(vertexData:VertexData, indexData:starling.rendering.IndexData, style:starling.styles.MeshStyle = null):void {}
		public function getTexCoords(vertexID:int, out:Point = null):Point { return null; }
		public function getVertexAlpha(vertexID:int):Number { return 0; }
		public function getVertexColor(vertexID:int):uint { return 0; }
		public function getVertexPosition(vertexID:int, out:Point = null):Point { return null; }
		public function setIndexDataChanged():void {}
		public function setStyle(meshStyle:starling.styles.MeshStyle = null, mergeWithPredecessor:Boolean = false):void {}
		public function setTexCoords(vertexID:int, u:Number, v:Number):void {}
		public function setVertexAlpha(vertexID:int, alpha:Number):void {}
		public function setVertexColor(vertexID:int, color:uint):void {}
		public function setVertexDataChanged():void {}
		public function setVertexPosition(vertexID:int, x:Number, y:Number):void {}
		public static var defaultStyle:Class;
		public static var defaultStyleFactory:Function;
		public static function fromPolygon(polygon:starling.geom.Polygon, style:starling.styles.MeshStyle = null):Mesh { return null; }
	}
	
}
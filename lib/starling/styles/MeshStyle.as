package starling.styles {

	import openfl.geom.Matrix;
	import openfl.geom.Point;
	import starling.display.Mesh;
	import starling.events.EventDispatcher;
	import starling.rendering.IndexData;
	import starling.rendering.MeshEffect;
	import starling.rendering.RenderState;
	import starling.rendering.VertexData;
	import starling.rendering.VertexDataFormat;
	import starling.textures.Texture;

	// @:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent"))

	/**
	 * @externs
	 */
	public class MeshStyle extends starling.events.EventDispatcher {
		public var color:uint;
		public function get indexData():starling.rendering.IndexData { return null; }
		public function get target():starling.display.Mesh { return null; }
		public var texture:starling.textures.Texture;
		public var textureRepeat:Boolean;
		public var textureSmoothing:String;
		public function get type():Class { return null; }
		public function get vertexData():starling.rendering.VertexData { return null; }
		public function get vertexFormat():starling.rendering.VertexDataFormat { return null; }
		public function MeshStyle():void {}
		public function batchIndexData(targetStyle:MeshStyle, targetIndexID:int = 0, offset:int = 0, indexID:int = 0, numIndices:int = 0):void {}
		public function batchVertexData(targetStyle:MeshStyle, targetVertexID:int = 0, matrix:openfl.geom.Matrix = null, vertexID:int = 0, numVertices:int = 0):void {}
		public function canBatchWith(meshStyle:MeshStyle):Boolean { return false; }
		public function clone():MeshStyle { return null; }
		public function copyFrom(meshStyle:MeshStyle):void {}
		public function createEffect():starling.rendering.MeshEffect { return null; }
		public function getTexCoords(vertexID:int, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function getVertexAlpha(vertexID:int):Number { return 0; }
		public function getVertexColor(vertexID:int):uint { return 0; }
		public function getVertexPosition(vertexID:int, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function setTexCoords(vertexID:int, u:Number, v:Number):void {}
		public function setVertexAlpha(vertexID:int, alpha:Number):void {}
		public function setVertexColor(vertexID:int, color:uint):void {}
		public function setVertexPosition(vertexID:int, x:Number, y:Number):void {}
		public function updateEffect(effect:starling.rendering.MeshEffect, state:starling.rendering.RenderState):void {}
		public static var VERTEX_FORMAT:starling.rendering.VertexDataFormat;
	}

}
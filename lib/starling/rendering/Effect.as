package starling.rendering {

	import openfl.geom.Matrix3D;
	import starling.core.Starling;
	import starling.errors.MissingContextError;
	import starling.rendering.Program;
	import starling.rendering.VertexDataFormat;

	/**
	 * @externs
	 */
	public class Effect {
		public var mvpMatrix3D:openfl.geom.Matrix3D;
		public var onRestore:Function;
		public var programBaseName:String;
		public function get programName():String { return null; }
		public function get programVariantName():uint { return 0; }
		public function get vertexFormat():VertexDataFormat { return null; }
		public function Effect():void {}
		public function dispose():void {}
		public function purgeBuffers(vertexBuffer:Boolean = false, indexBuffer:Boolean = false):void {}
		public function render(firstIndex:int = 0, numTriangles:int = 0):void {}
		public function uploadIndexData(indexData:IndexData, bufferUsage:String = null):void {}
		public function uploadVertexData(vertexData:VertexData, bufferUsage:String = null):void {}
		public static var VERTEX_FORMAT:VertexDataFormat;
	}

}
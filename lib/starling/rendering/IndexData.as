package starling.rendering {

	import openfl.display3D.IndexBuffer3D;
	import openfl.utils.ByteArray;
	// import openfl.Vector;
	import starling.utils.StringUtil;
	import starling.core.Starling;
	import starling.errors.MissingContextError;

	/**
	 * @externs
	 */
	public class IndexData {
		public function get indexSizeInBytes():int { return 0; }
		public var numIndices:int;
		public var numQuads:int;
		public var numTriangles:int;
		public function get rawData():openfl.utils.ByteArray { return null; }
		public var useQuadLayout:Boolean;
		public function IndexData(initialCapacity:int = 0):void {}
		public function addQuad(a:uint, b:uint, c:uint, d:uint):void {}
		public function addTriangle(a:uint, b:uint, c:uint):void {}
		public function clear():void {}
		public function clone():IndexData { return null; }
		public function copyTo(target:IndexData, targetIndexID:int = 0, offset:int = 0, indexID:int = 0, numIndices:int = 0):void {}
		public function createIndexBuffer(upload:Boolean = false, bufferUsage:String = null):openfl.display3D.IndexBuffer3D { return null; }
		public function getIndex(indexID:int):int { return 0; }
		public function offsetIndices(offset:int, indexID:int = 0, numIndices:int = 0):void {}
		public function setIndex(indexID:int, index:uint):void {}
		public function toString():String { return null; }
		public function toVector(out:Vector.<uint> = null):Vector.<uint> { return null; }
		public function trim():void {}
		public function uploadToIndexBuffer(buffer:openfl.display3D.IndexBuffer3D, indexID:int = 0, numIndices:int = 0):void {}
	}

}
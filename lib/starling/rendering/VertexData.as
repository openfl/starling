package starling.rendering {

	import openfl.display3D.VertexBuffer3D;
	import openfl.geom.Matrix;
	import openfl.geom.Matrix3D;
	import openfl.utils.ByteArray;
	import starling.utils.StringUtil;
	import starling.utils.MatrixUtil;
	import starling.utils.MathUtil;
	import starling.core.Starling;
	import starling.errors.MissingContextError;
	import starling.styles.MeshStyle;
	import starling.rendering.VertexDataFormat;

	/**
	 * @externs
	 */
	public class VertexData {
		public var format:VertexDataFormat;
		public function get formatString():String { return null; }
		public var numVertices:int;
		public var premultipliedAlpha:Boolean;
		public function get rawData():openfl.utils.ByteArray { return null; }
		public function get size():int { return 0; }
		public function get sizeIn32Bits():int { return 0; }
		public var tinted:Boolean;
		public function get vertexSize():int { return 0; }
		public function get vertexSizeIn32Bits():int { return 0; }
		public function VertexData(format:Object = null, initialCapacity:int = 0):void {}
		public function clear():void {}
		public function clone():VertexData { return null; }
		public function colorize(attrName:String = null, color:uint = 0, alpha:Number = 0, vertexID:int = 0, numVertices:int = 0):void {}
		public function copyAttributeTo(target:VertexData, targetVertexID:int, attrName:String, matrix:openfl.geom.Matrix = null, vertexID:int = 0, numVertices:int = 0):void {}
		public function copyTo(target:VertexData, targetVertexID:int = 0, matrix:openfl.geom.Matrix = null, vertexID:int = 0, numVertices:int = 0):void {}
		public function createVertexBuffer(upload:Boolean = false, bufferUsage:String = null):openfl.display3D.VertexBuffer3D { return null; }
		public function getAlpha(vertexID:int, attrName:String = null):Number { return 0; }
		public function getBounds(attrName:String = null, matrix:openfl.geom.Matrix = null, vertexID:int = 0, numVertices:int = 0, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public function getBoundsProjected(attrName:String, matrix:openfl.geom.Matrix3D, camPos:openfl.geom.Vector3D, vertexID:int = 0, numVertices:int = 0, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
		public function getColor(vertexID:int, attrName:String = null):uint { return 0; }
		public function getFloat(vertexID:int, attrName:String):Number { return 0; }
		public function getFormat(attrName:String):String { return null; }
		public function getOffset(attrName:String):int { return 0; }
		public function getOffsetIn32Bits(attrName:String):int { return 0; }
		public function getPoint(vertexID:int, attrName:String, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function getPoint3D(vertexID:int, attrName:String, out:openfl.geom.Vector3D = null):openfl.geom.Vector3D { return null; }
		public function getPoint4D(vertexID:int, attrName:String, out:openfl.geom.Vector3D = null):openfl.geom.Vector3D { return null; }
		public function getSize(attrName:String):int { return 0; }
		public function getSizeIn32Bits(attrName:String):int { return 0; }
		public function getUnsignedInt(vertexID:int, attrName:String):uint { return 0; }
		public function hasAttribute(attrName:String):Boolean { return false; }
		public function scaleAlphas(attrName:String, factor:Number, vertexID:int = 0, numVertices:int = 0):void {}
		public function setAlpha(vertexID:int, attrName:String, alpha:Number):void {}
		public function setColor(vertexID:int, attrName:String, color:uint):void {}
		public function setFloat(vertexID:int, attrName:String, value:Number):void {}
		public function setPoint(vertexID:int, attrName:String, x:Number, y:Number):void {}
		public function setPoint3D(vertexID:int, attrName:String, x:Number, y:Number, z:Number):void {}
		public function setPoint4D(vertexID:int, attrName:String, x:Number, y:Number, z:Number, w:Number = 0):void {}
		public function setPremultipliedAlpha(value:Boolean, updateData:Boolean):void {}
		public function setUnsignedInt(vertexID:int, attrName:String, value:uint):void {}
		public function toString():String { return null; }
		public function transformPoints(attrName:String, matrix:openfl.geom.Matrix, vertexID:int = 0, numVertices:int = 0):void {}
		public function translatePoints(attrName:String, deltaX:Number, deltaY:Number, vertexID:int = 0, numVertices:int = 0):void {}
		public function trim():void {}
		public function updateTinted(attrName:String = null):Boolean { return false; }
		public function uploadToVertexBuffer(buffer:openfl.display3D.VertexBuffer3D, vertexID:int = 0, numVertices:int = 0):void {}
	}

}
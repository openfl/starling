package starling.rendering {

	import openfl.display3D.VertexBuffer3D;
	import starling.core.Starling;
	import starling.utils.StringUtil;
	import starling.rendering.VertexDataAttribute;

	/**
	 * @externs
	 */
	public class VertexDataFormat {
		public function get formatString():String { return null; }
		public function get numAttributes():int { return 0; }
		public function get vertexSize():int { return 0; }
		public function get vertexSizeIn32Bits():int { return 0; }
		public function VertexDataFormat():void {}
		public function extend(format:String):VertexDataFormat { return null; }
		public function getFormat(attrName:String):String { return null; }
		public function getName(attrIndex:int):String { return null; }
		public function getOffset(attrName:String):int { return 0; }
		public function getOffsetIn32Bits(attrName:String):int { return 0; }
		public function getSize(attrName:String):int { return 0; }
		public function getSizeIn32Bits(attrName:String):int { return 0; }
		public function hasAttribute(attrName:String):Boolean { return false; }
		public function setVertexBufferAt(index:int, buffer:openfl.display3D.VertexBuffer3D, attrName:String):void {}
		public function toString():String { return null; }
		public static function fromString(format:String):VertexDataFormat { return null; }
	}

}
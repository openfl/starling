package starling.rendering {

	import starling.utils.StringUtil;

	/**
	 * @externs
	 */
	public class BatchToken {
		public var batchID:int;
		public var indexID:int;
		public var vertexID:int;
		public function BatchToken(batchID:int = 0, vertexID:int = 0, indexID:int = 0):void {}
		public function copyFrom(token:BatchToken):void {}
		public function equals(other:BatchToken):Boolean { return false; }
		public function reset():void {}
		public function setTo(batchID:int = 0, vertexID:int = 0, indexID:int = 0):void {}
		public function toString():String { return null; }
	}

}
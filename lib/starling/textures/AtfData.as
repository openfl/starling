package starling.textures {

	import openfl.utils.ByteArray;

	/**
	 * @externs
	 */
	public class AtfData {
		public function get data():openfl.utils.ByteArray { return null; }
		public function get format():String { return null; }
		public function get height():int { return 0; }
		public function get isCubeMap():Boolean { return false; }
		public function get numTextures():int { return 0; }
		public function get width():int { return 0; }
		public function AtfData(data:openfl.utils.ByteArray):void {}
		public static function isAtfData(data:openfl.utils.ByteArray):Boolean { return false; }
	}

}
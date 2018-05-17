package starling.extensions {

	

	/**
	 * @externs
	 */
	public class ColorArgb {
		public var alpha:Number;
		public var blue:Number;
		public var green:Number;
		public var red:Number;
		public function ColorArgb(red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 0):void {}
		// public function _fromArgb(color:int):void {}
		// public function _fromRgb(color:int):void {}
		public function copyFrom(argb:ColorArgb):void {}
		public function toArgb():int { return 0; }
		public function toRgb():int { return 0; }
		public static function fromArgb(color:int):ColorArgb { return null }
		public static function fromRgb(color:int):ColorArgb { return null }
	}

}
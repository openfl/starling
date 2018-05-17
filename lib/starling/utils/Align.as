package starling.utils {

	import starling.errors.AbstractClassError;

	/**
	 * @externs
	 */
	public class Align {
		public function Align():void {}
		/** Horizontal left alignment. */
		public static const LEFT:String   = "left";
		
		/** Horizontal right alignment. */
		public static const RIGHT:String  = "right";

		/** Vertical top alignment. */
		public static const TOP:String = "top";

		/** Vertical bottom alignment. */
		public static const BOTTOM:String = "bottom";

		/** Centered alignment. */
		public static const CENTER:String = "center";
		public static function isValid(align:String):Boolean { return false; }
		public static function isValidHorizontal(align:String):Boolean { return false; }
		public static function isValidVertical(align:String):Boolean { return false; }
	}

}
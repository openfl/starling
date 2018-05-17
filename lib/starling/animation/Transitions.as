package starling.animation {
	
	
	/**
	 * @externs
	 */
	public class Transitions {
		
		
		public static const LINEAR:String = "linear";
		public static const EASE_IN:String = "easeIn";
		public static const EASE_OUT:String = "easeOut";
		public static const EASE_IN_OUT:String = "easeInOut";
		public static const EASE_OUT_IN:String = "easeOutIn";
		public static const EASE_IN_BACK:String = "easeInBack";
		public static const EASE_OUT_BACK:String = "easeOutBack";
		public static const EASE_IN_OUT_BACK:String = "easeInOutBack";
		public static const EASE_OUT_IN_BACK:String = "easeOutInBack";
		public static const EASE_IN_ELASTIC:String = "easeInElastic";
		public static const EASE_OUT_ELASTIC:String = "easeOutElastic";
		public static const EASE_IN_OUT_ELASTIC:String = "easeInOutElastic";
		public static const EASE_OUT_IN_ELASTIC:String = "easeOutInElastic";
		public static const EASE_IN_BOUNCE:String = "easeInBounce";
		public static const EASE_OUT_BOUNCE:String = "easeOutBounce";
		public static const EASE_IN_OUT_BOUNCE:String = "easeInOutBounce";
		public static const EASE_OUT_IN_BOUNCE:String = "easeOutInBounce";
		
		
		public static function getTransition (name:String):Function { return null; }
		public static function register (name:String, func:Function):void {}
		
		
	}
	
	
}
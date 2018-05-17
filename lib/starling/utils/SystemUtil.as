package starling.utils {

	/**
	 * @externs
	 */
	public class SystemUtil {
		public static function get isAIR():Boolean { return false; }
		public static function get isAndroid():Boolean { return false; }
		public static function get isApplicationActive():Boolean { return false; }
		public static function get isDesktop():Boolean { return false; }
		public static function get isIOS():Boolean { return false; }
		public static function get isMac():Boolean { return false; }
		public static function get isWindows():Boolean { return false; }
		public static var platform:String;
		public static function get supportsDepthAndStencil():Boolean { return false; }
		public static function get supportsVideoTexture():Boolean { return false; }
		public static function get version():String { return null; }
		public static function executeWhenApplicationIsActive(call:Function, args:Array):void {}
		public static function initialize():void {}
		public static function isEmbeddedFont(fontName:String, bold:Boolean = false, italic:Boolean = false, fontType:String = null):Boolean { return false; }
		public static function updateEmbeddedFonts():void {}
	}

}
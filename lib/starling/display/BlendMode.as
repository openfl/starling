package starling.display {
	
	
	import starling.core.Starling;
	
	
	/**
	 * @externs
	 */
	public class BlendMode {
		
		/** Inherits the blend mode from this display object's parent. */
		public static const AUTO:String = "auto";

		/** Deactivates blending, i.e. disabling any transparency. */
		public static const NONE:String = "none";
		
		/** The display object appears in front of the background. */
		public static const NORMAL:String = "normal";
		
		/** Adds the values of the colors of the display object to the colors of its background. */
		public static const ADD:String = "add";
		
		/** Multiplies the values of the display object colors with the the background color. */
		public static const MULTIPLY:String = "multiply";
		
		/** Multiplies the complement (inverse) of the display object color with the complement of 
		 * the background color, resulting in a bleaching effect. */
		public static const SCREEN:String = "screen";
		
		/** Erases the background when drawn on a RenderTexture. */
		public static const ERASE:String = "erase";

		/** When used on a RenderTexture, the drawn object will act as a mask for the current
		 * content, i.e. the source alpha overwrites the destination alpha. */
		public static const MASK:String = "mask";

		/** Draws under/below existing objects; useful especially on RenderTextures. */
		public static const BELOW:String = "below";
		
		public function get destinationFactor():String { return null; }
		public function get name():String { return null; }
		public function get sourceFactor():String { return null; }
		public function BlendMode(name:String, sourceFactor:String, destinationFactor:String):void {}
		public function activate():void {}
		public function toString():String { return null; }
		// public static function get(modeName:String):BlendMode { return null; }
		public static function getByFactors(srcFactor:String, dstFactor:String):BlendMode { return null; }
		public static function register(name:String, srcFactor:String, dstFactor:String):BlendMode { return null; }
	}
	
	
}
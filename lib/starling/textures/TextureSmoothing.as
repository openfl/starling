package starling.textures {

	/**
	 * @externs
	 */
	public class TextureSmoothing {
		/** No smoothing, also called "Nearest Neighbor". Pixels will scale up as big rectangles. */
		public static const NONE:String      = "none";
		
		/** Bilinear filtering. Creates smooth transitions between pixels. */
		public static const BILINEAR:String  = "bilinear";
		
		/** Trilinear filtering. Highest quality by taking the next mip map level into account. */
		public static const TRILINEAR:String = "trilinear";
		public static function isValid(smoothing:String):Boolean { return false; }
	}

}
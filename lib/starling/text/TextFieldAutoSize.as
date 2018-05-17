package starling.text {

	/**
	 * @externs
	 */
	public class TextFieldAutoSize {
		/** No auto-sizing will happen. */
		public static const NONE:String = "none";
		
		/** The text field will grow/shrink sidewards; no line-breaks will be added.
		 * The height of the text field remains unchanged. */ 
		public static const HORIZONTAL:String = "horizontal";
		
		/** The text field will grow/shrink downwards, adding line-breaks when necessary.
		 * The width of the text field remains unchanged. */
		public static const VERTICAL:String = "vertical";
		
		/** The text field will grow to the right and bottom; no line-breaks will be added. */
		public static const BOTH_DIRECTIONS:String = "bothDirections";
	}

}
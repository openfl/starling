package starling.events {

	import starling.events.Event;
	
	

	/**
	 * @externs
	 */
	public class ResizeEvent extends Event {
		public function get height():int { return 0; }
		public function get width():int { return 0; }
		public function ResizeEvent(type:String, width:int, height:int, bubbles:Boolean = false):void { super (null); }
		/** Event type for a resized Flash player. */
		public static const RESIZE:String = "resize";
	}

}
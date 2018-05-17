package starling.events {

	import starling.events.Event;

	/**
	 * @externs
	 */
	public class EnterFrameEvent extends Event {
		public function get passedTime():Number { return 0; }
		public function EnterFrameEvent(type:String, passedTime:Number, bubbles:Boolean = false):void { super (null); }
		/** Event type for a display object that is entering a new frame. */
    	public static const ENTER_FRAME:String = "enterFrame";
	}
	
}
package starling.events {

	import starling.events.Event;

	/**
	 * @externs
	 */
	public class KeyboardEvent extends Event {
		public function get altKey():Boolean { return false; }
		public function get charCode():uint { return 0; }
		public function get ctrlKey():Boolean { return false; }
		public function get keyCode():uint { return 0; }
		public function get keyLocation():uint { return 0; }
		public function get shiftKey():Boolean { return false; }
		public function KeyboardEvent(type:String, charCode:uint = 0, keyCode:uint = 0, keyLocation:uint = 0, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false):void { super (null); }
		public function isDefaultPrevented():Boolean { return false; }
		public function preventDefault():void {}
		    /** Event type for a key that was released. */
		public static const KEY_UP:String = "keyUp";
		
		/** Event type for a key that was pressed. */
		public static const KEY_DOWN:String = "keyDown";
	}

}
package starling.events {

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import openfl.Vector;

	/**
	 * @externs
	 */
	public class TouchEvent extends Event {
		public function get ctrlKey():Boolean { return false; }
		public function get shiftKey():Boolean { return false; }
		public function get timestamp():Number { return 0; }
		public function get touches():openfl.Vector { return null; }
		public function TouchEvent(type:String, touches:openfl.Vector = null, shiftKey:Boolean = false, ctrlKey:Boolean = false, bubbles:Boolean = false):void { super (null); }
		public function dispatch(chain:openfl.Vector):void {}
		public function getTouch(target:starling.display.DisplayObject, phase:String = null, id:int = 0):Touch { return null; }
		public function getTouches(target:starling.display.DisplayObject, phase:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function interactsWith(target:starling.display.DisplayObject):Boolean { return false; }
		/** Event type for touch or mouse input. */
		public static const TOUCH:String = "touch";
	}

}
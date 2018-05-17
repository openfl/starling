package starling.events {

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * @externs
	 */
	public class EventDispatcher {
		public function EventDispatcher():void {}
		public function addEventListener(type:String, listener:Function):void {}
		public function dispatchEvent(event:Event):void {}
		public function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void {}
		public function hasEventListener(type:String, listener:Object = null):Boolean { return false; }
		public function removeEventListener(type:String, listener:Function):void {}
		public function removeEventListeners(type:String = null):void {}
	}
	
}
package starling.animation {
	
	
	import starling.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class DelayedCall extends EventDispatcher implements IAnimatable {
		
		
		public function get arguments ():Array { return null; }
		public function get callback ():Function { return null; }
		public function get currentTime ():Number { return 0; }
		public function get isComplete ():Boolean { return false; }
		public var repeatCount:int;
		public function get totalTime ():Number { return 0; }
		
		public function DelayedCall (callback:Function, delay:Number, args:Array = null) {}
		public function reset (callback:Function, delay:Number, args:Array = null):DelayedCall { return null; }
		public function advanceTime (time:Number):void {}
		public function complete ():void {}
		
		
	}
	
	
}
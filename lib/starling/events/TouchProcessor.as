package starling.events {

	
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.utils.MathUtil;
	import starling.core.Starling;
	import starling.events.TouchMarker;
	import starling.events.TouchEvent;

	/**
	 * @externs
	 */
	public class TouchProcessor {
		public var multitapDistance:Number;
		public var multitapTime:Number;
		public function get numCurrentTouches():int { return 0; }
		public var root:starling.display.DisplayObject;
		public var simulateMultitouch:Boolean;
		public function get stage():starling.display.Stage { return null; }
		public function TouchProcessor(stage:starling.display.Stage):void {}
		public function advanceTime(passedTime:Number):void {}
		public function cancelTouches():void {}
		public function dispose():void {}
		public function enqueue(touchID:int, phase:String, globalX:Number, globalY:Number, pressure:Number = 0, width:Number = 0, height:Number = 0):void {}
		public function enqueueMouseLeftStage():void {}
	}

}
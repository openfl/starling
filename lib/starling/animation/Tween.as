package starling.animation {
	
	
	import starling.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class Tween extends EventDispatcher implements IAnimatable {
		
		
		public function get isComplete ():Boolean { return false; }
		public function get target ():Object { return null; }
		public var transition:String;
		public var transitionFunc:Function;
		public function get totalTime ():Number { return 0; }
		public function get currentTime ():Number { return 0; }
		public function get progress ():Number { return 0; }
		public var delay:Number;
		public var repeatCount:int;
		public var repeatDelay:Number;
		public var reverse:Boolean;
		public var roundToInt:Boolean;
		public var onStart:Function;
		public var onUpdate:Function;
		public var onRepeat:Function;
		public var onComplete:Function;
		public var onStartArgs:Array;
		public var onUpdateArgs:Array;
		public var onRepeatArgs:Array;
		public var onCompleteArgs:Array;
		public var nextTween:Tween;
		
		public function Tween (target:Object, time:Number, transition:Object = "linear") {}
		public function reset (target:Object, time:Number, transition:Object = "linear"):Tween { return null; }
		public function animate (property:String, endValue:Number):void {}
		public function scaleTo (factor:Number):void {}
		public function moveTo (x:Number, y:Number):void {}
		public function fadeTo (alpha:Number):void {}
		public function rotateTo (angle:Number, type:String = "rad"):void {}
		public function advanceTime (time:Number):void {}
		public function getEndValue (property:String):Number { return 0; }
		public function animatesProperty (property:String):Boolean { return false; }
		
		
	}
	
	
}
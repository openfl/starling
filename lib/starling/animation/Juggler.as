package starling.animation {
	
	
	// import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	public class Juggler implements IAnimatable {
		
		
		public function get elapsedTime ():Number { return 0; }
		public function get objects ():Vector.<IAnimatable> { return null; }
		public var timeScale:Number;
		
		public function Juggler () {}
		public function add (object:IAnimatable):uint { return 0; }
		public function addWithID (object:IAnimatable, objectID:uint):uint { return 0; }
		public function contains (object:IAnimatable):Boolean { return false; }
		public function remove (object:IAnimatable):uint { return 0; }
		public function removeByID (objectID:uint):uint { return 0; }
		public function removeTweens(target:Object):void {}
		public function removeDelayedCalls (callback:Function):void {}
		public function containsTweens (target:Object):Boolean { return false; }
		public function containsDelayedCalls (callback:Function):Boolean { return false; }
		public function purge ():void {}
		public function delayCall (call:Function, delay:Number, args:Array = null):uint { return 0; }
		public function repeatCall (call:Function, interval:Number, repeatCount:int = 0, args:Array = null):uint { return 0; }
		public function tween (target:Object, time:Number, properties:Object):uint { return 0; }
		public function advanceTime (time:Number):void {}
		
		
	}
	
	
}
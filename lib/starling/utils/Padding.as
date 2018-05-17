package starling.utils {

	import starling.events.EventDispatcher;

	// @:meta(Event(name = "change", type = "starling.events.Event"))

	/**
	 * @externs
	 */
	public class Padding extends starling.events.EventDispatcher {
		public var bottom:Number;
		public var left:Number;
		public var right:Number;
		public var top:Number;
		public function Padding(left:Number = 0, right:Number = 0, top:Number = 0, bottom:Number = 0):void {}
		public function clone():Padding { return null; }
		public function copyFrom(padding:Padding):void {}
		public function setTo(left:Number = 0, right:Number = 0, top:Number = 0, bottom:Number = 0):void {}
		public function setToSymmetric(horizontal:Number, vertical:Number):void {}
		public function setToUniform(value:Number):void {}
	}

}
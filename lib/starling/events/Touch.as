package starling.events {

	import openfl.geom.Point;
	import starling.display.DisplayObject;
	import starling.utils.StringUtil;

	/**
	 * @externs
	 */
	public class Touch {
		public var cancelled:Boolean;
		public var globalX:Number;
		public var globalY:Number;
		public var height:Number;
		public function get id():int { return 0; }
		public var phase:String;
		public var pressure:Number;
		public function get previousGlobalX():Number { return 0; }
		public function get previousGlobalY():Number { return 0; }
		public var tapCount:int;
		public var target:starling.display.DisplayObject;
		public var timestamp:Number;
		public var width:Number;
		public function Touch(id:int):void {}
		public function clone():Touch { return null; }
		public function getLocation(space:starling.display.DisplayObject, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function getMovement(space:starling.display.DisplayObject, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function getPreviousLocation(space:starling.display.DisplayObject, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function isTouching(target:starling.display.DisplayObject):Boolean { return false; }
		public function toString():String { return null; }
	}

}
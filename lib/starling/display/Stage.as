package starling.display {
	
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	import openfl.geom.Vector3D;
	import starling.display.DisplayObjectContainer;
	import starling.utils.RectangleUtil;
	import starling.utils.MatrixUtil;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	
	// @:meta(Event(name = "resize", type = "starling.events.ResizeEvent"))
	
	/**
	 * @externs
	 */
	public class Stage extends DisplayObjectContainer {
		public function get cameraPosition():openfl.geom.Vector3D { return null; }
		public var color:uint;
		public var fieldOfView:Number;
		public var focalLength:Number;
		public var projectionOffset:openfl.geom.Point;
		public var stageHeight:int;
		public var stageWidth:int;
		public function get starling():starling.core.Starling { return null; }
		public function advanceTime(passedTime:Number):void {}
		public function getCameraPosition(space:DisplayObject = null, out:openfl.geom.Vector3D = null):openfl.geom.Vector3D { return null; }
		public function getStageBounds(targetSpace:DisplayObject, out:openfl.geom.Rectangle = null):openfl.geom.Rectangle { return null; }
	}
	
}
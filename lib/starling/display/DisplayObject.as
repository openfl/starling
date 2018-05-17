package starling.display {
	
	import openfl.display.BitmapData;
	import openfl.geom.Matrix;
	import openfl.geom.Matrix3D;
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	import openfl.geom.Vector3D;
	import starling.events.EventDispatcher;
	import starling.errors.AbstractMethodError;
	import starling.filters.FragmentFilter;
	import starling.utils.MatrixUtil;
	import starling.utils.MathUtil;
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.utils.Color;
	import starling.utils.SystemUtil;
	import starling.rendering.BatchToken;
	import starling.rendering.Painter;
	
	// @:meta(Event(name = "added", type = "starling.events.Event")) @:meta(Event(name = "addedToStage", type = "starling.events.Event")) @:meta(Event(name = "removed", type = "starling.events.Event")) @:meta(Event(name = "removedFromStage", type = "starling.events.Event")) @:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent")) @:meta(Event(name = "touch", type = "starling.events.TouchEvent")) @:meta(Event(name = "keyUp", type = "starling.events.KeyboardEvent")) @:meta(Event(name = "keyDown", type = "starling.events.KeyboardEvent"))
	
	/**
	 * @externs
	 */
	public class DisplayObject extends EventDispatcher {
		public var alpha:Number;
		public function get base():DisplayObject { return null; }
		public var blendMode:String;
		public function get bounds():Rectangle { return null; }
		public var filter:FragmentFilter;
		public var height:Number;
		public function get is3D():Boolean { return false; }
		public var mask:DisplayObject;
		public var maskInverted:Boolean;
		public var name:String;
		public function get parent():DisplayObjectContainer { return null; }
		public var pivotX:Number;
		public var pivotY:Number;
		public function get requiresRedraw():Boolean { return false; }
		public function get root():DisplayObject { return null; }
		public var rotation:Number;
		public var scale:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var skewX:Number;
		public var skewY:Number;
		public function get stage():Stage { return null; }
		public var touchable:Boolean;
		public var transformationMatrix:Matrix;
		public function get transformationMatrix3D():Matrix3D { return null; }
		public var useHandCursor:Boolean;
		public var visible:Boolean;
		public var width:Number;
		public var x:Number;
		public var y:Number;
		public function alignPivot(horizontalAlign:String = null, verticalAlign:String = null):void {}
		public function dispose():void {}
		public function drawToBitmapData(out:BitmapData = null, color:uint = 0, alpha:Number = 0):BitmapData { return null; }
		public function getBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle { return null; }
		public function getTransformationMatrix(targetSpace:DisplayObject, out:Matrix = null):Matrix { return null; }
		public function getTransformationMatrix3D(targetSpace:DisplayObject, out:Matrix3D = null):Matrix3D { return null; }
		public function globalToLocal(globalPoint:Point, out:Point = null):Point { return null; }
		public function globalToLocal3D(globalPoint:Point, out:Vector3D = null):Vector3D { return null; }
		public function hitTest(localPoint:Point):DisplayObject { return null; }
		public function hitTestMask(localPoint:Point):Boolean { return false; }
		public function local3DToGlobal(localPoint:Vector3D, out:Point = null):Point { return null; }
		public function localToGlobal(localPoint:Point, out:Point = null):Point { return null; }
		public function removeFromParent(dispose:Boolean = false):void {}
		public function render(painter:Painter):void {}
		public function setRequiresRedraw():void {}
	}
	
}
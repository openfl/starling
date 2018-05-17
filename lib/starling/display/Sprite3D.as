package starling.display {
	
	import starling.display.DisplayObjectContainer;
	import starling.utils.MatrixUtil;
	import starling.utils.MathUtil;
	import starling.display.DisplayObject;
	
	/**
	 * @externs
	 */
	public class Sprite3D extends DisplayObjectContainer {
		public function get isFlat():Boolean { return false; }
		public var pivotZ:Number;
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		public var scaleZ:Number;
		public var z:Number;
		public function Sprite3D():void {}
	}
	
}
package starling.display {
	
	import starling.display.DisplayObjectContainer;
	import starling.geom.Polygon;
	import starling.rendering.VertexData;
	import starling.rendering.IndexData;
	import starling.display.Mesh;
	
	/**
	 * @externs
	 */
	public class Canvas extends DisplayObjectContainer {
		public function Canvas():void {}
		public function beginFill(color:uint = 0, alpha:Number = 0):void {}
		public function clear():void {}
		public function drawCircle(x:Number, y:Number, radius:Number):void {}
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {}
		public function drawPolygon(polygon:Polygon):void {}
		public function drawRectangle(x:Number, y:Number, width:Number, height:Number):void {}
		public function endFill():void {}
	}
	
}
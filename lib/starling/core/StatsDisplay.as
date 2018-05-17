package starling.core {
	
	
	import starling.display.Sprite;
	
	
	/**
	 * @externs
	 */
	public class StatsDisplay extends Sprite {
		public var drawCount:int;
		public var fps:Number;
		public var gpuMemory:Number;
		public var memory:Number;
		public function StatsDisplay():void {}
		public function markFrameAsSkipped():void {}
		public function update():void {}
	}
	
	
}
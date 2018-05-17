package starling.events {

	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.display.Image;

	/**
	 * @externs
	 */
	public class TouchMarker extends starling.display.Sprite {
		public function get mockX():Number { return 0; }
		public function get mockY():Number { return 0; }
		public function get realX():Number { return 0; }
		public function get realY():Number { return 0; }
		public function TouchMarker():void {}
		public function moveCenter(x:Number, y:Number):void {}
		public function moveMarker(x:Number, y:Number, withCenter:Boolean = false):void {}
	}

}
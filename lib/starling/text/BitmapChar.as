package starling.text {

	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public class BitmapChar {
		public function get charID():int { return 0; }
		public function get height():Number { return 0; }
		public function get texture():starling.textures.Texture { return null; }
		public function get width():Number { return 0; }
		public function get xAdvance():Number { return 0; }
		public function get xOffset():Number { return 0; }
		public function get yOffset():Number { return 0; }
		public function BitmapChar(id:int, texture:starling.textures.Texture, xOffset:Number, yOffset:Number, xAdvance:Number):void {}
		public function addKerning(charID:int, amount:Number):void {}
		public function createImage():starling.display.Image { return null; }
		public function getKerning(charID:int):Number { return 0; }
	}

}
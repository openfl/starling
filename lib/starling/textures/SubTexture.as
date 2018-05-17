package starling.textures {

	import openfl.geom.Rectangle;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public class SubTexture extends Texture {
		public function get ownsParent():Boolean { return false; }
		public function get parent():Texture { return null; }
		public function get region():openfl.geom.Rectangle { return null; }
		public function get rotated():Boolean { return false; }
		public function SubTexture(parent:Texture, region:openfl.geom.Rectangle = null, ownsParent:Boolean = false, frame:openfl.geom.Rectangle = null, rotated:Boolean = false, scaleModifier:Number = 0):void {}
	}

}
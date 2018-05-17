package starling.textures {

	import openfl.geom.Rectangle;
	import openfl.Vector;
	import starling.textures.SubTexture;

	/**
	 * @externs
	 */
	public class TextureAtlas {
		public function get texture():Texture { return null; }
		public function TextureAtlas(texture:Texture, atlasXml:Object = null):void {}
		public function addRegion(name:String, region:openfl.geom.Rectangle, frame:openfl.geom.Rectangle = null, rotated:Boolean = false):void {}
		public function dispose():void {}
		public function getFrame(name:String):openfl.geom.Rectangle { return null; }
		public function getNames(prefix:String = null, result:openfl.Vector = null):openfl.Vector { return null; }
		public function getRegion(name:String):openfl.geom.Rectangle { return null; }
		public function getRotation(name:String):Boolean { return false; }
		public function getTexture(name:String):Texture { return null; }
		public function getTextures(prefix:String = null, result:openfl.Vector = null):openfl.Vector { return null; }
		public function removeRegion(name:String):void {}
	}

}
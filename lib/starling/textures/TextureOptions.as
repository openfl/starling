package starling.textures {

	import starling.core.Starling;

	/**
	 * @externs
	 */
	public class TextureOptions {
		public var forcePotTexture:Boolean;
		public var format:String;
		public var mipMapping:Boolean;
		public var onReady:Function;
		public var optimizeForRenderToTexture:Boolean;
		public var premultipliedAlpha:Boolean;
		public var scale:Number;
		public function TextureOptions(scale:Number = 0, mipMapping:Boolean = false, format:String = null, premultipliedAlpha:Boolean = false, forcePotTexture:Boolean = false):void {}
		public function clone():TextureOptions { return null; }
	}

}
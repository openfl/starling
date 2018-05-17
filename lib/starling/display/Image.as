package starling.display {
	
	import openfl.geom.Rectangle;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.MathUtil;
	import starling.utils.Pool;
	import starling.utils.RectangleUtil;
	import starling.utils.Padding;
	// import starling.display.TextureSetupSettings;
	
	/**
	 * @externs
	 */
	public class Image extends Quad {
		public var scale9Grid:Rectangle;
		public var tileGrid:Rectangle;
		public function Image(texture:Texture):void { super (0, 0); }
		public static function automateSetupForTexture(texture:Texture, onAssign:Function, onRelease:Function = null):void {}
		public static function bindPivotPointToTexture(texture:Texture, pivotX:Number, pivotY:Number):void {}
		public static function bindScale9GridToTexture(texture:Texture, scale9Grid:Rectangle):void {}
		public static function resetSetupForTexture(texture:Texture):void {}
	}
	
}
package starling.textures {

	import openfl.geom.Matrix;
	import starling.textures.SubTexture;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.DisplayObject;

	/**
	 * @externs
	 */
	public class RenderTexture extends SubTexture {
		public function get isPersistent():Boolean { return false; }
		public function RenderTexture(width:int, height:int, persistent:Boolean = false, scale:Number = 0, format:String = null):void { super (null); }
		public function clear(color:uint = 0, alpha:Number = 0):void {}
		public function draw(object:starling.display.DisplayObject, matrix:openfl.geom.Matrix = null, alpha:Number = 0, antiAliasing:int = 0):void {}
		public function drawBundled(drawingBlock:Function, antiAliasing:int = 0):void {}
		public static var useDoubleBuffering:Boolean;
	}

}
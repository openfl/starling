package starling.display {
	
	
	import openfl.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.styles.MeshStyle;
	
	//@:meta(Event(name = "triggered", type = "starling.events.Event"))
	
	/**
	 * @externs
	 */
	public class Button extends DisplayObjectContainer {
		public var alphaWhenDisabled:Number;
		public var alphaWhenDown:Number;
		public var color:uint;
		public var disabledState:Texture;
		public var downState:Texture;
		public var enabled:Boolean;
		public var overState:Texture;
		public function get overlay():Sprite { return null; }
		public var pixelSnapping:Boolean;
		public var scale9Grid:Rectangle;
		public var scaleWhenDown:Number;
		public var scaleWhenOver:Number;
		public var state:String;
		public var style:MeshStyle;
		public var text:String;
		public var textBounds:Rectangle;
		public var textFormat:TextFormat;
		public var textStyle:MeshStyle;
		public var textureSmoothing:String;
		public var upState:Texture;
		public function Button(upState:Texture, text:String = null, downState:Texture = null, overState:Texture = null, disabledState:Texture = null):void {}
		public function readjustSize(resetTextBounds:Boolean = false):void {}
	}
	
	
}
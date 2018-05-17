package starling.text {

	import openfl.geom.Rectangle;
	import starling.display.DisplayObjectContainer;
	import starling.text.BitmapFont;
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TrueTypeCompositor;
	import starling.utils.SystemUtil;
	import starling.text.TextFormat;
	import starling.text.TextOptions;
	import starling.display.MeshBatch;
	import starling.styles.MeshStyle;

	/**
	 * @externs
	 */
	public class TextField extends starling.display.DisplayObjectContainer {
		public var autoScale:Boolean;
		public var autoSize:String;
		public var batchable:Boolean;
		public var border:Boolean;
		public var format:TextFormat;
		public var isHtmlText:Boolean;
		public var pixelSnapping:Boolean;
		public var style:starling.styles.MeshStyle;
		public var text:String;
		public function get textBounds():openfl.geom.Rectangle { return null; }
		public var wordWrap:Boolean;
		public function TextField(width:int, height:int, text:String = null, format:TextFormat = null):void {}
		// public function get_border():Boolean { return false; }
		public function setRequiresRecomposition():void {}
		// public function set_border(value:Boolean):Boolean { return false; }
		public static var defaultCompositor:ITextCompositor;
		public static var defaultTextureFormat:String;
		public static function getBitmapFont(name:String):BitmapFont { return null; }
		public static function getCompositor(name:String):ITextCompositor { return null; }
		/*@:deprecated("replaced by `registerCompositor`")*/ public static function registerBitmapFont(bitmapFont:BitmapFont, name:String = null):String { return null; }
		public static function registerCompositor(compositor:ITextCompositor, name:String):void {}
		/*@:deprecated("replaced by `unregisterCompositor`")*/ public static function unregisterBitmapFont(name:String, dispose:Boolean = false):void {}
		public static function unregisterCompositor(name:String, dispose:Boolean = false):void {}
		public static function updateEmbeddedFonts():void {}
	}

}
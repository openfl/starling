package starling.text;

import starling.display.DisplayObjectContainer;
import starling.text.BitmapFont;
import starling.core.Starling;
import starling.utils.RectangleUtil;
import starling.display.Sprite;
import starling.display.Quad;
import starling.text.TrueTypeCompositor;
import starling.utils.SystemUtil;
import js.Boot;
import haxe.ds.StringMap;
import starling.text.TextFormat;
import starling.text.TextOptions;
import starling.display.MeshBatch;

@:jsRequire("starling/text/TextField", "default")

extern class TextField extends starling.display.DisplayObjectContainer {
	var autoScale(get,set) : Bool;
	var autoSize(get,set) : String;
	var batchable(get,set) : Bool;
	var border(get,set) : Bool;
	var format(get,set) : TextFormat;
	var isHtmlText(get,set) : Bool;
	var pixelSnapping(get,set) : Bool;
	var style(get,set) : starling.styles.MeshStyle;
	var text(get,set) : String;
	var textBounds(get,never) : openfl.geom.Rectangle;
	var wordWrap(get,set) : Bool;
	function new(width : Int, height : Int, ?text : String, ?format : TextFormat) : Void;
	function get_border() : Bool;
	function setRequiresRecomposition() : Void;
	function set_border(value : Bool) : Bool;
	static var defaultCompositor(get,set) : ITextCompositor;
	static var defaultTextureFormat(get,set) : String;
	static function getBitmapFont(name : String) : BitmapFont;
	static function getCompositor(name : String) : ITextCompositor;
	@:deprecated("replaced by `registerCompositor`") static function registerBitmapFont(bitmapFont : BitmapFont, ?name : String) : String;
	static function registerCompositor(compositor : ITextCompositor, name : String) : Void;
	@:deprecated("replaced by `unregisterCompositor`") static function unregisterBitmapFont(name : String, dispose : Bool = false) : Void;
	static function unregisterCompositor(name : String, dispose : Bool = false) : Void;
	static function updateEmbeddedFonts() : Void;
}

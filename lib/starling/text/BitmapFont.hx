package starling.text;

import starling.text.ITextCompositor;
import Std;
import haxe.Log;
import starling.textures.Texture;
import starling.text.BitmapChar;
import HxOverrides;
import starling.display.Sprite;
// import starling.text.CharLocation;
// import starling.utils.ArrayUtil;
import starling.text.TextOptions;
// import starling.text.MiniBitmapFont;
import haxe.ds.IntMap;
import starling.display.Image;

@:jsRequire("starling/text/BitmapFont", "default")

extern class BitmapFont implements Dynamic {

	function new(?texture:Dynamic, ?fontXml:Dynamic);
	var __texture:Dynamic;
	var __chars:Dynamic;
	var __name:Dynamic;
	var __size:Dynamic;
	var __lineHeight:Dynamic;
	var __baseline:Dynamic;
	var __offsetX:Dynamic;
	var __offsetY:Dynamic;
	var __padding:Dynamic;
	var __helperImage:Dynamic;
	function dispose():Dynamic;
	function parseFontXml(fontXml:Dynamic):Dynamic;
	function getChar(charID:Dynamic):Dynamic;
	function addChar(charID:Dynamic, bitmapChar:Dynamic):Dynamic;
	function getCharIDs(?result:Dynamic):Dynamic;
	function hasChars(text:Dynamic):Dynamic;
	function createSprite(width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, ?options:Dynamic):Dynamic;
	function fillMeshBatch(meshBatch:Dynamic, width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, ?options:Dynamic):Dynamic;
	function clearMeshBatch(meshBatch:Dynamic):Dynamic;
	function arrangeChars(width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, options:Dynamic):Dynamic;
	var name:Dynamic;
	function get_name():Dynamic;
	var size:Dynamic;
	function get_size():Dynamic;
	var lineHeight:Dynamic;
	function get_lineHeight():Dynamic;
	function set_lineHeight(value:Dynamic):Dynamic;
	var smoothing:Dynamic;
	function get_smoothing():Dynamic;
	function set_smoothing(value:Dynamic):Dynamic;
	var baseline:Dynamic;
	function get_baseline():Dynamic;
	function set_baseline(value:Dynamic):Dynamic;
	var offsetX:Dynamic;
	function get_offsetX():Dynamic;
	function set_offsetX(value:Dynamic):Dynamic;
	var offsetY:Dynamic;
	function get_offsetY():Dynamic;
	function set_offsetY(value:Dynamic):Dynamic;
	var padding:Dynamic;
	function get_padding():Dynamic;
	function set_padding(value:Dynamic):Dynamic;
	function get_texture():Dynamic;
	static var NATIVE_SIZE:Dynamic;
	static var MINI:Dynamic;
	static var CHAR_SPACE:Dynamic;
	static var CHAR_TAB:Dynamic;
	static var CHAR_NEWLINE:Dynamic;
	static var CHAR_CARRIAGE_RETURN:Dynamic;
	static var sLines:Dynamic;
	static var sDefaultOptions:Dynamic;


}
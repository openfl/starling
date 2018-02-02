package starling.text;

import starling.events.EventDispatcher;
import Type;
import starling.core.Starling;
import starling.text.TextField;

@:jsRequire("starling/text/TextOptions", "default")

extern class TextOptions extends starling.events.EventDispatcher implements Dynamic {

	function new(?wordWrap:Dynamic, ?autoScale:Dynamic);
	var __wordWrap:Dynamic;
	var __autoScale:Dynamic;
	var __autoSize:Dynamic;
	var __isHtmlText:Dynamic;
	var __textureScale:Dynamic;
	var __textureFormat:Dynamic;
	var __padding:Dynamic;
	function copyFrom(options:Dynamic):Dynamic;
	function clone():Dynamic;
	var wordWrap:Dynamic;
	function get_wordWrap():Dynamic;
	function set_wordWrap(value:Dynamic):Dynamic;
	var autoSize:Dynamic;
	function get_autoSize():Dynamic;
	function set_autoSize(value:Dynamic):Dynamic;
	var autoScale:Dynamic;
	function get_autoScale():Dynamic;
	function set_autoScale(value:Dynamic):Dynamic;
	var isHtmlText:Dynamic;
	function get_isHtmlText():Dynamic;
	function set_isHtmlText(value:Dynamic):Dynamic;
	var textureScale:Dynamic;
	function get_textureScale():Dynamic;
	function set_textureScale(value:Dynamic):Dynamic;
	var textureFormat:Dynamic;
	function get_textureFormat():Dynamic;
	function set_textureFormat(value:Dynamic):Dynamic;
	var padding:Dynamic;
	function get_padding():Dynamic;
	function set_padding(value:Dynamic):Dynamic;


}
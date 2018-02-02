package starling.text;

import starling.events.EventDispatcher;
import Std;
import starling.utils.Align;

@:jsRequire("starling/text/TextFormat", "default")

extern class TextFormat extends starling.events.EventDispatcher implements Dynamic {

	function new(?font:Dynamic, ?size:Dynamic, ?color:Dynamic, ?horizontalAlign:Dynamic, ?verticalAlign:Dynamic);
	var __font:Dynamic;
	var __size:Dynamic;
	var __color:Dynamic;
	var __bold:Dynamic;
	var __italic:Dynamic;
	var __underline:Dynamic;
	var __horizontalAlign:Dynamic;
	var __verticalAlign:Dynamic;
	var __kerning:Dynamic;
	var __leading:Dynamic;
	var __letterSpacing:Dynamic;
	function copyFrom(format:Dynamic):Dynamic;
	function clone():Dynamic;
	function setTo(?font:Dynamic, ?size:Dynamic, ?color:Dynamic, ?horizontalAlign:Dynamic, ?verticalAlign:Dynamic):Dynamic;
	function toNativeFormat(?out:Dynamic):Dynamic;
	var font:Dynamic;
	function get_font():Dynamic;
	function set_font(value:Dynamic):Dynamic;
	var size:Dynamic;
	function get_size():Dynamic;
	function set_size(value:Dynamic):Dynamic;
	var color:Dynamic;
	function get_color():Dynamic;
	function set_color(value:Dynamic):Dynamic;
	var bold:Dynamic;
	function get_bold():Dynamic;
	function set_bold(value:Dynamic):Dynamic;
	var italic:Dynamic;
	function get_italic():Dynamic;
	function set_italic(value:Dynamic):Dynamic;
	var underline:Dynamic;
	function get_underline():Dynamic;
	function set_underline(value:Dynamic):Dynamic;
	var horizontalAlign:Dynamic;
	function get_horizontalAlign():Dynamic;
	function set_horizontalAlign(value:Dynamic):Dynamic;
	var verticalAlign:Dynamic;
	function get_verticalAlign():Dynamic;
	function set_verticalAlign(value:Dynamic):Dynamic;
	var kerning:Dynamic;
	function get_kerning():Dynamic;
	function set_kerning(value:Dynamic):Dynamic;
	var leading:Dynamic;
	function get_leading():Dynamic;
	function set_leading(value:Dynamic):Dynamic;
	var letterSpacing:Dynamic;
	function get_letterSpacing():Dynamic;
	function set_letterSpacing(value:Dynamic):Dynamic;


}
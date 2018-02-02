package starling.text;

import openfl.text.TextFormat;
import starling.events.EventDispatcher;
import Std;
import starling.utils.Align;

@:jsRequire("starling/text/TextFormat", "default")

@:meta(Event(name = "change", type = "starling.events.Event")) extern class TextFormat extends starling.events.EventDispatcher {
	var bold(get,set) : Bool;
	var color(get,set) : UInt;
	var font(get,set) : String;
	var horizontalAlign(get,set) : String;
	var italic(get,set) : Bool;
	var kerning(get,set) : Bool;
	var leading(get,set) : Float;
	var letterSpacing(get,set) : Float;
	var size(get,set) : Float;
	var underline(get,set) : Bool;
	var verticalAlign(get,set) : String;
	function new(?font : String, size : Float = 0, color : UInt = 0, ?horizontalAlign : String, ?verticalAlign : String) : Void;
	function clone() : TextFormat;
	function copyFrom(format : TextFormat) : Void;
	function setTo(?font : String, size : Float = 0, color : UInt = 0, ?horizontalAlign : String, ?verticalAlign : String) : Void;
	function toNativeFormat(?out : TextFormat) : TextFormat;
}

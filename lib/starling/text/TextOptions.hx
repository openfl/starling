package starling.text;

import starling.events.EventDispatcher;
import Type;
import starling.core.Starling;
import starling.text.TextField;

@:jsRequire("starling/text/TextOptions", "default")

@:meta(Event(name = "change", type = "starling.events.Event")) extern class TextOptions extends starling.events.EventDispatcher {
	var autoScale(get,set) : Bool;
	var autoSize(get,set) : String;
	var isHtmlText(get,set) : Bool;
	var padding(get,set) : Float;
	var textureFormat(get,set) : String;
	var textureScale(get,set) : Float;
	var wordWrap(get,set) : Bool;
	function new(wordWrap : Bool = false, autoScale : Bool = false) : Void;
	function clone() : TextOptions;
	function copyFrom(options : TextOptions) : Void;
}

package starling.utils;

import starling.events.EventDispatcher;

@:jsRequire("starling/utils/Padding", "default")

@:meta(Event(name = "change", type = "starling.events.Event")) extern class Padding extends starling.events.EventDispatcher {
	var bottom(get,set) : Float;
	var left(get,set) : Float;
	var right(get,set) : Float;
	var top(get,set) : Float;
	function new(left : Float = 0, right : Float = 0, top : Float = 0, bottom : Float = 0) : Void;
	function clone() : Padding;
	function copyFrom(padding : Padding) : Void;
	function setTo(left : Float = 0, right : Float = 0, top : Float = 0, bottom : Float = 0) : Void;
	function setToSymmetric(horizontal : Float, vertical : Float) : Void;
	function setToUniform(value : Float) : Void;
}

package starling.events;

import starling.events.Event;
import js.Boot;
import starling.events.EventDispatcher;

@:jsRequire("starling/events/TouchEvent", "default")

extern class TouchEvent extends Event {
	var ctrlKey(get,never) : Bool;
	var shiftKey(get,never) : Bool;
	var timestamp(get,never) : Float;
	var touches(get,never) : openfl.Vector<Touch>;
	function new(type : String, ?touches : openfl.Vector<Touch>, shiftKey : Bool = false, ctrlKey : Bool = false, bubbles : Bool = false) : Void;
	function dispatch(chain : openfl.Vector<EventDispatcher>) : Void;
	function getTouch(target : starling.display.DisplayObject, ?phase : String, id : Int = 0) : Touch;
	function getTouches(target : starling.display.DisplayObject, ?phase : String, ?out : openfl.Vector<Touch>) : openfl.Vector<Touch>;
	function interactsWith(target : starling.display.DisplayObject) : Bool;
	static var TOUCH(default,never) : String;
}

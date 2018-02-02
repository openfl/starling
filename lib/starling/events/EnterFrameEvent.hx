package starling.events;

import starling.events.Event;

@:jsRequire("starling/events/EnterFrameEvent", "default")

extern class EnterFrameEvent extends Event {
	var passedTime(get,never) : Float;
	function new(type : String, passedTime : Float, bubbles : Bool = false) : Void;
	static var ENTER_FRAME(default,never) : String;
}

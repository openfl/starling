package starling.events;

import starling.events.Event;
import Std;
import js.Boot;

@:jsRequire("starling/events/ResizeEvent", "default")

extern class ResizeEvent extends Event {
	var height(get,never) : Int;
	var width(get,never) : Int;
	function new(type : String, width : Int, height : Int, bubbles : Bool = false) : Void;
	static var RESIZE(default,never) : String;
}

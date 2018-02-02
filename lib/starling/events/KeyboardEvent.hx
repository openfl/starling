package starling.events;

import starling.events.Event;

@:jsRequire("starling/events/KeyboardEvent", "default")
extern class KeyboardEvent extends Event {
	var altKey(get,never) : Bool;
	var charCode(get,never) : UInt;
	var ctrlKey(get,never) : Bool;
	var keyCode(get,never) : UInt;
	var keyLocation(get,never) : UInt;
	var shiftKey(get,never) : Bool;
	function new(type : String, charCode : UInt = 0, keyCode : UInt = 0, keyLocation : UInt = 0, ctrlKey : Bool = false, altKey : Bool = false, shiftKey : Bool = false) : Void;
	function isDefaultPrevented() : Bool;
	function preventDefault() : Void;
	static var KEY_DOWN(default,never) : String;
	static var KEY_UP(default,never) : String;
}

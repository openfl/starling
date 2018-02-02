package starling.events;

import starling.events.Event;

@:jsRequire("starling/events/EnterFrameEvent", "default")

extern class EnterFrameEvent extends starling.events.Event implements Dynamic {

	function new(type:Dynamic, passedTime:Dynamic, ?bubbles:Dynamic);
	var passedTime:Dynamic;
	function get_passedTime():Dynamic;
	static var ENTER_FRAME:Dynamic;


}
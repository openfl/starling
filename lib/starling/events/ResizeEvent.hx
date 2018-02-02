package starling.events;

import starling.events.Event;
import Std;
import js.Boot;

@:jsRequire("starling/events/ResizeEvent", "default")

extern class ResizeEvent extends starling.events.Event implements Dynamic {

	function new(type:Dynamic, width:Dynamic, height:Dynamic, ?bubbles:Dynamic);
	var width:Dynamic;
	function get_width():Dynamic;
	var height:Dynamic;
	function get_height():Dynamic;
	static var RESIZE:Dynamic;


}
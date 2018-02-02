package starling.events;

import starling.events.Event;
import js.Boot;
import starling.events.EventDispatcher;

@:jsRequire("starling/events/TouchEvent", "default")

extern class TouchEvent extends starling.events.Event implements Dynamic {

	function new(type:Dynamic, ?touches:Dynamic, ?shiftKey:Dynamic, ?ctrlKey:Dynamic, ?bubbles:Dynamic);
	var __shiftKey:Dynamic;
	var __ctrlKey:Dynamic;
	var __timestamp:Dynamic;
	var __visitedObjects:Dynamic;
	function resetTo(type:Dynamic, ?touches:Dynamic, ?shiftKey:Dynamic, ?ctrlKey:Dynamic, ?bubbles:Dynamic):Dynamic;
	function updateTimestamp(touches:Dynamic):Dynamic;
	function getTouches(target:Dynamic, ?phase:Dynamic, ?out:Dynamic):Dynamic;
	function getTouch(target:Dynamic, ?phase:Dynamic, ?id:Dynamic):Dynamic;
	function interactsWith(target:Dynamic):Dynamic;
	function dispatch(chain:Dynamic):Dynamic;
	var timestamp:Dynamic;
	function get_timestamp():Dynamic;
	var touches:Dynamic;
	function get_touches():Dynamic;
	var shiftKey:Dynamic;
	function get_shiftKey():Dynamic;
	var ctrlKey:Dynamic;
	function get_ctrlKey():Dynamic;
	static var TOUCH:Dynamic;
	static var sTouches:Dynamic;


}
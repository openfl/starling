package starling.events;

import haxe.ds.StringMap;
import Reflect;
import Std;
import starling.display.DisplayObject;
import js.Boot;
import starling.events.Event;

@:jsRequire("starling/events/EventDispatcher", "default")

extern class EventDispatcher implements Dynamic {

	function new();
	var __eventListeners:Dynamic;
	var __eventStack:Dynamic;
	function addEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	function removeEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	function removeEventListeners(?type:Dynamic):Dynamic;
	function dispatchEvent(event:Dynamic):Dynamic;
	function __invokeEvent(event:Dynamic):Dynamic;
	function __bubbleEvent(event:Dynamic):Dynamic;
	function dispatchEventWith(type:Dynamic, ?bubbles:Dynamic, ?data:Dynamic):Dynamic;
	function hasEventListener(type:Dynamic, ?listener:Dynamic):Dynamic;
	static var sBubbleChains:Dynamic;


}
package starling.events;

import haxe.ds.StringMap;
import Reflect;
import Std;
import starling.display.DisplayObject;
import js.Boot;
import starling.events.Event;
import haxe.Constraints.Function;

@:jsRequire("starling/events/EventDispatcher", "default")

extern class EventDispatcher {
	function new() : Void;
	function addEventListener(type : String, listener : Function) : Void;
	function dispatchEvent(event : Event) : Void;
	function dispatchEventWith(type : String, bubbles : Bool = false, ?data : Dynamic) : Void;
	function hasEventListener(type : String, ?listener : Dynamic) : Bool;
	function removeEventListener(type : String, listener : haxe.Constraints.Function) : Void;
	function removeEventListeners(?type : String) : Void;
}
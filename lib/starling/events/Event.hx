package starling.events;

import starling.utils.StringUtil;
import Type;

@:jsRequire("starling/events/Event", "default")

extern class Event {
	var bubbles(default,null) : Bool;
	var currentTarget(default,null) : EventDispatcher;
	var data(default,null) : Dynamic;
	var target(default,null) : EventDispatcher;
	var type(default,null) : String;
	function new(type : String, bubbles : Bool = false, ?data : Dynamic) : Void;
	function stopImmediatePropagation() : Void;
	function stopPropagation() : Void;
	function toString() : String;
	static var ADDED(default,never) : String;
	static var ADDED_TO_STAGE(default,never) : String;
	static var CANCEL(default,never) : String;
	static var CHANGE(default,never) : String;
	static var CLOSE(default,never) : String;
	static var COMPLETE(default,never) : String;
	static var CONTEXT3D_CREATE(default,never) : String;
	static var ENTER_FRAME(default,never) : String;
	static var FATAL_ERROR(default,never) : String;
	static var IO_ERROR(default,never) : String;
	static var OPEN(default,never) : String;
	static var PARSE_ERROR(default,never) : String;
	static var READY(default,never) : String;
	static var REMOVED(default,never) : String;
	static var REMOVED_FROM_STAGE(default,never) : String;
	static var REMOVE_FROM_JUGGLER(default,never) : String;
	static var RENDER(default,never) : String;
	static var RESIZE(default,never) : String;
	static var ROOT_CREATED(default,never) : String;
	static var SCROLL(default,never) : String;
	static var SECURITY_ERROR(default,never) : String;
	static var SELECT(default,never) : String;
	static var TEXTURES_RESTORED(default,never) : String;
	static var TRIGGERED(default,never) : String;
	static var UPDATE(default,never) : String;
}

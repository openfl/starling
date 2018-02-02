package starling.events;

import starling.utils.StringUtil;
import Type;

@:jsRequire("starling/events/Event", "default")

extern class Event implements Dynamic {

	function new(type:Dynamic, ?bubbles:Dynamic, ?data:Dynamic);
	function stopPropagation():Dynamic;
	function stopImmediatePropagation():Dynamic;
	function toString():Dynamic;
	var bubbles:Dynamic;
	var target:Dynamic;
	var currentTarget:Dynamic;
	var type:Dynamic;
	
	function setTarget(value:Dynamic):Dynamic;
	function setCurrentTarget(value:Dynamic):Dynamic;
	function setData(value:Dynamic):Dynamic;
	var stopsPropagation:Dynamic;
	var stopsImmediatePropagation:Dynamic;
	function reset(type:Dynamic, ?bubbles:Dynamic, ?data:Dynamic):Dynamic;
	static var ADDED:Dynamic;
	static var ADDED_TO_STAGE:Dynamic;
	static var ENTER_FRAME:Dynamic;
	static var REMOVED:Dynamic;
	static var REMOVED_FROM_STAGE:Dynamic;
	static var TRIGGERED:Dynamic;
	static var RESIZE:Dynamic;
	static var COMPLETE:Dynamic;
	static var CONTEXT3D_CREATE:Dynamic;
	static var RENDER:Dynamic;
	static var ROOT_CREATED:Dynamic;
	static var REMOVE_FROM_JUGGLER:Dynamic;
	static var TEXTURES_RESTORED:Dynamic;
	static var IO_ERROR:Dynamic;
	static var SECURITY_ERROR:Dynamic;
	static var PARSE_ERROR:Dynamic;
	static var FATAL_ERROR:Dynamic;
	static var CHANGE:Dynamic;
	static var CANCEL:Dynamic;
	static var SCROLL:Dynamic;
	static var OPEN:Dynamic;
	static var CLOSE:Dynamic;
	static var SELECT:Dynamic;
	static var READY:Dynamic;
	static var UPDATE:Dynamic;
	static var sEventPool:Dynamic;
	static function fromPool(type:Dynamic, ?bubbles:Dynamic, ?data:Dynamic):Dynamic;
	static function toPool(event:Dynamic):Dynamic;


}
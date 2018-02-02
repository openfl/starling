package starling.events;

import starling.utils.StringUtil;

@:jsRequire("starling/events/Touch", "default")

extern class Touch implements Dynamic {

	function new(id:Dynamic);
	var __id:Dynamic;
	var __globalX:Dynamic;
	var __globalY:Dynamic;
	var __previousGlobalX:Dynamic;
	var __previousGlobalY:Dynamic;
	var __tapCount:Dynamic;
	var __phase:Dynamic;
	var __target:Dynamic;
	var __timestamp:Dynamic;
	var __pressure:Dynamic;
	var __width:Dynamic;
	var __height:Dynamic;
	var __cancelled:Dynamic;
	var __bubbleChain:Dynamic;
	function getLocation(space:Dynamic, ?out:Dynamic):Dynamic;
	function getPreviousLocation(space:Dynamic, ?out:Dynamic):Dynamic;
	function getMovement(space:Dynamic, ?out:Dynamic):Dynamic;
	function isTouching(target:Dynamic):Dynamic;
	function toString():Dynamic;
	function clone():Dynamic;
	function updateBubbleChain():Dynamic;
	var id:Dynamic;
	function get_id():Dynamic;
	var previousGlobalX:Dynamic;
	function get_previousGlobalX():Dynamic;
	var previousGlobalY:Dynamic;
	function get_previousGlobalY():Dynamic;
	var globalX:Dynamic;
	function get_globalX():Dynamic;
	function set_globalX(value:Dynamic):Dynamic;
	var globalY:Dynamic;
	function get_globalY():Dynamic;
	function set_globalY(value:Dynamic):Dynamic;
	var tapCount:Dynamic;
	function get_tapCount():Dynamic;
	function set_tapCount(value:Dynamic):Dynamic;
	var phase:Dynamic;
	function get_phase():Dynamic;
	function set_phase(value:Dynamic):Dynamic;
	var target:Dynamic;
	function get_target():Dynamic;
	function set_target(value:Dynamic):Dynamic;
	var timestamp:Dynamic;
	function get_timestamp():Dynamic;
	function set_timestamp(value:Dynamic):Dynamic;
	var pressure:Dynamic;
	function get_pressure():Dynamic;
	function set_pressure(value:Dynamic):Dynamic;
	var width:Dynamic;
	function get_width():Dynamic;
	function set_width(value:Dynamic):Dynamic;
	var height:Dynamic;
	function get_height():Dynamic;
	function set_height(value:Dynamic):Dynamic;
	var cancelled:Dynamic;
	function get_cancelled():Dynamic;
	function set_cancelled(value:Dynamic):Dynamic;
	function dispatchEvent(event:Dynamic):Dynamic;
	var bubbleChain:Dynamic;
	function get_bubbleChain():Dynamic;
	static var sHelperPoint:Dynamic;


}
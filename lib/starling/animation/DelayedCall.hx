package starling.animation;

import starling.animation.IAnimatable;
import starling.events.EventDispatcher;
import Reflect;

@:jsRequire("starling/animation/DelayedCall", "default")

extern class DelayedCall extends starling.events.EventDispatcher implements Dynamic {

	function new(callback:Dynamic, delay:Dynamic, ?args:Dynamic);
	var __currentTime:Dynamic;
	var __totalTime:Dynamic;
	var __callback:Dynamic;
	var __args:Dynamic;
	var __repeatCount:Dynamic;
	function reset(callback:Dynamic, delay:Dynamic, ?args:Dynamic):Dynamic;
	function advanceTime(time:Dynamic):Dynamic;
	function complete():Dynamic;
	var isComplete:Dynamic;
	function get_isComplete():Dynamic;
	var totalTime:Dynamic;
	function get_totalTime():Dynamic;
	var currentTime:Dynamic;
	function get_currentTime():Dynamic;
	var repeatCount:Dynamic;
	function get_repeatCount():Dynamic;
	function set_repeatCount(value:Dynamic):Dynamic;
	var callback:Dynamic;
	function get_callback():Dynamic;
	var arguments:Dynamic;
	function get_arguments():Dynamic;
	static var sPool:Dynamic;
	static function fromPool(call:Dynamic, delay:Dynamic, ?args:Dynamic):Dynamic;
	static function toPool(delayedCall:Dynamic):Dynamic;


}
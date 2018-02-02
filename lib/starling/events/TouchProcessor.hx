package starling.events;

import js.Boot;
import starling.events.Touch;
import starling.utils.MathUtil;
import starling.core.Starling;
import starling.events.TouchMarker;
import starling.events.TouchEvent;

@:jsRequire("starling/events/TouchProcessor", "default")

extern class TouchProcessor implements Dynamic {

	function new(stage:Dynamic);
	var __stage:Dynamic;
	var __root:Dynamic;
	var __elapsedTime:Dynamic;
	var __lastTaps:Dynamic;
	var __shiftDown:Dynamic;
	var __ctrlDown:Dynamic;
	var __multitapTime:Dynamic;
	var __multitapDistance:Dynamic;
	var __touchEvent:Dynamic;
	var __touchMarker:Dynamic;
	var __simulateMultitouch:Dynamic;
	var __queue:Dynamic;
	var __currentTouches:Dynamic;
	function dispose():Dynamic;
	function advanceTime(passedTime:Dynamic):Dynamic;
	function processTouches(touches:Dynamic, shiftDown:Dynamic, ctrlDown:Dynamic):Dynamic;
	function enqueue(touchID:Dynamic, phase:Dynamic, globalX:Dynamic, globalY:Dynamic, ?pressure:Dynamic, ?width:Dynamic, ?height:Dynamic):Dynamic;
	function enqueueMouseLeftStage():Dynamic;
	function cancelTouches():Dynamic;
	function createOrUpdateTouch(touchID:Dynamic, phase:Dynamic, globalX:Dynamic, globalY:Dynamic, ?pressure:Dynamic, ?width:Dynamic, ?height:Dynamic):Dynamic;
	function updateTapCount(touch:Dynamic):Dynamic;
	function addCurrentTouch(touch:Dynamic):Dynamic;
	function getCurrentTouch(touchID:Dynamic):Dynamic;
	function containsTouchWithID(touches:Dynamic, touchID:Dynamic):Dynamic;
	var simulateMultitouch:Dynamic;
	function get_simulateMultitouch():Dynamic;
	function set_simulateMultitouch(value:Dynamic):Dynamic;
	var multitapTime:Dynamic;
	function get_multitapTime():Dynamic;
	function set_multitapTime(value:Dynamic):Dynamic;
	var multitapDistance:Dynamic;
	function get_multitapDistance():Dynamic;
	function set_multitapDistance(value:Dynamic):Dynamic;
	var root:Dynamic;
	function get_root():Dynamic;
	function set_root(value:Dynamic):Dynamic;
	var stage:Dynamic;
	function get_stage():Dynamic;
	var numCurrentTouches:Dynamic;
	function get_numCurrentTouches():Dynamic;
	function onKey(event:Dynamic):Dynamic;
	function monitorInterruptions(enable:Dynamic):Dynamic;
	function onInterruption(event:Dynamic):Dynamic;
	static var sUpdatedTouches:Dynamic;
	static var sHoveringTouchData:Dynamic;
	static var sHelperPoint:Dynamic;


}
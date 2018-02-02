package starling.events;

import js.Boot;
import starling.events.Touch;
import starling.utils.MathUtil;
import starling.core.Starling;
import starling.events.TouchMarker;
import starling.events.TouchEvent;

@:jsRequire("starling/events/TouchProcessor", "default")

extern class TouchProcessor {
	var multitapDistance(get,set) : Float;
	var multitapTime(get,set) : Float;
	var numCurrentTouches(get,never) : Int;
	var root(get,set) : starling.display.DisplayObject;
	var simulateMultitouch(get,set) : Bool;
	var stage(get,never) : starling.display.Stage;
	function new(stage : starling.display.Stage) : Void;
	function advanceTime(passedTime : Float) : Void;
	function cancelTouches() : Void;
	function dispose() : Void;
	function enqueue(touchID : Int, phase : String, globalX : Float, globalY : Float, pressure : Float = 0, width : Float = 0, height : Float = 0) : Void;
	function enqueueMouseLeftStage() : Void;
}

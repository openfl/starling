import js_Boot from "./../../js/Boot";
import starling_events_Touch from "./../../starling/events/Touch";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_events_TouchMarker from "./../../starling/events/TouchMarker";
import openfl_Lib from "openfl/Lib";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_Error from "openfl/errors/Error";
import openfl_Vector from "openfl/Vector";
import openfl_geom_Point from "openfl/geom/Point";
import starling_events_TouchEvent from "./../../starling/events/TouchEvent";

declare namespace starling.events {

export class TouchProcessor {

	constructor(stage:any);
	__stage:any;
	__root:any;
	__elapsedTime:any;
	__lastTaps:any;
	__shiftDown:any;
	__ctrlDown:any;
	__multitapTime:any;
	__multitapDistance:any;
	__touchEvent:any;
	__touchMarker:any;
	__simulateMultitouch:any;
	__queue:any;
	__currentTouches:any;
	dispose():any;
	advanceTime(passedTime:any):any;
	processTouches(touches:any, shiftDown:any, ctrlDown:any):any;
	enqueue(touchID:any, phase:any, globalX:any, globalY:any, pressure?:any, width?:any, height?:any):any;
	enqueueMouseLeftStage():any;
	cancelTouches():any;
	createOrUpdateTouch(touchID:any, phase:any, globalX:any, globalY:any, pressure?:any, width?:any, height?:any):any;
	updateTapCount(touch:any):any;
	addCurrentTouch(touch:any):any;
	getCurrentTouch(touchID:any):any;
	containsTouchWithID(touches:any, touchID:any):any;
	simulateMultitouch:any;
	get_simulateMultitouch():any;
	set_simulateMultitouch(value:any):any;
	multitapTime:any;
	get_multitapTime():any;
	set_multitapTime(value:any):any;
	multitapDistance:any;
	get_multitapDistance():any;
	set_multitapDistance(value:any):any;
	root:any;
	get_root():any;
	set_root(value:any):any;
	stage:any;
	get_stage():any;
	numCurrentTouches:any;
	get_numCurrentTouches():any;
	onKey(event:any):any;
	monitorInterruptions(enable:any):any;
	onInterruption(event:any):any;
	static sUpdatedTouches:any;
	static sHoveringTouchData:any;
	static sHelperPoint:any;


}

}

export default starling.events.TouchProcessor;
import starling_events_Event from "./../../starling/events/Event";
import openfl_Vector from "openfl/Vector";
import js_Boot from "./../../js/Boot";
import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";

declare namespace starling.events {

export class TouchEvent extends starling_events_Event {

	constructor(type:any, touches?:any, shiftKey?:any, ctrlKey?:any, bubbles?:any);
	__shiftKey:any;
	__ctrlKey:any;
	__timestamp:any;
	__visitedObjects:any;
	resetTo(type:any, touches?:any, shiftKey?:any, ctrlKey?:any, bubbles?:any):any;
	updateTimestamp(touches:any):any;
	getTouches(target:any, phase?:any, out?:any):any;
	getTouch(target:any, phase?:any, id?:any):any;
	interactsWith(target:any):any;
	dispatch(chain:any):any;
	timestamp:any;
	get_timestamp():any;
	touches:any;
	get_touches():any;
	shiftKey:any;
	get_shiftKey():any;
	ctrlKey:any;
	get_ctrlKey():any;
	static TOUCH:any;
	static sTouches:any;


}

}

export default starling.events.TouchEvent;
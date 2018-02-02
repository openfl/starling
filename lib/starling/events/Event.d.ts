import starling_utils_StringUtil from "./../../starling/utils/StringUtil";
import Type from "./../../Type";
import openfl_Vector from "openfl/Vector";

declare namespace starling.events {

export class Event {

	constructor(type:any, bubbles?:any, data?:any);
	stopPropagation():any;
	stopImmediatePropagation():any;
	toString():any;
	bubbles:any;
	target:any;
	currentTarget:any;
	type:any;
	
	setTarget(value:any):any;
	setCurrentTarget(value:any):any;
	setData(value:any):any;
	stopsPropagation:any;
	stopsImmediatePropagation:any;
	reset(type:any, bubbles?:any, data?:any):any;
	static ADDED:any;
	static ADDED_TO_STAGE:any;
	static ENTER_FRAME:any;
	static REMOVED:any;
	static REMOVED_FROM_STAGE:any;
	static TRIGGERED:any;
	static RESIZE:any;
	static COMPLETE:any;
	static CONTEXT3D_CREATE:any;
	static RENDER:any;
	static ROOT_CREATED:any;
	static REMOVE_FROM_JUGGLER:any;
	static TEXTURES_RESTORED:any;
	static IO_ERROR:any;
	static SECURITY_ERROR:any;
	static PARSE_ERROR:any;
	static FATAL_ERROR:any;
	static CHANGE:any;
	static CANCEL:any;
	static SCROLL:any;
	static OPEN:any;
	static CLOSE:any;
	static SELECT:any;
	static READY:any;
	static UPDATE:any;
	static sEventPool:any;
	static fromPool(type:any, bubbles?:any, data?:any):any;
	static toPool(event:any):any;


}

}

export default starling.events.Event;
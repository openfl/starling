import starling_events_Event from "./../../starling/events/Event";

declare namespace starling.events {

export class KeyboardEvent extends starling_events_Event {

	constructor(type:any, charCode?:any, keyCode?:any, keyLocation?:any, ctrlKey?:any, altKey?:any, shiftKey?:any);
	__charCode:any;
	__keyCode:any;
	__keyLocation:any;
	__altKey:any;
	__ctrlKey:any;
	__shiftKey:any;
	__isDefaultPrevented:any;
	preventDefault():any;
	isDefaultPrevented():any;
	charCode:any;
	get_charCode():any;
	keyCode:any;
	get_keyCode():any;
	keyLocation:any;
	get_keyLocation():any;
	altKey:any;
	get_altKey():any;
	ctrlKey:any;
	get_ctrlKey():any;
	shiftKey:any;
	get_shiftKey():any;
	static KEY_UP:any;
	static KEY_DOWN:any;


}

}

export default starling.events.KeyboardEvent;
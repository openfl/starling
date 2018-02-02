import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";

declare namespace starling.utils {

export class Padding extends starling_events_EventDispatcher {

	constructor(left?:any, right?:any, top?:any, bottom?:any);
	_left:any;
	_right:any;
	_top:any;
	_bottom:any;
	setTo(left?:any, right?:any, top?:any, bottom?:any):any;
	setToUniform(value:any):any;
	setToSymmetric(horizontal:any, vertical:any):any;
	copyFrom(padding:any):any;
	clone():any;
	left:any;
	get_left():any;
	set_left(value:any):any;
	right:any;
	get_right():any;
	set_right(value:any):any;
	top:any;
	get_top():any;
	set_top(value:any):any;
	bottom:any;
	get_bottom():any;
	set_bottom(value:any):any;


}

}

export default starling.utils.Padding;
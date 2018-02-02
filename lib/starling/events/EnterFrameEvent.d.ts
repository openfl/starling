import starling_events_Event from "./../../starling/events/Event";

declare namespace starling.events {

export class EnterFrameEvent extends starling_events_Event {

	constructor(type:any, passedTime:any, bubbles?:any);
	passedTime:any;
	get_passedTime():any;
	static ENTER_FRAME:any;


}

}

export default starling.events.EnterFrameEvent;
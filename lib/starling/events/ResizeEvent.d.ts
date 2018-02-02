import starling_events_Event from "./../../starling/events/Event";
import Std from "./../../Std";
import js_Boot from "./../../js/Boot";
import openfl_geom_Point from "openfl/geom/Point";

declare namespace starling.events {

export class ResizeEvent extends starling_events_Event {

	constructor(type:any, width:any, height:any, bubbles?:any);
	width:any;
	get_width():any;
	height:any;
	get_height():any;
	static RESIZE:any;


}

}

export default starling.events.ResizeEvent;
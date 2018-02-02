import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";
import openfl_Vector from "openfl/Vector";
import Reflect from "./../../Reflect";
import Std from "./../../Std";
import starling_display_DisplayObject from "./../../starling/display/DisplayObject";
import js_Boot from "./../../js/Boot";
import starling_events_Event from "./../../starling/events/Event";

declare namespace starling.events {

export class EventDispatcher {

	constructor();
	__eventListeners:any;
	__eventStack:any;
	addEventListener(type:any, listener:any):any;
	removeEventListener(type:any, listener:any):any;
	removeEventListeners(type?:any):any;
	dispatchEvent(event:any):any;
	__invokeEvent(event:any):any;
	__bubbleEvent(event:any):any;
	dispatchEventWith(type:any, bubbles?:any, data?:any):any;
	hasEventListener(type:any, listener?:any):any;
	static sBubbleChains:any;


}

}

export default starling.events.EventDispatcher;
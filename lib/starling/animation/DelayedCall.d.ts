import starling_animation_IAnimatable from "./../../starling/animation/IAnimatable";
import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import Reflect from "./../../Reflect";
import openfl_Vector from "openfl/Vector";

declare namespace starling.animation {

export class DelayedCall extends starling_events_EventDispatcher {

	constructor(callback:any, delay:any, args?:any);
	__currentTime:any;
	__totalTime:any;
	__callback:any;
	__args:any;
	__repeatCount:any;
	reset(callback:any, delay:any, args?:any):any;
	advanceTime(time:any):any;
	complete():any;
	isComplete:any;
	get_isComplete():any;
	totalTime:any;
	get_totalTime():any;
	currentTime:any;
	get_currentTime():any;
	repeatCount:any;
	get_repeatCount():any;
	set_repeatCount(value:any):any;
	callback:any;
	get_callback():any;
	arguments:any;
	get_arguments():any;
	static sPool:any;
	static fromPool(call:any, delay:any, args?:any):any;
	static toPool(delayedCall:any):any;


}

}

export default starling.animation.DelayedCall;
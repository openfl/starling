import haxe_ds_StringMap from "./../../haxe/ds/StringMap";

declare namespace starling.animation {

export class Transitions {

	static LINEAR:any;
	static EASE_IN:any;
	static EASE_OUT:any;
	static EASE_IN_OUT:any;
	static EASE_OUT_IN:any;
	static EASE_IN_BACK:any;
	static EASE_OUT_BACK:any;
	static EASE_IN_OUT_BACK:any;
	static EASE_OUT_IN_BACK:any;
	static EASE_IN_ELASTIC:any;
	static EASE_OUT_ELASTIC:any;
	static EASE_IN_OUT_ELASTIC:any;
	static EASE_OUT_IN_ELASTIC:any;
	static EASE_IN_BOUNCE:any;
	static EASE_OUT_BOUNCE:any;
	static EASE_IN_OUT_BOUNCE:any;
	static EASE_OUT_IN_BOUNCE:any;
	static sTransitions:any;
	static getTransition(name:any):any;
	static register(name:any, func:any):any;
	static registerDefaults():any;
	static linear(ratio:any):any;
	static easeIn(ratio:any):any;
	static easeOut(ratio:any):any;
	static easeInOut(ratio:any):any;
	static easeOutIn(ratio:any):any;
	static easeInBack(ratio:any):any;
	static easeOutBack(ratio:any):any;
	static easeInOutBack(ratio:any):any;
	static easeOutInBack(ratio:any):any;
	static easeInElastic(ratio:any):any;
	static easeOutElastic(ratio:any):any;
	static easeInOutElastic(ratio:any):any;
	static easeOutInElastic(ratio:any):any;
	static easeInBounce(ratio:any):any;
	static easeOutBounce(ratio:any):any;
	static easeInOutBounce(ratio:any):any;
	static easeOutInBounce(ratio:any):any;
	static easeCombined(startFunc:any, endFunc:any, ratio:any):any;


}

}

export default starling.animation.Transitions;
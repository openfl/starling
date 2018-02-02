import starling_animation_IAnimatable from "./../../starling/animation/IAnimatable";
import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import Reflect from "./../../Reflect";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_Vector from "openfl/Vector";
import haxe_Log from "./../../haxe/Log";
import starling_utils_Color from "./../../starling/utils/Color";
import Std from "./../../Std";
import starling_animation_Transitions from "./../../starling/animation/Transitions";
import HxOverrides from "./../../HxOverrides";

declare namespace starling.animation {

export class Tween extends starling_events_EventDispatcher {

	constructor(target:any, time:any, transition?:any);
	
	__transitionFunc(a1:any):any;
	__transitionName:any;
	__properties:any;
	__startValues:any;
	__endValues:any;
	__updateFuncs:any;
	__onStart:any;
	__onUpdate:any;
	__onRepeat:any;
	__onComplete:any;
	__onStartArgs:any;
	__onUpdateArgs:any;
	__onRepeatArgs:any;
	__onCompleteArgs:any;
	__totalTime:any;
	__currentTime:any;
	__progress:any;
	__delay:any;
	__roundToInt:any;
	__nextTween:any;
	__repeatCount:any;
	__repeatDelay:any;
	__reverse:any;
	__currentCycle:any;
	reset(target:any, time:any, transition?:any):any;
	animate(property:any, endValue:any):any;
	scaleTo(factor:any):any;
	moveTo(x:any, y:any):any;
	fadeTo(alpha:any):any;
	rotateTo(angle:any, type?:any):any;
	advanceTime(time:any):any;
	getUpdateFuncFromProperty(property:any):any;
	updateStandard(property:any, startValue:any, endValue:any):any;
	updateRgb(property:any, startValue:any, endValue:any):any;
	updateRad(property:any, startValue:any, endValue:any):any;
	updateDeg(property:any, startValue:any, endValue:any):any;
	updateAngle(pi:any, property:any, startValue:any, endValue:any):any;
	getEndValue(property:any):any;
	animatesProperty(property:any):any;
	isComplete:any;
	get_isComplete():any;
	
	get_target():any;
	transition:any;
	get_transition():any;
	set_transition(value:any):any;
	transitionFunc(a1:any):any;
	get_transitionFunc():any;
	set_transitionFunc(value:any):any;
	totalTime:any;
	get_totalTime():any;
	currentTime:any;
	get_currentTime():any;
	progress:any;
	get_progress():any;
	delay:any;
	get_delay():any;
	set_delay(value:any):any;
	repeatCount:any;
	get_repeatCount():any;
	set_repeatCount(value:any):any;
	repeatDelay:any;
	get_repeatDelay():any;
	set_repeatDelay(value:any):any;
	reverse:any;
	get_reverse():any;
	set_reverse(value:any):any;
	roundToInt:any;
	get_roundToInt():any;
	set_roundToInt(value:any):any;
	onStart:any;
	get_onStart():any;
	set_onStart(value:any):any;
	onUpdate:any;
	get_onUpdate():any;
	set_onUpdate(value:any):any;
	onRepeat:any;
	get_onRepeat():any;
	set_onRepeat(value:any):any;
	onComplete:any;
	get_onComplete():any;
	set_onComplete(value:any):any;
	onStartArgs:any;
	get_onStartArgs():any;
	set_onStartArgs(value:any):any;
	onUpdateArgs:any;
	get_onUpdateArgs():any;
	set_onUpdateArgs(value:any):any;
	onRepeatArgs:any;
	get_onRepeatArgs():any;
	set_onRepeatArgs(value:any):any;
	onCompleteArgs:any;
	get_onCompleteArgs():any;
	set_onCompleteArgs(value:any):any;
	nextTween:any;
	get_nextTween():any;
	set_nextTween(value:any):any;
	static HINT_MARKER:any;
	static getPropertyHint(property:any):any;
	static getPropertyName(property:any):any;
	static sTweenPool:any;
	static fromPool(target:any, time:any, transition?:any):any;
	static toPool(tween:any):any;


}

}

export default starling.animation.Tween;
import starling_animation_IAnimatable from "./../../starling/animation/IAnimatable";
import Std from "./../../Std";
import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import starling_animation_Tween from "./../../starling/animation/Tween";
import starling_animation_DelayedCall from "./../../starling/animation/DelayedCall";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import js_Boot from "./../../js/Boot";
import Type from "./../../Type";
import Reflect from "./../../Reflect";
import openfl_Vector from "openfl/Vector";
import haxe_ds_ObjectMap from "./../../haxe/ds/ObjectMap";

declare namespace starling.animation {

export class Juggler {

	constructor();
	__objects:any;
	__objectIDs:any;
	__elapsedTime:any;
	__timeScale:any;
	add(object:any):any;
	addWithID(object:any, objectID:any):any;
	contains(object:any):any;
	remove(object:any):any;
	removeByID(objectID:any):any;
	removeTweens(target:any):any;
	removeDelayedCalls(callback:any):any;
	containsTweens(target:any):any;
	containsDelayedCalls(callback:any):any;
	purge():any;
	delayCall(call:any, delay:any, args?:any):any;
	repeatCall(call:any, interval:any, repeatCount?:any, args?:any):any;
	onPooledDelayedCallComplete(event:any):any;
	tween(target:any, time:any, properties:any):any;
	onPooledTweenComplete(event:any):any;
	advanceTime(time:any):any;
	onRemove(event:any):any;
	elapsedTime:any;
	get_elapsedTime():any;
	timeScale:any;
	get_timeScale():any;
	set_timeScale(value:any):any;
	objects:any;
	get_objects():any;
	static sCurrentObjectID:any;
	static sTweenInstanceFields:any;
	static getNextID():any;


}

}

export default starling.animation.Juggler;
package starling.animation;

import starling.animation.IAnimatable;
import Std;
import starling.events.EventDispatcher;
import starling.animation.Tween;
import starling.animation.DelayedCall;
import js.Boot;
import Type;
import Reflect;
import haxe.ds.ObjectMap;

@:jsRequire("starling/animation/Juggler", "default")

extern class Juggler implements Dynamic {

	function new();
	var __objects:Dynamic;
	var __objectIDs:Dynamic;
	var __elapsedTime:Dynamic;
	var __timeScale:Dynamic;
	function add(object:Dynamic):Dynamic;
	function addWithID(object:Dynamic, objectID:Dynamic):Dynamic;
	function contains(object:Dynamic):Dynamic;
	function remove(object:Dynamic):Dynamic;
	function removeByID(objectID:Dynamic):Dynamic;
	function removeTweens(target:Dynamic):Dynamic;
	function removeDelayedCalls(callback:Dynamic):Dynamic;
	function containsTweens(target:Dynamic):Dynamic;
	function containsDelayedCalls(callback:Dynamic):Dynamic;
	function purge():Dynamic;
	function delayCall(call:Dynamic, delay:Dynamic, ?args:Dynamic):Dynamic;
	function repeatCall(call:Dynamic, interval:Dynamic, ?repeatCount:Dynamic, ?args:Dynamic):Dynamic;
	function onPooledDelayedCallComplete(event:Dynamic):Dynamic;
	function tween(target:Dynamic, time:Dynamic, properties:Dynamic):Dynamic;
	function onPooledTweenComplete(event:Dynamic):Dynamic;
	function advanceTime(time:Dynamic):Dynamic;
	function onRemove(event:Dynamic):Dynamic;
	var elapsedTime:Dynamic;
	function get_elapsedTime():Dynamic;
	var timeScale:Dynamic;
	function get_timeScale():Dynamic;
	function set_timeScale(value:Dynamic):Dynamic;
	var objects:Dynamic;
	function get_objects():Dynamic;
	static var sCurrentObjectID:Dynamic;
	static var sTweenInstanceFields:Dynamic;
	static function getNextID():Dynamic;


}
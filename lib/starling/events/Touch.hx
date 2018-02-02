package starling.events;

import starling.utils.StringUtil;

@:jsRequire("starling/events/Touch", "default")

extern class Touch {
	var cancelled(get,set) : Bool;
	var globalX(get,set) : Float;
	var globalY(get,set) : Float;
	var height(get,set) : Float;
	var id(get,never) : Int;
	var phase(get,set) : String;
	var pressure(get,set) : Float;
	var previousGlobalX(get,never) : Float;
	var previousGlobalY(get,never) : Float;
	var tapCount(get,set) : Int;
	var target(get,set) : starling.display.DisplayObject;
	var timestamp(get,set) : Float;
	var width(get,set) : Float;
	function new(id : Int) : Void;
	function clone() : Touch;
	function getLocation(space : starling.display.DisplayObject, ?out : openfl.geom.Point) : openfl.geom.Point;
	function getMovement(space : starling.display.DisplayObject, ?out : openfl.geom.Point) : openfl.geom.Point;
	function getPreviousLocation(space : starling.display.DisplayObject, ?out : openfl.geom.Point) : openfl.geom.Point;
	function isTouching(target : starling.display.DisplayObject) : Bool;
	function toString() : String;
}

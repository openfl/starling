package starling.animation;


import haxe.Constraints.Function;
import openfl.Vector;

@:jsRequire("starling/animation/Juggler", "default")


extern class Juggler implements IAnimatable {
	
	
	public var elapsedTime (get, never):Float;
	public var objects (get, never):Vector<IAnimatable>;
	public var timeScale (get, set):Float;
	
	public function new ();
	public function add (object:IAnimatable):UInt;
	public function addWithID (object:IAnimatable, objectID:UInt):UInt;
	public function contains (object:IAnimatable):Bool;
	public function remove (object:IAnimatable):UInt;
	public function removeByID (objectID:UInt):UInt;
	public function removeTweens(target:Dynamic):Void;
	public function removeDelayedCalls (callback:Function):Void;
	public function containsTweens (target:Dynamic):Bool;
	public function containsDelayedCalls (callback:Function):Bool;
	public function purge ():Void;
	public function delayCall (call:Function, delay:Float, args:Array<Dynamic> = null):UInt;
	public function repeatCall (call:Function, interval:Float, repeatCount:Int = 0, args:Array<Dynamic> = null):UInt;
	public function tween (target:Dynamic, time:Float, properties:Dynamic):UInt;
	public function advanceTime (time:Float):Void;
	
	
}
package starling.animation;


import haxe.Constraints.Function;
import starling.events.EventDispatcher;

@:jsRequire("starling/animation/DelayedCall", "default")


extern class DelayedCall extends EventDispatcher implements IAnimatable {
	
	
	public var arguments (get, never):Array<Dynamic>;
	public var callback (get, never):Function;
	public var currentTime (get, never):Float;
	public var isComplete (get, never):Bool;
	public var repeatCount (get, set):Int;
	public var totalTime (get, never):Float;
	
	public function new (callback:Function, delay:Float, args:Array<Dynamic> = null);
	public function reset (callback:Function, delay:Float, args:Array<Dynamic> = null):DelayedCall;
	public function advanceTime (time:Float):Void;
	public function complete ():Void;
	
	
}
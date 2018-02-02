package starling.animation;


import haxe.Constraints.Function;
import starling.events.EventDispatcher;

@:jsRequire("starling/animation/Tween", "default")


extern class Tween extends EventDispatcher implements IAnimatable {
	
	
	public var isComplete (get, never):Bool;
	public var target (get, never):Dynamic;
	public var transition (get, set):String;
	public var transitionFunc (get, set):Float->Float;
	public var totalTime (get, never):Float;
	public var currentTime (get, never):Float;
	public var progress (get, never):Float;
	public var delay (get, set):Float;
	public var repeatCount (get, set):Int;
	public var repeatDelay (get, set):Float;
	public var reverse (get, set):Bool;
	public var roundToInt (get, set):Bool;
	public var onStart (get, set):Function;
	public var onUpdate (get, set):Function;
	public var onRepeat (get, set):Function;
	public var onComplete (get, set):Function;
	public var onStartArgs (get, set):Array<Dynamic>;
	public var onUpdateArgs (get, set):Array<Dynamic>;
	public var onRepeatArgs (get, set):Array<Dynamic>;
	public var onCompleteArgs (get, set):Array<Dynamic>;
	public var nextTween (get, set):Tween;
	
	public function new (target:Dynamic, time:Float, transition:Dynamic = "linear");
	public function reset (target:Dynamic, time:Float, transition:Dynamic = "linear"):Tween;
	public function animate (property:String, endValue:Float):Void;
	public function scaleTo (factor:Float):Void;
	public function moveTo (x:Float, y:Float):Void;
	public function fadeTo (alpha:Float):Void;
	public function rotateTo (angle:Float, type:String = "rad"):Void;
	public function advanceTime (time:Float):Void;
	public function getEndValue (property:String):Float;
	public function animatesProperty (property:String):Bool;
	
	
}
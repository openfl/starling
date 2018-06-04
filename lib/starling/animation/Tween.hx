// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================


package starling.animation;

import haxe.Constraints.Function;

import openfl.errors.ArgumentError;
import openfl.Vector;

import starling.events.Event;
import starling.events.EventDispatcher;
import starling.utils.Color;

/** A Tween animates numeric properties of objects. It uses different transition functions
 *  to give the animations various styles.
 *  
 *  <p>The primary use of this class is to do standard animations like movement, fading, 
 *  rotation, etc. But there are no limits on what to animate; as long as the property you want
 *  to animate is numeric (<code>int, uint, Number</code>), the tween can handle it. For a list 
 *  of available Transition types, look at the "Transitions" class.</p> 
 *  
 *  <p>Here is an example of a tween that moves an object to the right, rotates it, and 
 *  fades it out:</p>
 *  
 *  <listing>
 *  var tween:Tween = new Tween(object, 2.0, Transitions.EASE_IN_OUT);
 *  tween.animate("x", object.x + 50);
 *  tween.animate("rotation", deg2rad(45));
 *  tween.fadeTo(0);    // equivalent to 'animate("alpha", 0)'
 *  Starling.juggler.add(tween);</listing> 
 *  
 *  <p>Note that the object is added to a juggler at the end of this sample. That's because a 
 *  tween will only be executed if its "advanceTime" method is executed regularly - the 
 *  juggler will do that for you, and will remove the tween when it is finished.</p>
 *  
 *  @see Juggler
 *  @see Transitions
 */ 

@:jsRequire("starling/animation/Tween", "default")

extern class Tween extends EventDispatcher implements IAnimatable
{
    /** Creates a tween with a target, duration (in seconds) and a transition function.
     * @param target the object that you want to animate
     * @param time the duration of the Tween (in seconds)
     * @param transition can be either a String (e.g. one of the constants defined in the
     *        Transitions class) or a function. Look up the 'Transitions' class for a   
     *        documentation about the required function signature. */ 
    public function new(target:Dynamic, time:Float, transition:Dynamic="linear");

    /** Resets the tween to its default values. Useful for pooling tweens. */
    public function reset(target:Dynamic, time:Float, transition:Dynamic="linear"):Tween;
    
    /** Animates the property of the target to a certain value. You can call this method
     * multiple times on one tween.
     *
     * <p>Some property types are handled in a special way:</p>
     * <ul>
     *   <li>If the property contains the string <code>color</code> or <code>Color</code>,
     *       it will be treated as an unsigned integer with a color value
     *       (e.g. <code>0xff0000</code> for red). Each color channel will be animated
     *       individually.</li>
     *   <li>The same happens if you append the string <code>#rgb</code> to the name.</li>
     *   <li>If you append <code>#rad</code>, the property is treated as an angle in radians,
     *       making sure it always uses the shortest possible arc for the rotation.</li>
     *   <li>The string <code>#deg</code> does the same for angles in degrees.</li>
     * </ul>
     */
    public function animate(property:String, endValue:Float):Void;

    /** Animates the 'scaleX' and 'scaleY' properties of an object simultaneously. */
    public function scaleTo(factor:Float):Void;
    
    /** Animates the 'x' and 'y' properties of an object simultaneously. */
    public function moveTo(x:Float, y:Float):Void;
    
    /** Animates the 'alpha' property of an object to a certain target value. */ 
    public function fadeTo(alpha:Float):Void;

    /** Animates the 'rotation' property of an object to a certain target value, using the
     * smallest possible arc. 'type' may be either 'rad' or 'deg', depending on the unit of
     * measurement. */
    public function rotateTo(angle:Float, type:String="rad"):Void;
    
    /** @inheritDoc */
    public function advanceTime(time:Float):Void;
    
    /** The end value a certain property is animated to. Throws an ArgumentError if the 
     * property is not being animated. */
    public function getEndValue(property:String):Float;

    /** Indicates if a property with the given name is being animated by this tween. */
    public function animatesProperty(property:String):Bool;
    
    /** Indicates if the tween is finished. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool;
    
    /** The target object that is animated. */
    public var target(get, never):Dynamic;
    private function get_target():Dynamic;
    
    /** The transition method used for the animation. @see Transitions */
    public var transition(get, set):String;
    private function get_transition():String;
    private function set_transition(value:String):String;
    
    /** The actual transition function used for the animation. */
    public var transitionFunc(get, set):Float->Float;
    private function get_transitionFunc():Float->Float;
    private function set_transitionFunc(value:Float->Float):Float->Float;
    
    /** The total time the tween will take per repetition (in seconds). */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float;
    
    /** The time that has passed since the tween was created (in seconds). */
    public var currentTime(get, never):Float;
    private function get_currentTime():Float;
    
    /** The current progress between 0 and 1, as calculated by the transition function. */
    public var progress(get, never):Float;
    private function get_progress():Float;
    
    /** The delay before the tween is started (in seconds). @default 0 */
    public var delay(get, set):Float;
    private function get_delay():Float;
    private function set_delay(value:Float):Float;
    
    /** The number of times the tween will be executed. 
     * Set to '0' to tween indefinitely. @default 1 */
    public var repeatCount(get, set):Int;
    private function get_repeatCount():Int;
    private function set_repeatCount(value:Int):Int;
    
    /** The amount of time to wait between repeat cycles (in seconds). @default 0 */
    public var repeatDelay(get, set):Float;
    private function get_repeatDelay():Float;
    private function set_repeatDelay(value:Float):Float;
    
    /** Indicates if the tween should be reversed when it is repeating. If enabled, 
     * every second repetition will be reversed. @default false */
    public var reverse(get, set):Bool;
    private function get_reverse():Bool;
    private function set_reverse(value:Bool):Bool;
    
    /** Indicates if the numeric values should be cast to Integers. @default false */
    public var roundToInt(get, set):Bool;
    private function get_roundToInt():Bool;
    private function set_roundToInt(value:Bool):Bool;
    
    /** A function that will be called when the tween starts (after a possible delay). */
    public var onStart(get, set):Function;
    private function get_onStart():Function;
    private function set_onStart(value:Function):Function;
    
    /** A function that will be called each time the tween is advanced. */
    public var onUpdate(get, set):Function;
    private function get_onUpdate():Function;
    private function set_onUpdate(value:Function):Function;
    
    /** A function that will be called each time the tween finishes one repetition
     * (except the last, which will trigger 'onComplete'). */
    public var onRepeat(get, set):Function;
    private function get_onRepeat():Function;
    private function set_onRepeat(value:Function):Function;
    
    /** A function that will be called when the tween is complete. */
    public var onComplete(get, set):Function;
    private function get_onComplete():Function;
    private function set_onComplete(value:Function):Function;
    
    /** The arguments that will be passed to the 'onStart' function. */
    public var onStartArgs(get, set):Array<Dynamic>;
    private function get_onStartArgs():Array<Dynamic>;
    private function set_onStartArgs(value:Array<Dynamic>):Array<Dynamic>;
    
    /** The arguments that will be passed to the 'onUpdate' function. */
    public var onUpdateArgs(get, set):Array<Dynamic>;
    private function get_onUpdateArgs():Array<Dynamic>;
    private function set_onUpdateArgs(value:Array<Dynamic>):Array<Dynamic>;
    
    /** The arguments that will be passed to the 'onRepeat' function. */
    public var onRepeatArgs(get, set):Array<Dynamic>;
    private function get_onRepeatArgs():Array<Dynamic>;
    private function set_onRepeatArgs(value:Array<Dynamic>):Array<Dynamic>;
    
    /** The arguments that will be passed to the 'onComplete' function. */
    public var onCompleteArgs(get, set):Array<Dynamic>;
    private function get_onCompleteArgs():Array<Dynamic>;
    private function set_onCompleteArgs(value:Array<Dynamic>):Array<Dynamic>;
    
    /** Another tween that will be started (i.e. added to the same juggler) as soon as 
     * this tween is completed. */
    public var nextTween(get, set):Tween;
    private function get_nextTween():Tween;
    private function set_nextTween(value:Tween):Tween;
}
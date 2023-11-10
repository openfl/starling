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
@:keep class Tween extends EventDispatcher implements IAnimatable
{
    private static inline var HINT_MARKER:String = '#';

    private var __target:Dynamic;
    private var __transitionFunc:Float->Float;
    private var __transitionName:String;
    
    private var __properties:Vector<String>;
    private var __startValues:Vector<Float>;
    private var __endValues:Vector<Float>;
    private var __updateFuncs:Vector<String->Float->Float->Void>;

    private var __onStart:Function;
    private var __onUpdate:Function;
    private var __onRepeat:Function;
    private var __onComplete:Function;  
    
    private var __onStartArgs:Array<Dynamic>;
    private var __onUpdateArgs:Array<Dynamic>;
    private var __onRepeatArgs:Array<Dynamic>;
    private var __onCompleteArgs:Array<Dynamic>;
    
    private var __totalTime:Float;
    private var __currentTime:Float;
    private var __progress:Float;
    private var __delay:Float;
    private var __roundToInt:Bool;
    private var __nextTween:Tween;
    private var __repeatCount:Int;
    private var __repeatDelay:Float;
    private var __reverse:Bool;
    private var __currentCycle:Int;
    
    #if commonjs
	private static function __init__ () {
		
		untyped Object.defineProperties (Tween.prototype, {
			"isComplete": { get: untyped __js__ ("function () { return this.get_isComplete (); }") },
			"target": { get: untyped __js__ ("function () { return this.get_target (); }") },
			"transition": { get: untyped __js__ ("function () { return this.get_transition (); }"), set: untyped __js__ ("function (v) { return this.set_transition (v); }") },
			"transitionFunc": { get: untyped __js__ ("function () { return this.get_transitionFunc (); }"), set: untyped __js__ ("function (v) { return this.set_transitionFunc (v); }") },
            "totalTime": { get: untyped __js__ ("function () { return this.get_totalTime (); }") },
            "currentTime": { get: untyped __js__ ("function () { return this.get_currentTime (); }") },
			"progress": { get: untyped __js__ ("function () { return this.get_progress (); }") },
			"delay": { get: untyped __js__ ("function () { return this.get_delay (); }"), set: untyped __js__ ("function (v) { return this.set_delay (v); }") },
			"repeatCount": { get: untyped __js__ ("function () { return this.get_repeatCount (); }"), set: untyped __js__ ("function (v) { return this.set_repeatCount (v); }") },
			"repeatDelay": { get: untyped __js__ ("function () { return this.get_repeatDelay (); }"), set: untyped __js__ ("function (v) { return this.set_repeatDelay (v); }") },
			"reverse": { get: untyped __js__ ("function () { return this.get_reverse (); }"), set: untyped __js__ ("function (v) { return this.set_reverse (v); }") },
			"roundToInt": { get: untyped __js__ ("function () { return this.get_roundToInt (); }"), set: untyped __js__ ("function (v) { return this.set_roundToInt (v); }") },
			"onStart": { get: untyped __js__ ("function () { return this.get_onStart (); }"), set: untyped __js__ ("function (v) { return this.set_onStart (v); }") },
			"onUpdate": { get: untyped __js__ ("function () { return this.get_onUpdate (); }"), set: untyped __js__ ("function (v) { return this.set_onUpdate (v); }") },
			"onRepeat": { get: untyped __js__ ("function () { return this.get_onRepeat (); }"), set: untyped __js__ ("function (v) { return this.set_onRepeat (v); }") },
			"onComplete": { get: untyped __js__ ("function () { return this.get_onComplete (); }"), set: untyped __js__ ("function (v) { return this.set_onComplete (v); }") },
			"onStartArgs": { get: untyped __js__ ("function () { return this.get_onStartArgs (); }"), set: untyped __js__ ("function (v) { return this.set_onStartArgs (v); }") },
			"onUpdateArgs": { get: untyped __js__ ("function () { return this.get_onUpdateArgs (); }"), set: untyped __js__ ("function (v) { return this.set_onUpdateArgs (v); }") },
			"onRepeatArgs": { get: untyped __js__ ("function () { return this.get_onRepeatArgs (); }"), set: untyped __js__ ("function (v) { return this.set_onRepeatArgs (v); }") },
			"onCompleteArgs": { get: untyped __js__ ("function () { return this.get_onCompleteArgs (); }"), set: untyped __js__ ("function (v) { return this.set_onCompleteArgs (v); }") },
			"nextTween": { get: untyped __js__ ("function () { return this.get_nextTween (); }"), set: untyped __js__ ("function (v) { return this.set_nextTween (v); }") },
		});
		
	}
	#end
    
    /** Creates a tween with a target, duration (in seconds) and a transition function.
     * @param target the object that you want to animate
     * @param time the duration of the Tween (in seconds)
     * @param transition can be either a String (e.g. one of the constants defined in the
     *        Transitions class) or a function. Look up the 'Transitions' class for a   
     *        documentation about the required function signature. */ 
    public function new(target:Dynamic, time:Float, transition:Dynamic="linear")        
    {
         super();
         reset(target, time, transition);
    }

    /** Resets the tween to its default values. Useful for pooling tweens. */
    public function reset(target:Dynamic, time:Float, transition:Dynamic="linear"):Tween
    {
        __target = target;
        __currentTime = 0.0;
        __totalTime = Math.max(0.0001, time);
        __progress = 0.0;
        __delay = __repeatDelay = 0.0;
        __onStart = __onUpdate = __onRepeat = __onComplete = null;
        __onStartArgs = __onUpdateArgs = __onRepeatArgs = __onCompleteArgs = null;
        __roundToInt = __reverse = false;
        __repeatCount = 1;
        __currentCycle = -1;
        __nextTween = null;
        
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(transition, String))
            this.transition = cast transition;
        else if (Reflect.isFunction(transition))
            this.transitionFunc = transition;
        else 
            throw new ArgumentError("Transition must be either a string or a function");
        
        if (__properties != null)  __properties.length  = 0; else __properties  = new Vector<String>();
        if (__startValues != null) __startValues.length = 0; else __startValues = new Vector<Float>();
        if (__endValues != null)   __endValues.length   = 0; else __endValues   = new Vector<Float>();
        if (__updateFuncs != null) __updateFuncs.length = 0; else __updateFuncs = new Vector<String->Float->Float->Void>();
        
        return this;
    }
    
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
    public function animate(property:String, endValue:Float):Void
    {
        if (__target == null) return; // tweening null just does nothing.

        var pos:Int = __properties.length;
        var updateFunc:String->Float->Float->Void = getUpdateFuncFromProperty(property);

        __properties[pos] = getPropertyName(property);
        __startValues[pos] = Math.NaN;
        __endValues[pos] = endValue;
        __updateFuncs[pos] = updateFunc;
    }

    /** Animates the 'scaleX' and 'scaleY' properties of an object simultaneously. */
    public function scaleTo(factor:Float):Void
    {
        animate("scaleX", factor);
        animate("scaleY", factor);
    }
    
    /** Animates the 'x' and 'y' properties of an object simultaneously. */
    public function moveTo(x:Float, y:Float):Void
    {
        animate("x", x);
        animate("y", y);
    }
    
    /** Animates the 'alpha' property of an object to a certain target value. */ 
    public function fadeTo(alpha:Float):Void
    {
        animate("alpha", alpha);
    }

    /** Animates the 'rotation' property of an object to a certain target value, using the
     * smallest possible arc. 'type' may be either 'rad' or 'deg', depending on the unit of
     * measurement. */
    public function rotateTo(angle:Float, type:String="rad"):Void
    {
        animate("rotation#" + type, angle);
    }
    
    /** @inheritDoc */
    public function advanceTime(time:Float):Void
    {
        if (time == 0 || (__repeatCount == 1 && __currentTime == __totalTime)) return;
        
        var i:Int;
        var previousTime:Float = __currentTime;
        var restTime:Float = __totalTime - __currentTime;
        var carryOverTime:Float = time > restTime ? time - restTime : 0.0;
        
        __currentTime += time;
        
        if (__currentTime <= 0) 
            return; // the delay is not over yet
        else if (__currentTime > __totalTime) 
            __currentTime = __totalTime;
        
        if (__currentCycle < 0 && previousTime <= 0 && __currentTime > 0)
        {
            __currentCycle++;
            if (__onStart != null)
            {
                if (__onStartArgs != null) {
                    Reflect.callMethod(__onStart, __onStart, __onStartArgs);
                } else {
                    __onStart();
                }
            }
        }

        var ratio:Float = __currentTime / __totalTime;
        var reversed:Bool = __reverse && (__currentCycle % 2 == 1);
        var numProperties:Int = __startValues.length;
        __progress = reversed ? __transitionFunc(1.0 - ratio) : __transitionFunc(ratio);

        for (i in 0...numProperties)
        {                
            if (__startValues[i] != __startValues[i]) // isNaN check - "isNaN" causes allocation! 
                __startValues[i] = Reflect.getProperty(__target, __properties[i]);

            var updateFunc:String->Float->Float->Void = __updateFuncs[i];
            updateFunc(__properties[i], __startValues[i], __endValues[i]);
        }

        if (__onUpdate != null)
        {
            if (__onUpdateArgs != null) {
                Reflect.callMethod(__onUpdate, __onUpdate, __onUpdateArgs);
            } else {
                __onUpdate();
            }
        }
        
        if (previousTime < __totalTime && __currentTime >= __totalTime)
        {
            if (__repeatCount == 0 || __repeatCount > 1)
            {
                __currentTime = -__repeatDelay;
                __currentCycle++;
                if (__repeatCount > 1) __repeatCount--;
                if (__onRepeat != null)
                {
                    if (__onRepeatArgs != null) {
                        Reflect.callMethod(__onRepeat, __onRepeat, __onRepeatArgs);
                    } else {
                        __onRepeat();
                    }
                }
            }
            else
            {
                // save callback & args: they might be changed through an event listener
                var onComplete:Function = __onComplete;
                var onCompleteArgs:Array<Dynamic> = __onCompleteArgs;
                
                // in the 'onComplete' callback, people might want to call "tween.reset" and
                // add it to another juggler; so this event has to be dispatched *before*
                // executing 'onComplete'.
                dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
                if (onComplete != null)
                {
                    if (onCompleteArgs != null) {
                        Reflect.callMethod(onComplete, onComplete, onCompleteArgs);
                    } else {
                        onComplete();
                    }
                }
                if (__currentTime == 0) carryOverTime = 0; // tween was reset
            }
        }
        
        if (carryOverTime != 0) 
            advanceTime(carryOverTime);
    }

    // animation hints

    private function getUpdateFuncFromProperty(property:String):String->Float->Float->Void
    {
        var updateFunc:String->Float->Float->Void;
        var hint:String = getPropertyHint(property);

        switch (hint)
        {
            case null:  updateFunc = updateStandard;
            case "rgb": updateFunc = updateRgb;
            case "rad": updateFunc = updateRad;
            case "deg": updateFunc = updateDeg;
            default:
                trace("[Starling] Ignoring unknown property hint: " + hint);
                updateFunc = updateStandard;
        }

        return updateFunc;
    }

    /** @private */
    private static function getPropertyHint(property:String):String
    {
        // colorization is special; it does not require a hint marker, just the word 'color'.
        if (property.indexOf("color") != -1 || property.indexOf("Color") != -1)
            return "rgb";

        var hintMarkerIndex:Int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substr(hintMarkerIndex+1);
        else return null;
    }

    /** @private */
    private static function getPropertyName(property:String):String
    {
        var hintMarkerIndex:Int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substring(0, hintMarkerIndex);
        else return property;
    }

    private function updateStandard(property:String, startValue:Float, endValue:Float):Void
    {
        var newValue:Float = startValue + __progress * (endValue - startValue);
        if (__roundToInt) newValue = Math.round(newValue);
        Reflect.setProperty(__target, property, newValue);
    }

    private function updateRgb(property:String, startValue:Float, endValue:Float):Void
    {
        Reflect.setProperty(__target, property, Color.interpolate(Std.int(startValue), Std.int(endValue), __progress));
    }

    private function updateRad(property:String, startValue:Float, endValue:Float):Void
    {
        updateAngle(Math.PI, property, startValue, endValue);
    }

    private function updateDeg(property:String, startValue:Float, endValue:Float):Void
    {
        updateAngle(180, property, startValue, endValue);
    }

    private function updateAngle(pi:Float, property:String, startValue:Float, endValue:Float):Void
    {
        while (Math.abs(endValue - startValue) > pi)
        {
            if (startValue < endValue) endValue -= 2.0 * pi;
            else                       endValue += 2.0 * pi;
        }

        updateStandard(property, startValue, endValue);
    }
    
    /** The end value a certain property is animated to. Throws an ArgumentError if the 
     * property is not being animated. */
    public function getEndValue(property:String):Float
    {
        var index:Int = __properties.indexOf(property);
        if (index == -1) throw new ArgumentError("The property '" + property + "' is not animated");
        else return __endValues[index];
    }

    /** Indicates if a property with the given name is being animated by this tween. */
    public function animatesProperty(property:String):Bool
    {
        return __properties.indexOf(property) != -1;
    }
    
    /** Indicates if the tween is finished. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool 
    { 
        return __currentTime >= __totalTime && __repeatCount == 1; 
    }        
    
    /** The target object that is animated. */
    public var target(get, never):Dynamic;
    private function get_target():Dynamic { return __target; }
    
    /** The transition method used for the animation. @see Transitions */
    public var transition(get, set):String;
    private function get_transition():String { return __transitionName; }
    private function set_transition(value:String):String 
    { 
        __transitionName = value;
        __transitionFunc = Transitions.getTransition(value);
        
        if (__transitionFunc == null)
            throw new ArgumentError("Invalid transiton: " + value);
        return value;
    }
    
    /** The actual transition function used for the animation. */
    public var transitionFunc(get, set):Float->Float;
    private function get_transitionFunc():Float->Float { return __transitionFunc; }
    private function set_transitionFunc(value:Float->Float):Float->Float
    {
        __transitionName = "custom";
        __transitionFunc = value;
        return value;
    }
    
    /** The total time the tween will take per repetition (in seconds). */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float { return __totalTime; }
    
    /** The time that has passed since the tween was created (in seconds). */
    public var currentTime(get, never):Float;
    private function get_currentTime():Float { return __currentTime; }
    
    /** The current progress between 0 and 1, as calculated by the transition function. */
    public var progress(get, never):Float;
    private function get_progress():Float { return __progress; } 
    
    /** The delay before the tween is started (in seconds). @default 0 */
    public var delay(get, set):Float;
    private function get_delay():Float { return __delay; }
    private function set_delay(value:Float):Float 
    { 
        __currentTime = __currentTime + __delay - value;
        __delay = value;
        return value;
    }
    
    /** The number of times the tween will be executed. 
     * Set to '0' to tween indefinitely. @default 1 */
    public var repeatCount(get, set):Int;
    private function get_repeatCount():Int { return __repeatCount; }
    private function set_repeatCount(value:Int):Int { return __repeatCount = value; }
    
    /** The amount of time to wait between repeat cycles (in seconds). @default 0 */
    public var repeatDelay(get, set):Float;
    private function get_repeatDelay():Float { return __repeatDelay; }
    private function set_repeatDelay(value:Float):Float { return __repeatDelay = value; }
    
    /** Indicates if the tween should be reversed when it is repeating. If enabled, 
     * every second repetition will be reversed. @default false */
    public var reverse(get, set):Bool;
    private function get_reverse():Bool { return __reverse; }
    private function set_reverse(value:Bool):Bool { return __reverse = value; }
    
    /** Indicates if the numeric values should be cast to Integers. @default false */
    public var roundToInt(get, set):Bool;
    private function get_roundToInt():Bool { return __roundToInt; }
    private function set_roundToInt(value:Bool):Bool { return __roundToInt = value; }        
    
    /** A function that will be called when the tween starts (after a possible delay). */
    public var onStart(get, set):Function;
    private function get_onStart():Function { return __onStart; }
    private function set_onStart(value:Function):Function { return __onStart = value; }
    
    /** A function that will be called each time the tween is advanced. */
    public var onUpdate(get, set):Function;
    private function get_onUpdate():Function { return __onUpdate; }
    private function set_onUpdate(value:Function):Function { return __onUpdate = value; }
    
    /** A function that will be called each time the tween finishes one repetition
     * (except the last, which will trigger 'onComplete'). */
    public var onRepeat(get, set):Function;
    private function get_onRepeat():Function { return __onRepeat; }
    private function set_onRepeat(value:Function):Function { return __onRepeat = value; }
    
    /** A function that will be called when the tween is complete. */
    public var onComplete(get, set):Function;
    private function get_onComplete():Function { return __onComplete; }
    private function set_onComplete(value:Function):Function { return __onComplete = value; }
    
    /** The arguments that will be passed to the 'onStart' function. */
    public var onStartArgs(get, set):Array<Dynamic>;
    private function get_onStartArgs():Array<Dynamic> { return __onStartArgs; }
    private function set_onStartArgs(value:Array<Dynamic>):Array<Dynamic> { return __onStartArgs = value; }
    
    /** The arguments that will be passed to the 'onUpdate' function. */
    public var onUpdateArgs(get, set):Array<Dynamic>;
    private function get_onUpdateArgs():Array<Dynamic> { return __onUpdateArgs; }
    private function set_onUpdateArgs(value:Array<Dynamic>):Array<Dynamic> { return __onUpdateArgs = value; }
    
    /** The arguments that will be passed to the 'onRepeat' function. */
    public var onRepeatArgs(get, set):Array<Dynamic>;
    private function get_onRepeatArgs():Array<Dynamic> { return __onRepeatArgs; }
    private function set_onRepeatArgs(value:Array<Dynamic>):Array<Dynamic> { return __onRepeatArgs = value; }
    
    /** The arguments that will be passed to the 'onComplete' function. */
    public var onCompleteArgs(get, set):Array<Dynamic>;
    private function get_onCompleteArgs():Array<Dynamic> { return __onCompleteArgs; }
    private function set_onCompleteArgs(value:Array<Dynamic>):Array<Dynamic> { return __onCompleteArgs = value; }
    
    /** Another tween that will be started (i.e. added to the same juggler) as soon as 
     * this tween is completed. */
    public var nextTween(get, set):Tween;
    private function get_nextTween():Tween { return __nextTween; }
    private function set_nextTween(value:Tween):Tween { return __nextTween = value; }
    
    // tween pooling
    
    private static var sTweenPool:Vector<Tween> = new Vector<Tween>();
    
    /** @private */
    @:allow(starling) private static function fromPool(target:Dynamic, time:Float, 
                                                       transition:Dynamic="linear"):Tween
    {
        if (sTweenPool.length != 0) return sTweenPool.pop().reset(target, time, transition);
        else return new Tween(target, time, transition);
    }
    
    /** @private */
    @:allow(starling) private static function toPool(tween:Tween):Void
    {
        // reset any object-references, to make sure we don't prevent any garbage collection
        tween.__onStart = tween.__onUpdate = tween.__onRepeat = tween.__onComplete = null;
        tween.__onStartArgs = tween.__onUpdateArgs = tween.__onRepeatArgs = tween.__onCompleteArgs = null;
        tween.__target = null;
        tween.__transitionFunc = null;
        tween.removeEventListeners();
        sTweenPool.push(tween);
    }
}

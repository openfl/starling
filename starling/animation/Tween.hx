// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================


package starling.animation
{
import starling.core.starling_internal;
import starling.events.Event;
import starling.events.EventDispatcher;

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
public class Tween extends EventDispatcher implements IAnimatable
{
    private static const HINT_MARKER:String = '#';

    private var _target:Object;
    private var _transitionFunc:Function;
    private var _transitionName:String;
    
    private var _properties:Vector.<String>;
    private var _startValues:Vector.<Float>;
    private var _endValues:Vector.<Float>;
    private var _updateFuncs:Vector.<Function>;

    private var _onStart:Function;
    private var _onUpdate:Function;
    private var _onRepeat:Function;
    private var _onComplete:Function;
    
    private var _onStartArgs:Array;
    private var _onUpdateArgs:Array;
    private var _onRepeatArgs:Array;
    private var _onCompleteArgs:Array;
    
    private var _totalTime:Float;
    private var _currentTime:Float;
    private var _progress:Float;
    private var _delay:Float;
    private var _roundToInt:Bool;
    private var _nextTween:Tween;
    private var _repeatCount:Int;
    private var _repeatDelay:Float;
    private var _reverse:Bool;
    private var _currentCycle:Int;
    
    /** Creates a tween with a target, duration (in seconds) and a transition function.
     *  @param target the object that you want to animate
     *  @param time the duration of the Tween (in seconds)
     *  @param transition can be either a String (e.g. one of the constants defined in the
     *         Transitions class) or a function. Look up the 'Transitions' class for a   
     *         documentation about the required function signature. */ 
    public function Tween(target:Object, time:Float, transition:Object="linear")        
    {
         reset(target, time, transition);
    }

    /** Resets the tween to its default values. Useful for pooling tweens. */
    public function reset(target:Object, time:Float, transition:Object="linear"):Tween
    {
        _target = target;
        _currentTime = 0.0;
        _totalTime = Math.max(0.0001, time);
        _progress = 0.0;
        _delay = _repeatDelay = 0.0;
        _onStart = _onUpdate = _onRepeat = _onComplete = null;
        _onStartArgs = _onUpdateArgs = _onRepeatArgs = _onCompleteArgs = null;
        _roundToInt = _reverse = false;
        _repeatCount = 1;
        _currentCycle = -1;
        _nextTween = null;
        
        if (transition is String)
            this.transition = transition as String;
        else if (transition is Function)
            this.transitionFunc = transition as Function;
        else 
            throw new ArgumentError("Transition must be either a string or a function");
        
        if (_properties)  _properties.length  = 0; else _properties  = new <String>[];
        if (_startValues) _startValues.length = 0; else _startValues = new <Float>[];
        if (_endValues)   _endValues.length   = 0; else _endValues   = new <Float>[];
        if (_updateFuncs) _updateFuncs.length = 0; else _updateFuncs = new <Function>[];
        
        return this;
    }
    
    /** Animates the property of the target to a certain value. You can call this method
     *  multiple times on one tween.
     *
     *  <p>Some property types are handled in a special way:</p>
     *  <ul>
     *    <li>If the property contains the string <code>color</code> or <code>Color</code>,
     *        it will be treated as an unsigned integer with a color value
     *        (e.g. <code>0xff0000</code> for red). Each color channel will be animated
     *        individually.</li>
     *    <li>The same happens if you append the string <code>#rgb</code> to the name.</li>
     *    <li>If you append <code>#rad</code>, the property is treated as an angle in radians,
     *        making sure it always uses the shortest possible arc for the rotation.</li>
     *    <li>The string <code>#deg</code> does the same for angles in degrees.</li>
     *  </ul>
     */
    public function animate(property:String, endValue:Float):Void
    {
        if (_target == null) return; // tweening null just does nothing.

        var pos:Int = _properties.length;
        var updateFunc:Function = getUpdateFuncFromProperty(property);

        _properties[pos] = getPropertyName(property);
        _startValues[pos] = Float.NaN;
        _endValues[pos] = endValue;
        _updateFuncs[pos] = updateFunc;
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
     *  smallest possible arc. 'type' may be either 'rad' or 'deg', depending on the unit of
     *  measurement. */
    public function rotateTo(angle:Float, type:String="rad"):Void
    {
        animate("rotation#" + type, angle);
    }
    
    /** @inheritDoc */
    public function advanceTime(time:Float):Void
    {
        if (time == 0 || (_repeatCount == 1 && _currentTime == _totalTime)) return;
        
        var i:Int;
        var previousTime:Float = _currentTime;
        var restTime:Float = _totalTime - _currentTime;
        var carryOverTime:Float = time > restTime ? time - restTime : 0.0;
        
        _currentTime += time;
        
        if (_currentTime <= 0)
            return; // the delay is not over yet
        else if (_currentTime > _totalTime)
            _currentTime = _totalTime;
        
        if (_currentCycle < 0 && previousTime <= 0 && _currentTime > 0)
        {
            _currentCycle++;
            if (_onStart != null) _onStart.apply(this, _onStartArgs);
        }

        var ratio:Float = _currentTime / _totalTime;
        var reversed:Bool = _reverse && (_currentCycle % 2 == 1);
        var numProperties:Int = _startValues.length;
        _progress = reversed ? _transitionFunc(1.0 - ratio) : _transitionFunc(ratio);

        for (i=0; i<numProperties; ++i)
        {                
            if (_startValues[i] != _startValues[i]) // isNaN check - "isNaN" causes allocation!
                _startValues[i] = _target[_properties[i]] as Float;

            var updateFunc:Function = _updateFuncs[i] as Function;
            updateFunc(_properties[i], _startValues[i], _endValues[i]);
        }

        if (_onUpdate != null)
            _onUpdate.apply(this, _onUpdateArgs);
        
        if (previousTime < _totalTime && _currentTime >= _totalTime)
        {
            if (_repeatCount == 0 || _repeatCount > 1)
            {
                _currentTime = -_repeatDelay;
                _currentCycle++;
                if (_repeatCount > 1) _repeatCount--;
                if (_onRepeat != null) _onRepeat.apply(this, _onRepeatArgs);
            }
            else
            {
                // save callback & args: they might be changed through an event listener
                var onComplete:Function = _onComplete;
                var onCompleteArgs:Array = _onCompleteArgs;
                
                // in the 'onComplete' callback, people might want to call "tween.reset" and
                // add it to another juggler; so this event has to be dispatched *before*
                // executing 'onComplete'.
                dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
                if (onComplete != null) onComplete.apply(this, onCompleteArgs);
            }
        }
        
        if (carryOverTime) 
            advanceTime(carryOverTime);
    }

    // animation hints

    private function getUpdateFuncFromProperty(property:String):Function
    {
        var updateFunc:Function;
        var hint:String = getPropertyHint(property);

        switch (hint)
        {
            case null:  updateFunc = updateStandard; break;
            case "rgb": updateFunc = updateRgb; break;
            case "rad": updateFunc = updateRad; break;
            case "deg": updateFunc = updateDeg; break;
            default:
                trace("[Starling] Ignoring unknown property hint:", hint);
                updateFunc = updateStandard;
        }

        return updateFunc;
    }

    /** @private */
    internal static function getPropertyHint(property:String):String
    {
        // colorization is special; it does not require a hint marker, just the word 'color'.
        if (property.indexOf("color") != -1 || property.indexOf("Color") != -1)
            return "rgb";

        var hintMarkerIndex:Int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substr(hintMarkerIndex+1);
        else return null;
    }

    /** @private */
    internal static function getPropertyName(property:String):String
    {
        var hintMarkerIndex:Int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substring(0, hintMarkerIndex);
        else return property;
    }

    private function updateStandard(property:String, startValue:Float, endValue:Float):Void
    {
        var newValue:Float = startValue + _progress * (endValue - startValue);
        if (_roundToInt) newValue = Math.round(newValue);
        _target[property] = newValue;
    }

    private function updateRgb(property:String, startValue:Float, endValue:Float):Void
    {
        var startColor:UInt = UInt(startValue);
        var endColor:UInt   = UInt(endValue);

        var startA:UInt = (startColor >> 24) & 0xff;
        var startR:UInt = (startColor >> 16) & 0xff;
        var startG:UInt = (startColor >>  8) & 0xff;
        var startB:UInt = (startColor      ) & 0xff;

        var endA:UInt = (endColor >> 24) & 0xff;
        var endR:UInt = (endColor >> 16) & 0xff;
        var endG:UInt = (endColor >>  8) & 0xff;
        var endB:UInt = (endColor      ) & 0xff;

        var newA:UInt = startA + (endA - startA) * _progress;
        var newR:UInt = startR + (endR - startR) * _progress;
        var newG:UInt = startG + (endG - startG) * _progress;
        var newB:UInt = startB + (endB - startB) * _progress;

        _target[property] = (newA << 24) | (newR << 16) | (newG << 8) | newB;
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
     *  property is not being animated. */
    public function getEndValue(property:String):Float
    {
        var index:Int = _properties.indexOf(property);
        if (index == -1) throw new ArgumentError("The property '" + property + "' is not animated");
        else return _endValues[index] as Float;
    }
    
    /** Indicates if the tween is finished. */
    public function get isComplete():Bool 
    { 
        return _currentTime >= _totalTime && _repeatCount == 1;
    }        
    
    /** The target object that is animated. */
    public function get target():Object { return _target; }
    
    /** The transition method used for the animation. @see Transitions */
    public function get transition():String { return _transitionName; }
    public function set transition(value:String):Void 
    { 
        _transitionName = value;
        _transitionFunc = Transitions.getTransition(value);
        
        if (_transitionFunc == null)
            throw new ArgumentError("Invalid transiton: " + value);
    }
    
    /** The actual transition function used for the animation. */
    public function get transitionFunc():Function { return _transitionFunc; }
    public function set transitionFunc(value:Function):Void
    {
        _transitionName = "custom";
        _transitionFunc = value;
    }
    
    /** The total time the tween will take per repetition (in seconds). */
    public function get totalTime():Float { return _totalTime; }
    
    /** The time that has passed since the tween was created (in seconds). */
    public function get currentTime():Float { return _currentTime; }
    
    /** The current progress between 0 and 1, as calculated by the transition function. */
    public function get progress():Float { return _progress; }
    
    /** The delay before the tween is started (in seconds). @default 0 */
    public function get delay():Float { return _delay; }
    public function set delay(value:Float):Void 
    { 
        _currentTime = _currentTime + _delay - value;
        _delay = value;
    }
    
    /** The number of times the tween will be executed. 
     *  Set to '0' to tween indefinitely. @default 1 */
    public function get repeatCount():Int { return _repeatCount; }
    public function set repeatCount(value:Int):Void { _repeatCount = value; }
    
    /** The amount of time to wait between repeat cycles (in seconds). @default 0 */
    public function get repeatDelay():Float { return _repeatDelay; }
    public function set repeatDelay(value:Float):Void { _repeatDelay = value; }
    
    /** Indicates if the tween should be reversed when it is repeating. If enabled, 
     *  every second repetition will be reversed. @default false */
    public function get reverse():Bool { return _reverse; }
    public function set reverse(value:Bool):Void { _reverse = value; }
    
    /** Indicates if the numeric values should be cast to Integers. @default false */
    public function get roundToInt():Bool { return _roundToInt; }
    public function set roundToInt(value:Bool):Void { _roundToInt = value; }
    
    /** A function that will be called when the tween starts (after a possible delay). */
    public function get onStart():Function { return _onStart; }
    public function set onStart(value:Function):Void { _onStart = value; }
    
    /** A function that will be called each time the tween is advanced. */
    public function get onUpdate():Function { return _onUpdate; }
    public function set onUpdate(value:Function):Void { _onUpdate = value; }
    
    /** A function that will be called each time the tween finishes one repetition
     *  (except the last, which will trigger 'onComplete'). */
    public function get onRepeat():Function { return _onRepeat; }
    public function set onRepeat(value:Function):Void { _onRepeat = value; }
    
    /** A function that will be called when the tween is complete. */
    public function get onComplete():Function { return _onComplete; }
    public function set onComplete(value:Function):Void { _onComplete = value; }
    
    /** The arguments that will be passed to the 'onStart' function. */
    public function get onStartArgs():Array { return _onStartArgs; }
    public function set onStartArgs(value:Array):Void { _onStartArgs = value; }
    
    /** The arguments that will be passed to the 'onUpdate' function. */
    public function get onUpdateArgs():Array { return _onUpdateArgs; }
    public function set onUpdateArgs(value:Array):Void { _onUpdateArgs = value; }
    
    /** The arguments that will be passed to the 'onRepeat' function. */
    public function get onRepeatArgs():Array { return _onRepeatArgs; }
    public function set onRepeatArgs(value:Array):Void { _onRepeatArgs = value; }
    
    /** The arguments that will be passed to the 'onComplete' function. */
    public function get onCompleteArgs():Array { return _onCompleteArgs; }
    public function set onCompleteArgs(value:Array):Void { _onCompleteArgs = value; }
    
    /** Another tween that will be started (i.e. added to the same juggler) as soon as 
     *  this tween is completed. */
    public function get nextTween():Tween { return _nextTween; }
    public function set nextTween(value:Tween):Void { _nextTween = value; }
    
    // tween pooling
    
    private static var sTweenPool:Vector.<Tween> = new <Tween>[];
    
    /** @private */
    starling_internal static function fromPool(target:Object, time:Float, 
                                               transition:Object="linear"):Tween
    {
        if (sTweenPool.length) return sTweenPool.pop().reset(target, time, transition);
        else return new Tween(target, time, transition);
    }
    
    /** @private */
    starling_internal static function toPool(tween:Tween):Void
    {
        // reset any object-references, to make sure we don't prevent any garbage collection
        tween._onStart = tween._onUpdate = tween._onRepeat = tween._onComplete = null;
        tween._onStartArgs = tween._onUpdateArgs = tween._onRepeatArgs = tween._onCompleteArgs = null;
        tween._target = null;
        tween._transitionFunc = null;
        tween.removeEventListeners();
        sTweenPool.push(tween);
    }
}
}

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

import openfl.Vector;

import starling.events.Event;
import starling.events.EventDispatcher;

/** A DelayedCall allows you to execute a method after a certain time has passed. Since it 
 *  implements the IAnimatable interface, it can be added to a juggler. In most cases, you 
 *  do not have to use this class directly; the juggler class contains a method to delay
 *  calls directly. 
 * 
 *  <p>DelayedCall dispatches an Event of type 'Event.REMOVE_FROM_JUGGLER' when it is finished,
 *  so that the juggler automatically removes it when its no longer needed.</p>
 * 
 *  @see Juggler
 */ 
class DelayedCall extends EventDispatcher implements IAnimatable
{
    private var __currentTime:Float;
    private var __totalTime:Float;
    @:allow(starling) private var __callback:Function;
    private var __args:Array<Dynamic>;
    private var __repeatCount:Int;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DelayedCall.prototype, {
            "isComplete": { get: untyped __js__ ("function () { return this.get_alpha (); }") },
            "totalTime": { get: untyped __js__ ("function () { return this.get_totalTime (); }") },
            "currentTime": { get: untyped __js__ ("function () { return this.get_currentTime (); }") },
            "repeatCount": { get: untyped __js__ ("function () { return this.get_repeatCount (); }"), set: untyped __js__ ("function (v) { return this.set_repeatCount (v); }") },
            "callback": { get: untyped __js__ ("function () { return this.get_callback (); }") },
            "arguments": { get: untyped __js__ ("function () { return this.get_arguments (); }") },
        });
        
    }
    #end
    
    /** Creates a delayed call. */
    public function new(callback:Function, delay:Float, args:Array<Dynamic>=null)
    {
        super();
        reset(callback, delay, args);
    }
    
    /** Resets the delayed call to its default values, which is useful for pooling. */
    public function reset(callback:Function, delay:Float, args:Array<Dynamic>=null):DelayedCall
    {
        __currentTime = 0;
        __totalTime = Math.max(delay, 0.0001);
        __callback = callback;
        __args = args != null ? args : [];
        __repeatCount = 1;
        
        return this;
    }
    
    /** @inheritDoc */
    public function advanceTime(time:Float):Void
    {
        var previousTime:Float = __currentTime;
        __currentTime += time;

        if (__currentTime > __totalTime)
            __currentTime = __totalTime;
        
        if (previousTime < __totalTime && __currentTime >= __totalTime)
        {                
            if (__repeatCount == 0 || __repeatCount > 1)
            {
                Reflect.callMethod(__callback, __callback, __args);
                
                if (__repeatCount > 0) __repeatCount -= 1;
                __currentTime = 0;
                advanceTime((previousTime + time) - __totalTime);
            }
            else
            {
                // save call & args: they might be changed through an event listener
                var call:Function = __callback;
                var args:Array<Dynamic> = __args;
                
                // in the callback, people might want to call "reset" and re-add it to the
                // juggler; so this event has to be dispatched *before* executing 'call'.
                dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
                Reflect.callMethod(call, call, args);
            }
        }
    }

    /** Advances the delayed call so that it is executed right away. If 'repeatCount' is
      * anything else than '1', this method will complete only the current iteration. */
    public function complete():Void
    {
        var restTime:Float = __totalTime - __currentTime;
        if (restTime > 0) advanceTime(restTime);
    }
    
    /** Indicates if enough time has passed, and the call has already been executed. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool 
    { 
        return __repeatCount == 1 && __currentTime >= __totalTime; 
    }
    
    /** The time for which calls will be delayed (in seconds). */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float { return __totalTime; }
    
    /** The time that has already passed (in seconds). */
    public var currentTime(get, never):Float;
    private function get_currentTime():Float { return __currentTime; }
    
    /** The number of times the call will be repeated. 
     * Set to '0' to repeat indefinitely. @default 1 */
    public var repeatCount(get, set):Int;
    private function get_repeatCount():Int { return __repeatCount; }
    private function set_repeatCount(value:Int):Int { return __repeatCount = value; }
    
    /** The callback that will be executed when the time is up. */
    public var callback(get, never):Function;
    private function get_callback():Function { return __callback; }

    /** The arguments that the callback will be executed with.
        *  Beware: not a copy, but the actual object! */
    public var arguments(get, never):Array<Dynamic>;
    private function get_arguments():Array<Dynamic> { return __args; }
    
    // delayed call pooling
    
    private static var sPool:Vector<DelayedCall> = new Vector<DelayedCall>();
    
    /** @private */
    @:allow(starling) private static function fromPool(call:Function, delay:Float, 
                                                       args:Array<Dynamic>=null):DelayedCall
    {
        if (sPool.length != 0) return sPool.pop().reset(call, delay, args);
        else return new DelayedCall(call, delay, args);
    }
    
    /** @private */
    @:allow(starling) private static function toPool(delayedCall:DelayedCall):Void
    {
        // reset any object-references, to make sure we don't prevent any garbage collection
        delayedCall.__callback = null;
        delayedCall.__args = null;
        delayedCall.removeEventListeners();
        sPool.push(delayedCall);
    }
}
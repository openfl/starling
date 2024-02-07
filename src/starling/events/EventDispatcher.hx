// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

import haxe.Constraints.Function;
import openfl.errors.ArgumentError;
import openfl.Vector;

import starling.display.DisplayObject;

/** The EventDispatcher class is the base class for all classes that dispatch events. 
 *  This is the Starling version of the Flash class with the same name. 
 *  
 *  <p>The event mechanism is a key feature of Starling's architecture. Objects can communicate 
 *  with each other through events. Compared the the Flash event system, Starling's event system
 *  was simplified. The main difference is that Starling events have no "Capture" phase.
 *  They are simply dispatched at the target and may optionally bubble up. They cannot move 
 *  in the opposite direction.</p>  
 *  
 *  <p>As in the conventional Flash classes, display objects inherit from EventDispatcher 
 *  and can thus dispatch events. Beware, though, that the Starling event classes are 
 *  <em>not compatible with Flash events:</em> Starling display objects dispatch 
 *  Starling events, which will bubble along Starling display objects - but they cannot 
 *  dispatch Flash events or bubble along Flash display objects.</p>
 *  
 *  @see Event
 *  @see starling.display.DisplayObject DisplayObject
 */
class EventDispatcher
{
    @:noCompletion private var __eventListeners:Map<String, Vector<Function>>;
    @:noCompletion private var __eventStack:Vector<String> = new Vector<String>();
    
    /** Helper object. */
    private static var sBubbleChains:Array<Vector<EventDispatcher>> = new Array<Vector<EventDispatcher>>();
    
    /** Creates an EventDispatcher. */
    public function new()
    {  }
    
    /** Registers an event listener at a certain object. */
    public function addEventListener(type:String, listener:Function):Void
    {
        // Original Starling makes a change here from Vector.<Function> to Array and adds the following comment:
        // "The listeners are stored inside an Array instead of a Vector as a workaround
        // to a strange String allocation taking place in the AOT compiler.
        // See: https://tracker.adobe.com/#/view/AIR-4115729"
        // Could that AOT complier bug apply to Haxe too, when using the flash target? Should we switch from Vector<Dynamic> to Array<Dynamic>?
        // For now I left things as they where
        
        if (listener == null) throw new ArgumentError("null listener added");
        
        if (__eventListeners == null)
            __eventListeners = new Map<String, Vector<Function>>();
        
        var listeners:Vector<Function> = __eventListeners[type];
        if (listeners == null)
        {
            __eventListeners[type] = new Vector<Function>();
            __eventListeners[type].push(listener);
        }
        else
        {
            for (i in 0...listeners.length)
            {
                if (Reflect.compareMethods (listeners[i], listener)) // check for duplicates
                    return;
            }
            listeners[listeners.length] = listener; // avoid 'push'
        }
    }
    
    /** Removes an event listener from the object. */
    public function removeEventListener(type:String, listener:Function):Void
    {
        if (__eventListeners != null)
        {
            var listeners:Vector<Function> = __eventListeners[type];
            var numListeners:Int = listeners != null ? listeners.length : 0;

            if (numListeners > 0)
            {
                // we must not modify the original vector, but work on a copy.
                // (see comment in 'invokeEvent')

                var index:Int = listeners.indexOf(listener);

                if (index != -1)
                {
                    if(__eventStack.indexOf(type) == -1)
                    {
                        listeners.removeAt(index);
                    }
                    else
                    {
                        var restListeners:Vector<Function> = listeners.slice(0, index);

                        for (i in index+1...numListeners)
                            restListeners[i-1] = listeners[i];

                        __eventListeners[type] = restListeners;
                    }
                }
            }
        }
    }
    
    /** Removes all event listeners with a certain type, or all of them if type is null. 
     * Be careful when removing all event listeners: you never know who else was listening. */
    public function removeEventListeners(type:String=null):Void
    {
        if (type != null && __eventListeners != null)
            __eventListeners.remove(type);
        else
            __eventListeners = null;
    }
    
    /** Dispatches an event to all objects that have registered listeners for its type. 
     * If an event with enabled 'bubble' property is dispatched to a display object, it will 
     * travel up along the line of parents, until it either hits the root object or someone
     * stops its propagation manually. */
    public function dispatchEvent(event:Event):Void
    {
        var bubbles:Bool = event.bubbles;
        
        if (!bubbles && (__eventListeners == null || !(__eventListeners.exists(event.type))))
            return; // no need to do anything
        
        // we save the current target and restore it later;
        // this allows users to re-dispatch events without creating a clone.
        
        var previousTarget:EventDispatcher = event.target;
        event.setTarget(this);
        
        if (bubbles && #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(this, DisplayObject)) __bubbleEvent(event);
        else                                        __invokeEvent(event);
        
        if (previousTarget != null) event.setTarget(previousTarget);
    }
    
    /** @private
     * Invokes an event on the current object. This method does not do any bubbling, nor
     * does it back-up and restore the previous target on the event. The 'dispatchEvent' 
     * method uses this method internally. */
    @:allow(starling) @:noCompletion private function __invokeEvent(event:Event):Bool
    {
        var listeners:Vector<Function> = __eventListeners != null ?
            __eventListeners[event.type] : null;
        var numListeners:Int = listeners == null ? 0 : listeners.length;
        
        if (numListeners != 0)
        {
            event.setCurrentTarget(this);
            __eventStack[__eventStack.length] = event.type;
            
            // we can enumerate directly over the vector, because:
            // when somebody modifies the list while we're looping, "addEventListener" is not
            // problematic, and "removeEventListener" will create a new Vector, anyway.
            
            for (i in 0...numListeners)
            {
                var listener:Function = listeners[i];
                if (listener == null) continue;

                #if flash
                var numArgs:Int = untyped listener.length;
                #elseif neko
                var numArgs:Int = untyped ($nargs)(listener);
                #elseif cpp
                var numArgs:Int = untyped listener.__ArgCount();
				#elseif html5
				var numArgs:Int = untyped listener.length;
                #else
                var numArgs:Int = 2;
                #end
                
                if (numArgs == 0) listener();
                else if (numArgs == 1) listener(event);
                else listener(event, event.data);
                
                if (event.stopsImmediatePropagation)
                {
                    __eventStack.pop();
                    return true;
                }
            }

            __eventStack.pop();
            
            return event.stopsPropagation;
        }
        else
        {
            return false;
        }
    }
    
    /** @private */
    @:noCompletion private function __bubbleEvent(event:Event):Void
    {
        // we determine the bubble chain before starting to invoke the listeners.
        // that way, changes done by the listeners won't affect the bubble chain.
        
        var chain:Vector<EventDispatcher>;
        var element:DisplayObject = cast(this, DisplayObject);
        var length:Int = 1;
        
        if (sBubbleChains.length > 0) { chain = sBubbleChains.pop(); chain[0] = element; }
        else
        {
            chain = new Vector<EventDispatcher>();
            chain.push(element);
        }
        
        while ((element = element.parent) != null)
            chain[length++] = element;

        for (i in 0...length)
        {
            if (chain[i] == null) continue;
            var stopPropagation:Bool = chain[i].__invokeEvent(event);
            if (stopPropagation) break;
        }
        
        chain.length = 0;
        sBubbleChains[sBubbleChains.length] = chain; // avoid 'push'
    }
    
    /** Dispatches an event with the given parameters to all objects that have registered 
     * listeners for the given type. The method uses an internal pool of event objects to 
     * avoid allocations. */
    public function dispatchEventWith(type:String, bubbles:Bool=false, data:Dynamic=null):Void
    {
        if (bubbles || hasEventListener(type)) 
        {
            var event:Event = Event.fromPool(type, bubbles, data);
            dispatchEvent(event);
            Event.toPool(event);
        }
    }
    
    /** If called with one argument, figures out if there are any listeners registered for
     * the given event type. If called with two arguments, also determines if a specific
     * listener is registered. */
    public function hasEventListener(type:String, listener:Dynamic=null):Bool
    {
        var listeners:Vector<Function> = __eventListeners != null ? __eventListeners[type] : null;
        if (listeners == null) return false;
        else
        {
            if (listener != null) return listeners.indexOf(listener) != -1;
            else return listeners.length != 0;
        }
    }
}
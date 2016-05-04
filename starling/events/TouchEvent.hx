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
import starling.display.DisplayObject;
import starling.utils.ArrayUtil;

/** A TouchEvent is triggered either by touch or mouse input.  
 *  
 *  <p>In Starling, both touch events and mouse events are handled through the same class: 
 *  TouchEvent. To process user input from a touch screen or the mouse, you have to register
 *  an event listener for events of the type <code>TouchEvent.TOUCH</code>. This is the only
 *  event type you need to handle; the long list of mouse event types as they are used in
 *  conventional Flash are mapped to so-called "TouchPhases" instead.</p> 
 * 
 *  <p>The difference between mouse input and touch input is that</p>
 *  
 *  <ul>
 *    <li>only one mouse cursor can be present at a given moment and</li>
 *    <li>only the mouse can "hover" over an object without a pressed button.</li>
 *  </ul> 
 *  
 *  <strong>Which objects receive touch events?</strong>
 * 
 *  <p>In Starling, any display object receives touch events, as long as the  
 *  <code>touchable</code> property of the object and its parents is enabled. There 
 *  is no "InteractiveObject" class in Starling.</p>
 *  
 *  <strong>How to work with individual touches</strong>
 *  
 *  <p>The event contains a list of all touches that are currently present. Each individual
 *  touch is stored in an object of type "Touch". Since you are normally only interested in 
 *  the touches that occurred on top of certain objects, you can query the event for touches
 *  with a specific target:</p>
 * 
 *  <code>var touches:Vector.&lt;Touch&gt; = touchEvent.getTouches(this);</code>
 *  
 *  <p>This will return all touches of "this" or one of its children. When you are not using 
 *  multitouch, you can also access the touch object directly, like this:</p>
 * 
 *  <code>var touch:Touch = touchEvent.getTouch(this);</code>
 *  
 *  @see Touch
 *  @see TouchPhase
 */ 
class TouchEvent extends Event
{
    /** Event type for touch or mouse input. */
    inline public static var TOUCH:String = "touch";
    
    private var _shiftKey:Bool;
    private var _ctrlKey:Bool;
    private var _timestamp:Float;
    private var _visitedObjects:Array<EventDispatcher>;
    
    /** Helper object. */
    private static var sTouches:Array<Touch> = new Array<Touch>();
    
    /** Creates a new TouchEvent instance. */
    public function new(type:String, touches:Array<Touch>, shiftKey:Bool=false, 
                               ctrlKey:Bool=false, bubbles:Bool=true)
    {
        super(type, bubbles, touches);
        
        _shiftKey = shiftKey;
        _ctrlKey = ctrlKey;
        _timestamp = -1.0;
        _visitedObjects = new Array<EventDispatcher>();
        
        var numTouches:Int=touches.length;
        for (i in 0 ... numTouches)
            if (touches[i].timestamp > _timestamp)
                _timestamp = touches[i].timestamp;
    }
    
    /** Returns a list of touches that originated over a certain target. If you pass an
     *  <code>out</code>-vector, the touches will be added to this vector instead of creating
     *  a new object. */
    public function getTouches(target:DisplayObject, phase:String=null,
                               out:Array<Touch>=null):Array<Touch>
    {
        if (out == null) out = new Array<Touch>();
        var allTouches:Array<Dynamic> = cast(data, Array<Dynamic>);
        var numTouches:Int = allTouches.length;
        
        for (i in 0 ... numTouches)
        {
            var touch:Touch = cast(allTouches[i], Touch);
            var correctTarget:Bool = touch.isTouching(target);
            var correctPhase:Bool = (phase == null || phase == touch.phase);
                
            if (correctTarget && correctPhase)
                out[out.length] = touch; // avoiding 'push'
        }
        return out;
    }
    
    /** Returns a touch that originated over a certain target. 
     * 
     *  @param target   The object that was touched; may also be a parent of the actual
     *                  touch-target.
     *  @param phase    The phase the touch must be in, or null if you don't care.
     *  @param id       The ID of the requested touch, or -1 if you don't care.
     */
    public function getTouch(target:DisplayObject, phase:String=null, id:Int=-1):Touch
    {
        getTouches(target, phase, sTouches);
        var numTouches:Int = sTouches.length;
        
        if (numTouches > 0) 
        {
            var touch:Touch = null;
            
            if (id < 0) touch = sTouches[0];
            else
            {
                for (i in 0 ... numTouches)
                    if (sTouches[i].id == id) { touch = sTouches[i]; break; }
            }
            
            ArrayUtil.clear(sTouches);
            return touch;
        }
        else return null;
    }
    
    /** Indicates if a target is currently being touched or hovered over. */
    public function interactsWith(target:DisplayObject):Bool
    {
        var result:Bool = false;
        getTouches(target, null, sTouches);
        
        var i:Int = sTouches.length - 1;
        while (i>=0)
        {
            if (sTouches[i].phase != TouchPhase.ENDED)
            {
                result = true;
                break;
            }
            --i;
        }
        
        ArrayUtil.clear(sTouches);
        return result;
    }
    
    // custom dispatching
    
    /** @private
     *  Dispatches the event along a custom bubble chain. During the lifetime of the event,
     *  each object is visited only once. */
    public function dispatch(chain:Array<EventDispatcher>):Void
    {
        if (chain != null && chain.length != 0)
        {
            var chainLength:Int = bubbles ? chain.length : 1;
            var previousTarget:EventDispatcher = target;
            setTarget(chain[0]);
            
            for (i in 0 ... chainLength)
            {
                var chainElement:EventDispatcher = chain[i];
                if (_visitedObjects.indexOf(chainElement) == -1)
                {
                    var stopPropagation:Bool = chainElement.invokeEvent(this);
                    _visitedObjects[_visitedObjects.length] = chainElement;
                    if (stopPropagation) break;
                }
            }
            
            setTarget(previousTarget);
        }
    }
    
    // properties
    
    /** The time the event occurred (in seconds since application launch). */
    public var timestamp(get, never):Float;
    private function get_timestamp():Float { return _timestamp; }
    
    /** All touches that are currently available. */
    public var touches(get, never):Array<Touch>;
    private function get_touches():Array<Touch>
    {
        var touches:Array<Dynamic> = cast(data, Array<Dynamic>);
        var result:Array<Touch> = [];
        for (i in 0 ... touches.length)
            result.push(cast(touches[i], Touch));
        return result;
    }
    
    /** Indicates if the shift key was pressed when the event occurred. */
    public var shiftKey(get, never):Bool;
    private function get_shiftKey():Bool { return _shiftKey; }
    
    /** Indicates if the ctrl key was pressed when the event occurred. (Mac OS: Cmd or Ctrl) */
    public var ctrlKey(get, never):Bool;
    private function get_ctrlKey():Bool { return _ctrlKey; }
}
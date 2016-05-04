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
import flash.geom.Point;
import starling.utils.ArrayUtil;

import starling.display.DisplayObject;
import starling.utils.StringUtil;

/** A Touch object contains information about the presence or movement of a finger
 *  or the mouse on the screen.
 *  
 *  <p>You receive objects of this type from a TouchEvent. When such an event is triggered,
 *  you can query it for all touches that are currently present on the screen. One touch
 *  object contains information about a single touch; it always transitions through a series
 *  of TouchPhases. Have a look at the TouchPhase class for more information.</p>
 *  
 *  <strong>The position of a touch</strong>
 *  
 *  <p>You can get the current and previous position in stage coordinates with the corresponding 
 *  properties. However, you'll want to have the position in a different coordinate system 
 *  most of the time. For this reason, there are methods that convert the current and previous 
 *  touches into the local coordinate system of any object.</p>
 * 
 *  @see TouchEvent
 *  @see TouchPhase
 */  
class Touch
{
    private var _id:Int;
    private var _globalX:Float;
    private var _globalY:Float;
    private var _previousGlobalX:Float;
    private var _previousGlobalY:Float;
    private var _tapCount:Int;
    private var _phase:String;
    private var _target:DisplayObject;
    private var _timestamp:Float;
    private var _pressure:Float;
    private var _width:Float;
    private var _height:Float;
    private var _cancelled:Bool;
    private var _bubbleChain:Array<EventDispatcher>;
    
    /** Helper object. */
    private static var sHelperPoint:Point = new Point();
    
    /** Creates a new Touch object. */
    public function new(id:Int)
    {
        _id = id;
        _tapCount = 0;
        _phase = TouchPhase.HOVER;
        _pressure = _width = _height = 1.0;
        _bubbleChain = new Array<EventDispatcher>();
        
        _globalX = 0;
        _globalY = 0;
        _previousGlobalX = 0;
        _previousGlobalY = 0;
        _target = null;
        _timestamp = 0;
        _width = 0;
        _height = 0;
        _cancelled = false;
    }
    
    /** Converts the current location of a touch to the local coordinate system of a display 
     *  object. If you pass an <code>out</code>-point, the result will be stored in this point
     *  instead of creating a new object.*/
    public function getLocation(space:DisplayObject, out:Point=null):Point
    {
        sHelperPoint.setTo(_globalX, _globalY);
        return space.globalToLocal(sHelperPoint, out);
    }
    
    /** Converts the previous location of a touch to the local coordinate system of a display 
     *  object. If you pass an <code>out</code>-point, the result will be stored in this point
     *  instead of creating a new object.*/
    public function getPreviousLocation(space:DisplayObject, out:Point=null):Point
    {
        sHelperPoint.setTo(_previousGlobalX, _previousGlobalY);
        return space.globalToLocal(sHelperPoint, out);
    }
    
    /** Returns the movement of the touch between the current and previous location. 
     *  If you pass an <code>out</code>-point, the result will be stored in this point instead
     *  of creating a new object. */ 
    public function getMovement(space:DisplayObject, out:Point=null):Point
    {
        if (out == null) out = new Point();
        getLocation(space, out);
        var x:Float = out.x;
        var y:Float = out.y;
        getPreviousLocation(space, out);
        out.setTo(x - out.x, y - out.y);
        return out;
    }
    
    /** Indicates if the target or one of its children is touched. */ 
    public function isTouching(target:DisplayObject):Bool
    {
        return _bubbleChain.indexOf(target) != -1;
    }
    
    /** Returns a description of the object. */
    public function toString():String
    {
        return StringUtil.format("[Touch {0}: globalX={1}, globalY={2}, phase={3}]",
                                 [_id, _globalX, _globalY, _phase]);
    }
    
    /** Creates a clone of the Touch object. */
    public function clone():Touch
    {
        var clone:Touch = new Touch(_id);
        clone._globalX = _globalX;
        clone._globalY = _globalY;
        clone._previousGlobalX = _previousGlobalX;
        clone._previousGlobalY = _previousGlobalY;
        clone._phase = _phase;
        clone._tapCount = _tapCount;
        clone._timestamp = _timestamp;
        clone._pressure = _pressure;
        clone._width = _width;
        clone._height = _height;
        clone._cancelled = _cancelled;
        clone.target = _target;
        return clone;
    }
    
    // helper methods
    
    private function updateBubbleChain():Void
    {
        if (_target != null)
        {
            var length:Int = 1;
            var element:DisplayObject = _target;
            
            ArrayUtil.resize(_bubbleChain, 1);
            _bubbleChain[0] = element;
            
            while ((element = element.parent) != null)
                _bubbleChain[length++] = element;
        }
        else
        {
            ArrayUtil.clear(_bubbleChain);
        }
    }
    
    // properties
    
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public var id(get, never):Int;
    @:noCompletion private function get_id():Int { return _id; }
    
    /** The previous x-position of the touch in stage coordinates. */
    public var previousGlobalX(get, never):Float;
    @:noCompletion private function get_previousGlobalX():Float { return _previousGlobalX; }
    
    /** The previous y-position of the touch in stage coordinates. */
    public var previousGlobalY(get, never):Float;
    @:noCompletion private function get_previousGlobalY():Float { return _previousGlobalY; }

    /** The x-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalX". */
    public var globalX(get, set):Float;
    @:noCompletion private function get_globalX():Float { return _globalX; }
    @:noCompletion private function set_globalX(value:Float):Float
    {
        _previousGlobalX = _globalX != _globalX ? value : _globalX; // isNaN check
        _globalX = value;
        return value;
    }

    /** The y-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalY". */
    public var globalY(get, set):Float;
    @:noCompletion private function get_globalY():Float { return _globalY; }
    @:noCompletion private function set_globalY(value:Float):Float
    {
        _previousGlobalY = _globalY != _globalY ? value : _globalY; // isNaN check
        _globalY = value;
        return value;
    }
    
    /** The number of taps the finger made in a short amount of time. Use this to detect 
     *  double-taps / double-clicks, etc. */ 
    public var tapCount(get, set):Int;
    @:noCompletion private function get_tapCount():Int { return _tapCount; }
    @:noCompletion private function set_tapCount(value:Int):Int { return _tapCount = value; }
    
    /** The current phase the touch is in. @see TouchPhase */
    public var phase(get, set):String;
    @:noCompletion private function get_phase():String { return _phase; }
    @:noCompletion private function set_phase(value:String):String { return _phase = value; }
    
    /** The display object at which the touch occurred. */
    public var target(get, set):DisplayObject;
    @:noCompletion private function get_target():DisplayObject { return _target; }
    @:noCompletion private function set_target(value:DisplayObject):DisplayObject
    {
        if (_target != value)
        {
            _target = value;
            updateBubbleChain();
        }
        return value;
    }
    
    /** The moment the touch occurred (in seconds since application start). */
    public var timestamp(get, set):Float;
    @:noCompletion private function get_timestamp():Float { return _timestamp; }
    @:noCompletion private function set_timestamp(value:Float):Float { return _timestamp = value; }
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device. 
     *  If the device does not support detecting the pressure, the value is 1.0. */ 
    public var pressure(get, set):Float;
    @:noCompletion private function get_pressure():Float { return _pressure; }
    @:noCompletion private function set_pressure(value:Float):Float { return _pressure = value; }
    
    /** Width of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var width(get, set):Float;
    @:noCompletion private function get_width():Float { return _width; }
    @:noCompletion private function set_width(value:Float):Float { return _width = value; }
    
    /** Height of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var height(get, set):Float;
    @:noCompletion private function get_height():Float { return _height; }
    @:noCompletion private function set_height(value:Float):Float { return _height = value; }

    /** Indicates if the touch has been cancelled, which may happen when the app moves into
     *  the background ('Event.DEACTIVATE'). @default false */
    public var cancelled(get, set):Bool;
    @:noCompletion private function get_cancelled():Bool { return _cancelled; }
    @:noCompletion private function set_cancelled(value:Bool):Bool { return _cancelled = value; }

    // internal methods
    
    /** @private 
     *  Dispatches a touch event along the current bubble chain (which is updated each time
     *  a target is set). */
    public function dispatchEvent(event:TouchEvent):Void
    {
        if (_target != null) event.dispatch(_bubbleChain);
    }
    
    /** @private */
    public var bubbleChain(get, never):Array<EventDispatcher>;
    @:noCompletion private function get_bubbleChain():Array<EventDispatcher>
    {
        return _bubbleChain.copy();
    }
}

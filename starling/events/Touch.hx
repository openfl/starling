// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events
{
import flash.geom.Point;

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
public class Touch
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
    private var _bubbleChain:Vector.<EventDispatcher>;
    
    /** Helper object. */
    private static var sHelperPoint:Point = new Point();
    
    /** Creates a new Touch object. */
    public function Touch(id:Int)
    {
        _id = id;
        _tapCount = 0;
        _phase = TouchPhase.HOVER;
        _pressure = _width = _height = 1.0;
        _bubbleChain = new <EventDispatcher>[];
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
                                 _id, _globalX, _globalY, _phase);
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
        if (_target)
        {
            var length:Int = 1;
            var element:DisplayObject = _target;
            
            _bubbleChain.length = 1;
            _bubbleChain[0] = element;
            
            while ((element = element.parent) != null)
                _bubbleChain[Int(length++)] = element;
        }
        else
        {
            _bubbleChain.length = 0;
        }
    }
    
    // properties
    
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public function get id():Int { return _id; }
    
    /** The previous x-position of the touch in stage coordinates. */
    public function get previousGlobalX():Float { return _previousGlobalX; }
    
    /** The previous y-position of the touch in stage coordinates. */
    public function get previousGlobalY():Float { return _previousGlobalY; }

    /** The x-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalX". */
    public function get globalX():Float { return _globalX; }
    public function set globalX(value:Float):Void
    {
        _previousGlobalX = _globalX != _globalX ? value : _globalX; // isNaN check
        _globalX = value;
    }

    /** The y-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalY". */
    public function get globalY():Float { return _globalY; }
    public function set globalY(value:Float):Void
    {
        _previousGlobalY = _globalY != _globalY ? value : _globalY; // isNaN check
        _globalY = value;
    }
    
    /** The number of taps the finger made in a short amount of time. Use this to detect 
     *  double-taps / double-clicks, etc. */ 
    public function get tapCount():Int { return _tapCount; }
    public function set tapCount(value:Int):Void { _tapCount = value; }
    
    /** The current phase the touch is in. @see TouchPhase */
    public function get phase():String { return _phase; }
    public function set phase(value:String):Void { _phase = value; }
    
    /** The display object at which the touch occurred. */
    public function get target():DisplayObject { return _target; }
    public function set target(value:DisplayObject):Void
    {
        if (_target != value)
        {
            _target = value;
            updateBubbleChain();
        }
    }
    
    /** The moment the touch occurred (in seconds since application start). */
    public function get timestamp():Float { return _timestamp; }
    public function set timestamp(value:Float):Void { _timestamp = value; }
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device. 
     *  If the device does not support detecting the pressure, the value is 1.0. */ 
    public function get pressure():Float { return _pressure; }
    public function set pressure(value:Float):Void { _pressure = value; }
    
    /** Width of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public function get width():Float { return _width; }
    public function set width(value:Float):Void { _width = value; }
    
    /** Height of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public function get height():Float { return _height; }
    public function set height(value:Float):Void { _height = value; }

    /** Indicates if the touch has been cancelled, which may happen when the app moves into
     *  the background ('Event.DEACTIVATE'). @default false */
    public function get cancelled():Bool { return _cancelled; }
    public function set cancelled(value:Bool):Void { _cancelled = value; }

    // internal methods
    
    /** @private 
     *  Dispatches a touch event along the current bubble chain (which is updated each time
     *  a target is set). */
    internal function dispatchEvent(event:TouchEvent):Void
    {
        if (_target) event.dispatch(_bubbleChain);
    }
    
    /** @private */
    internal function get bubbleChain():Vector.<EventDispatcher>
    {
        return _bubbleChain.concat();
    }
}
}

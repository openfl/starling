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

import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.Vector;

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
    private var __id:Int;
    private var __globalX:Float;
    private var __globalY:Float;
    private var __previousGlobalX:Float;
    private var __previousGlobalY:Float;
    private var __tapCount:Int;
    private var __phase:String;
    private var __target:DisplayObject;
    private var __timestamp:Float;
    private var __pressure:Float;
    private var __width:Float;
    private var __height:Float;
    private var __cancelled:Bool;
    private var __bubbleChain:Vector<EventDispatcher>;
    
    /** Helper object. */
    private static var sHelperPoint:Point = new Point();
    
    /** Creates a new Touch object. */
    public function new(id:Int)
    {
        __id = id;
        __tapCount = 0;
        __phase = TouchPhase.HOVER;
        __pressure = __width = __height = 1.0;
        __bubbleChain = new Vector<EventDispatcher>();
    }
    
    /** Converts the current location of a touch to the local coordinate system of a display 
     * object. If you pass an <code>out</code>-point, the result will be stored in this point
     * instead of creating a new object.*/
    public function getLocation(space:DisplayObject, out:Point=null):Point
    {
        sHelperPoint.setTo(__globalX, __globalY);
        return space.globalToLocal(sHelperPoint, out);
    }
    
    /** Converts the previous location of a touch to the local coordinate system of a display 
     * object. If you pass an <code>out</code>-point, the result will be stored in this point
     * instead of creating a new object.*/
    public function getPreviousLocation(space:DisplayObject, out:Point=null):Point
    {
        sHelperPoint.setTo(__previousGlobalX, __previousGlobalY);
        return space.globalToLocal(sHelperPoint, out);
    }
    
    /** Returns the movement of the touch between the current and previous location. 
     * If you pass an <code>out</code>-point, the result will be stored in this point instead
     * of creating a new object. */ 
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
        return __bubbleChain.indexOf(target) != -1;
    }
    
    /** Returns a description of the object. */
    public function toString():String
    {
	return 'Touch $__id: globalX=$__globalX, globalY=$__globalY, phase=$__phase';
    }
    
    /** Creates a clone of the Touch object. */
    public function clone():Touch
    {
        var clone:Touch = new Touch(__id);
        clone.__globalX = __globalX;
        clone.__globalY = __globalY;
        clone.__previousGlobalX = __previousGlobalX;
        clone.__previousGlobalY = __previousGlobalY;
        clone.__phase = __phase;
        clone.__tapCount = __tapCount;
        clone.__timestamp = __timestamp;
        clone.__pressure = __pressure;
        clone.__width = __width;
        clone.__height = __height;
        clone.__cancelled = __cancelled;
        clone.target = __target;
        return clone;
    }
    
    // helper methods
    
    private function updateBubbleChain():Void
    {
        if (__target != null)
        {
            var length:Int = 1;
            var element:DisplayObject = __target;
            
            __bubbleChain.length = 1;
            __bubbleChain[0] = element;
            
            while ((element = element.parent) != null)
                __bubbleChain[length++] = element;
        }
        else
        {
            __bubbleChain.length = 0;
        }
    }
    
    // properties
    
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public var id(get, never):Int;
    private function get_id():Int { return __id; }
    
    /** The previous x-position of the touch in stage coordinates. */
    public var previousGlobalX(get, never):Float;
    private function get_previousGlobalX():Float { return __previousGlobalX; }
    
    /** The previous y-position of the touch in stage coordinates. */
    public var previousGlobalY(get, never):Float;
    private function get_previousGlobalY():Float { return __previousGlobalY; }

    /** The x-position of the touch in stage coordinates. If you change this value,
     * the previous one will be moved to "previousGlobalX". */
    public var globalX(get, set):Float;
    private function get_globalX():Float { return __globalX; }
    private function set_globalX(value:Float):Float
    {
        __previousGlobalX = __globalX != __globalX ? value : __globalX; // isNaN check
        return __globalX = value;
    }

    /** The y-position of the touch in stage coordinates. If you change this value,
     * the previous one will be moved to "previousGlobalY". */
    public var globalY(get, set):Float;
    private function get_globalY():Float { return __globalY; }
    private function set_globalY(value:Float):Float
    {
        __previousGlobalY = __globalY != __globalY ? value : __globalY; // isNaN check
        return __globalY = value;
    }
    
    /** The number of taps the finger made in a short amount of time. Use this to detect 
     * double-taps / double-clicks, etc. */ 
    public var tapCount(get, set):Int;
    private function get_tapCount():Int { return __tapCount; }
    private function set_tapCount(value:Int):Int { return __tapCount = value; }
    
    /** The current phase the touch is in. @see TouchPhase */
    public var phase(get, set):String;
    private function get_phase():String { return __phase; }
    private function set_phase(value:String):String { return __phase = value; }
    
    /** The display object at which the touch occurred. */
    public var target(get, set):DisplayObject;
    private function get_target():DisplayObject { return __target; }
    private function set_target(value:DisplayObject):DisplayObject
    {
        if (__target != value)
        {
            __target = value;
            updateBubbleChain();
        }
        return __target;
    }
    
    /** The moment the touch occurred (in seconds since application start). */
    public var timestamp(get, set):Float;
    private function get_timestamp():Float { return __timestamp; }
    private function set_timestamp(value:Float):Float { return __timestamp = value; }
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device. 
     * If the device does not support detecting the pressure, the value is 1.0. */ 
    public var pressure(get, set):Float;
    private function get_pressure():Float { return __pressure; }
    private function set_pressure(value:Float):Float { return __pressure = value; }
    
    /** Width of the contact area. 
     * If the device does not support detecting the pressure, the value is 1.0. */
    public var width(get, set):Float;
    private function get_width():Float { return __width; }
    private function set_width(value:Float):Float { return __width = value; }
    
    /** Height of the contact area. 
     * If the device does not support detecting the pressure, the value is 1.0. */
    public var height(get, set):Float;
    private function get_height():Float { return __height; }
    private function set_height(value:Float):Float { return __height = value; }

    /** Indicates if the touch has been cancelled, which may happen when the app moves into
     * the background ('Event.DEACTIVATE'). @default false */
    public var cancelled(get, set):Bool;
    private function get_cancelled():Bool { return __cancelled; }
    private function set_cancelled(value:Bool):Bool { return __cancelled = value; }

    // internal methods
    
    /** @private 
     * Dispatches a touch event along the current bubble chain (which is updated each time
     * a target is set). */
    @:allow(starling) private function dispatchEvent(event:TouchEvent):Void
    {
        if (__target != null) event.dispatch(__bubbleChain);
    }
    
    /** @private */
    @:allow(starling) private var bubbleChain(get, never):Vector<EventDispatcher>;
    private function get_bubbleChain():Vector<EventDispatcher>
    {
        return __bubbleChain.concat();
    }
}
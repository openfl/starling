// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils
{
import starling.events.Event;
import starling.events.EventDispatcher;

/** Dispatched when any property of the instance changes. */
[Event(name="change", type="starling.events.Event")]

/** The padding class stores one number for each of four directions,
 *  thus describing the padding around a 2D object. */
public class Padding extends EventDispatcher
{
    private var _left:Float;
    private var _right:Float;
    private var _top:Float;
    private var _bottom:Float;

    /** Creates a new instance with the given properties. */
    public function Padding(left:Float=0, right:Float=0, top:Float=0, bottom:Float=0)
    {
        setTo(left, right, top, bottom);
    }

    /** Sets all four values at once. */
    public function setTo(left:Float=0, right:Float=0, top:Float=0, bottom:Float=0):Void
    {
        var changed:Bool = _left != left || _right != right || _top != top || _bottom != bottom;

        _left = left;
        _right = right;
        _top = top;
        _bottom = bottom;

        if (changed) dispatchEventWith(Event.CHANGE);
    }

    /** Copies all properties from another Padding instance.
     *  Pass <code>null</code> to reset all values to zero. */
    public function copyFrom(padding:Padding):Void
    {
        if (padding == null) setTo(0, 0, 0, 0);
        else setTo(padding._left, padding._right, padding._top, padding._bottom);
    }

    /** Creates a new instance with the exact same values. */
    public function clone():Padding
    {
        return new Padding(_left, _right, _top, _bottom);
    }

    /** The padding on the left side. */
    public function get left():Float { return _left; }
    public function set left(value:Float):Void
    {
        if (_left != value)
        {
            _left = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The padding on the right side. */
    public function get right():Float { return _right; }
    public function set right(value:Float):Void
    {
        if (_right != value)
        {
            _right = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The padding towards the top. */
    public function get top():Float { return _top; }
    public function set top(value:Float):Void
    {
        if (_top != value)
        {
            _top = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The padding towards the bottom. */
    public function get bottom():Float { return _bottom; }
    public function set bottom(value:Float):Void
    {
        if (_bottom != value)
        {
            _bottom = value;
            dispatchEventWith(Event.CHANGE);
        }
    }
}
}

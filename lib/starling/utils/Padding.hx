// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import starling.events.Event;
import starling.events.EventDispatcher;

/** Dispatched when any property of the instance changes. */
@:meta(Event(name="change", type="starling.events.Event"))

/** The padding class stores one number for each of four directions,
 *  thus describing the padding around a 2D object. */

@:jsRequire("starling/utils/Padding", "default")

extern class Padding extends EventDispatcher
{
    /** Creates a new instance with the given properties. */
    public function new(left:Float=0, right:Float=0, top:Float=0, bottom:Float=0);

    /** Sets all four values at once. */
    public function setTo(left:Float=0, right:Float=0, top:Float=0, bottom:Float=0):Void;

    /** Sets all four sides to the same value. */
    public function setToUniform(value:Float):Void;

    /** Sets left and right to <code>horizontal</code>, top and bottom to <code>vertical</code>. */
    public function setToSymmetric(horizontal:Float, vertical:Float):Void;

    /** Copies all properties from another Padding instance.
        *  Pass <code>null</code> to reset all values to zero. */
    public function copyFrom(padding:Padding):Void;

    /** Creates a new instance with the exact same values. */
    public function clone():Padding;

    /** The padding on the left side. */
    public var left(get, set):Float;
    private function get_left():Float;
    private function set_left(value:Float):Float;

    /** The padding on the right side. */
    public var right(get, set):Float;
    private function get_right():Float;
    private function set_right(value:Float):Float;

    /** The padding towards the top. */
    public var top(get, set):Float;
    private function get_top():Float;
    private function set_top(value:Float):Float;

    /** The padding towards the bottom. */
    public var bottom(get, set):Float;
    private function get_bottom():Float;
    private function set_bottom(value:Float):Float;
}
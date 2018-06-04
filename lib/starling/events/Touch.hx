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

@:jsRequire("starling/events/Touch", "default")

extern class Touch
{
    /** Creates a new Touch object. */
    public function new(id:Int);
    
    /** Converts the current location of a touch to the local coordinate system of a display 
     * object. If you pass an <code>out</code>-point, the result will be stored in this point
     * instead of creating a new object.*/
    public function getLocation(space:DisplayObject, out:Point=null):Point;
    
    /** Converts the previous location of a touch to the local coordinate system of a display 
     * object. If you pass an <code>out</code>-point, the result will be stored in this point
     * instead of creating a new object.*/
    public function getPreviousLocation(space:DisplayObject, out:Point=null):Point;
    
    /** Returns the movement of the touch between the current and previous location. 
     * If you pass an <code>out</code>-point, the result will be stored in this point instead
     * of creating a new object. */ 
    public function getMovement(space:DisplayObject, out:Point=null):Point;
    
    /** Indicates if the target or one of its children is touched. */ 
    public function isTouching(target:DisplayObject):Bool;
    
    /** Returns a description of the object. */
    public function toString():String;
    
    /** Creates a clone of the Touch object. */
    public function clone():Touch;
    
    // properties
    
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public var id(get, never):Int;
    private function get_id():Int;
    
    /** The previous x-position of the touch in stage coordinates. */
    public var previousGlobalX(get, never):Float;
    private function get_previousGlobalX():Float;
    
    /** The previous y-position of the touch in stage coordinates. */
    public var previousGlobalY(get, never):Float;
    private function get_previousGlobalY():Float;

    /** The x-position of the touch in stage coordinates. If you change this value,
     * the previous one will be moved to "previousGlobalX". */
    public var globalX(get, set):Float;
    private function get_globalX():Float;
    private function set_globalX(value:Float):Float;

    /** The y-position of the touch in stage coordinates. If you change this value,
     * the previous one will be moved to "previousGlobalY". */
    public var globalY(get, set):Float;
    private function get_globalY():Float;
    private function set_globalY(value:Float):Float;
    
    /** The number of taps the finger made in a short amount of time. Use this to detect 
     * double-taps / double-clicks, etc. */ 
    public var tapCount(get, set):Int;
    private function get_tapCount():Int;
    private function set_tapCount(value:Int):Int;
    
    /** The current phase the touch is in. @see TouchPhase */
    public var phase(get, set):String;
    private function get_phase():String;
    private function set_phase(value:String):String;
    
    /** The display object at which the touch occurred. */
    public var target(get, set):DisplayObject;
    private function get_target():DisplayObject;
    private function set_target(value:DisplayObject):DisplayObject;
    
    /** The moment the touch occurred (in seconds since application start). */
    public var timestamp(get, set):Float;
    private function get_timestamp():Float;
    private function set_timestamp(value:Float):Float;
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device. 
     * If the device does not support detecting the pressure, the value is 1.0. */ 
    public var pressure(get, set):Float;
    private function get_pressure():Float;
    private function set_pressure(value:Float):Float;
    
    /** Width of the contact area. 
     * If the device does not support detecting the pressure, the value is 1.0. */
    public var width(get, set):Float;
    private function get_width():Float;
    private function set_width(value:Float):Float;
    
    /** Height of the contact area. 
     * If the device does not support detecting the pressure, the value is 1.0. */
    public var height(get, set):Float;
    private function get_height():Float;
    private function set_height(value:Float):Float;

    /** Indicates if the touch has been cancelled, which may happen when the app moves into
     * the background ('Event.DEACTIVATE'). @default false */
    public var cancelled(get, set):Bool;
    private function get_cancelled():Bool;
    private function set_cancelled(value:Bool):Bool;
}
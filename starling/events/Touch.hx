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
import flash.geom.Matrix;
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.utils.StringUtil;
import openfl.Vector;

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
    private var mID:Int;
    private var mGlobalX:Float;
    private var mGlobalY:Float;
    private var mPreviousGlobalX:Float;
    private var mPreviousGlobalY:Float;
    private var mTapCount:Int;
    private var mPhase:String;
    private var mTarget:DisplayObject;
    private var mTimestamp:Float;
    private var mPressure:Float;
    private var mWidth:Float;
    private var mHeight:Float;
    private var mCancelled:Bool;
    private var mBubbleChain:Vector<EventDispatcher>;
    
    /** Helper object. */
    private static var sHelperPoint:Point = new Point();
    
    /** Creates a new Touch object. */
    public function new(id:Int)
    {
        mID = id;
        mTapCount = 0;
        mPhase = TouchPhase.HOVER;
        mPressure = mWidth = mHeight = 1.0;
        mBubbleChain = new Vector<EventDispatcher>();
    }
    
    /** Converts the current location of a touch to the local coordinate system of a display 
     *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
     *  of creating a new object.*/
    public function getLocation(space:DisplayObject, resultPoint:Point=null):Point
    {
        sHelperPoint.setTo(mGlobalX, mGlobalY);
        return space.globalToLocal(sHelperPoint, resultPoint);
    }
    
    /** Converts the previous location of a touch to the local coordinate system of a display 
     *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
     *  of creating a new object.*/
    public function getPreviousLocation(space:DisplayObject, resultPoint:Point=null):Point
    {
        sHelperPoint.setTo(mPreviousGlobalX, mPreviousGlobalY);
        return space.globalToLocal(sHelperPoint, resultPoint);
    }
    
    /** Returns the movement of the touch between the current and previous location. 
     *  If you pass a 'resultPoint', the result will be stored in this point instead 
     *  of creating a new object. */ 
    public function getMovement(space:DisplayObject, resultPoint:Point=null):Point
    {
        if (resultPoint == null) resultPoint = new Point();
        getLocation(space, resultPoint);
        var x:Float = resultPoint.x;
        var y:Float = resultPoint.y;
        getPreviousLocation(space, resultPoint);
        resultPoint.setTo(x - resultPoint.x, y - resultPoint.y);
        return resultPoint;
    }
    
    /** Indicates if the target or one of its children is touched. */ 
    public function isTouching(target:DisplayObject):Bool
    {
        return mBubbleChain.indexOf(target) != -1;
    }
    
    /** Returns a description of the object. */
    public function toString():String
    {
        var args:Array<Dynamic> = [mID, mGlobalX, mGlobalY, mPhase];
        return StringUtil.formatString("Touch {0}: globalX={1}, globalY={2}, phase={3}", args);
    }
    
    /** Creates a clone of the Touch object. */
    public function clone():Touch
    {
        var clone:Touch = new Touch(mID);
        clone.mGlobalX = mGlobalX;
        clone.mGlobalY = mGlobalY;
        clone.mPreviousGlobalX = mPreviousGlobalX;
        clone.mPreviousGlobalY = mPreviousGlobalY;
        clone.mPhase = mPhase;
        clone.mTapCount = mTapCount;
        clone.mTimestamp = mTimestamp;
        clone.mPressure = mPressure;
        clone.mWidth = mWidth;
        clone.mHeight = mHeight;
        clone.mCancelled = mCancelled;
        clone.target = mTarget;
        return clone;
    }
    
    // helper methods
    
    private function updateBubbleChain():Void
    {
        if (mTarget != null)
        {
            var length:Int = 1;
            var element:DisplayObject = mTarget;
            
            mBubbleChain = Vector.ofArray ([element]);
            
            while ((element = element.parent) != null)
                mBubbleChain[length++] = element;
        }
        else
        {
            mBubbleChain = [];
        }
    }
    
    // properties
    
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public var id(get, never):Int;
    private function get_id():Int { return mID; }
    
    /** The previous x-position of the touch in stage coordinates. */
    public var previousGlobalX(get, never):Float;
    private function get_previousGlobalX():Float { return mPreviousGlobalX; }
    
    /** The previous y-position of the touch in stage coordinates. */
    public var previousGlobalY(get, never):Float;
    private function get_previousGlobalY():Float { return mPreviousGlobalY; }

    /** The x-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalX". */
    public var globalX(get, set):Float;
    private function get_globalX():Float { return mGlobalX; }
    private function set_globalX(value:Float):Float
    {
        mPreviousGlobalX = mGlobalX != mGlobalX ? value : mGlobalX; // isNaN check
        return mGlobalX = value;
    }

    /** The y-position of the touch in stage coordinates. If you change this value,
     *  the previous one will be moved to "previousGlobalY". */
    public var globalY(get, set):Float;
    private function get_globalY():Float { return mGlobalY; }
    private function set_globalY(value:Float):Float
    {
        mPreviousGlobalY = mGlobalY != mGlobalY ? value : mGlobalY; // isNaN check
        return mGlobalY = value;
    }
    
    /** The number of taps the finger made in a short amount of time. Use this to detect 
     *  double-taps / double-clicks, etc. */ 
    public var tapCount(get, set):Int;
    private function get_tapCount():Int { return mTapCount; }
    private function set_tapCount(value:Int):Int { return mTapCount = value; }
    
    /** The current phase the touch is in. @see TouchPhase */
    public var phase(get, set):String;
    private function get_phase():String { return mPhase; }
    private function set_phase(value:String):String { return mPhase = value; }
    
    /** The display object at which the touch occurred. */
    public var target(get, set):DisplayObject;
    private function get_target():DisplayObject { return mTarget; }
    private function set_target(value:DisplayObject):DisplayObject
    {
        if (mTarget != value)
        {
            mTarget = value;
            updateBubbleChain();
        }
        return mTarget;
    }
    
    /** The moment the touch occurred (in seconds since application start). */
    public var timestamp(get, set):Float;
    private function get_timestamp():Float { return mTimestamp; }
    private function set_timestamp(value:Float):Float { return mTimestamp = value; }
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device. 
     *  If the device does not support detecting the pressure, the value is 1.0. */ 
    public var pressure(get, set):Float;
    private function get_pressure():Float { return mPressure; }
    private function set_pressure(value:Float):Float { return mPressure = value; }
    
    /** Width of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var width(get, set):Float;
    private function get_width():Float { return mWidth; }
    private function set_width(value:Float):Float { return mWidth = value; }
    
    /** Height of the contact area. 
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var height(get, set):Float;
    private function get_height():Float { return mHeight; }
    private function set_height(value:Float):Float { return mHeight = value; }

    /** Indicates if the touch has been cancelled, which may happen when the app moves into
     *  the background ('Event.DEACTIVATE'). @default false */
    public var cancelled(get, set):Bool;
    private function get_cancelled():Bool { return mCancelled; }
    private function set_cancelled(value:Bool):Bool { return mCancelled = value; }

    // internal methods
    
    /** @private 
     *  Dispatches a touch event along the current bubble chain (which is updated each time
     *  a target is set). */
    public function dispatchEvent(event:TouchEvent):Void
    {
        if (mTarget != null) event.dispatch(mBubbleChain);
    }
    
    /** @private */
    public var bubbleChain(get, never):Vector<EventDispatcher>;
    private function get_bubbleChain():Vector<EventDispatcher>
    {
        return mBubbleChain.copy();
    }
}

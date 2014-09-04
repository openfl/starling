// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.geom.Point;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.core.starling_internal;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.FragmentFilter;

use namespace starling_internal;

/** Dispatched when the Flash container is resized. */
[Event(name="resize", type="starling.events.ResizeEvent")]

/** A Stage represents the root of the display tree.  
 *  Only objects that are direct or indirect children of the stage will be rendered.
 * 
 *  <p>This class represents the Starling version of the stage. Don't confuse it with its 
 *  Flash equivalent: while the latter contains objects of the type 
 *  <code>flash.display.DisplayObject</code>, the Starling stage contains only objects of the
 *  type <code>starling.display.DisplayObject</code>. Those classes are not compatible, and 
 *  you cannot exchange one type with the other.</p>
 * 
 *  <p>A stage object is created automatically by the <code>Starling</code> class. Don't
 *  create a Stage instance manually.</p>
 * 
 *  <strong>Keyboard Events</strong>
 * 
 *  <p>In Starling, keyboard events are only dispatched at the stage. Add an event listener
 *  directly to the stage to be notified of keyboard events.</p>
 * 
 *  <strong>Resize Events</strong>
 * 
 *  <p>When the Flash player is resized, the stage dispatches a <code>ResizeEvent</code>. The 
 *  event contains properties containing the updated width and height of the Flash player.</p>
 *
 *  @see starling.events.KeyboardEvent
 *  @see starling.events.ResizeEvent  
 * 
 * */
public class Stage extends DisplayObjectContainer
{
    private var mWidth:Int;
    private var mHeight:Int;
    private var mColor:UInt;
    private var mEnterFrameEvent:EnterFrameEvent;
    private var mEnterFrameListeners:Vector.<DisplayObject>;
    
    /** @private */
    public function Stage(width:Int, height:Int, color:UInt=0)
    {
        mWidth = width;
        mHeight = height;
        mColor = color;
        mEnterFrameEvent = new EnterFrameEvent(Event.ENTER_FRAME, 0.0);
        mEnterFrameListeners = new <DisplayObject>[];
    }
    
    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void
    {
        mEnterFrameEvent.reset(Event.ENTER_FRAME, false, passedTime);
        broadcastEvent(mEnterFrameEvent);
    }

    /** Returns the object that is found topmost beneath a point in stage coordinates, or  
     *  the stage itself if nothing else is found. */
    public override function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
    {
        if (forTouch && (!visible || !touchable))
            return null;
        
        // locations outside of the stage area shouldn't be accepted
        if (localPoint.x < 0 || localPoint.x > mWidth ||
            localPoint.y < 0 || localPoint.y > mHeight)
            return null;
        
        // if nothing else is hit, the stage returns itself as target
        var target:DisplayObject = super.hitTest(localPoint, forTouch);
        if (target == null) target = this;
        return target;
    }
    
    /** Draws the complete stage into a BitmapData object.
     *
     *  <p>If you encounter problems with transparency, start Starling in BASELINE profile
     *  (or higher). BASELINE_CONSTRAINED might not support transparency on all platforms.
     *  </p>
     *
     *  @param destination: If you pass null, the object will be created for you.
     *                      If you pass a BitmapData object, it should have the size of the
     *                      back buffer (which is accessible via the respective properties
     *                      on the Starling instance).
     *  @param transparent: If enabled, empty areas will appear transparent; otherwise, they
     *                      will be filled with the stage color.
     */
    public function drawToBitmapData(destination:BitmapData=null,
                                     transparent:Bool=true):BitmapData
    {
        var support:RenderSupport = new RenderSupport();
        var star:Starling = Starling.current;
        
        if (destination == null)
            destination = new BitmapData(star.backBufferWidth, star.backBufferHeight, transparent);
        
        support.renderTarget = null;
        support.setOrthographicProjection(0, 0, mWidth, mHeight);
        
        if (transparent) support.clear();
        else             support.clear(mColor, 1);
        
        render(support, 1.0);
        support.finishQuadBatch();
        
        Starling.current.context.drawToBitmapData(destination);
        Starling.current.context.present(); // required on some platforms to avoid flickering
        
        return destination;
    }
    
    // enter frame event optimization
    
    /** @private */
    internal function addEnterFrameListener(listener:DisplayObject):Void
    {
        mEnterFrameListeners.push(listener);
    }
    
    /** @private */
    internal function removeEnterFrameListener(listener:DisplayObject):Void
    {
        var index:Int = mEnterFrameListeners.indexOf(listener);
        if (index >= 0) mEnterFrameListeners.splice(index, 1); 
    }
    
    /** @private */
    internal override function getChildEventListeners(object:DisplayObject, eventType:String, 
                                                      listeners:Vector.<DisplayObject>):Void
    {
        if (eventType == Event.ENTER_FRAME && object == this)
        {
            for (var i:Int=0, length:Int=mEnterFrameListeners.length; i<length; ++i)
                listeners[listeners.length] = mEnterFrameListeners[i]; // avoiding 'push' 
        }
        else
            super.getChildEventListeners(object, eventType, listeners);
    }
    
    // properties
    
    /** @private */
    public override function set width(value:Float):Void 
    { 
        throw new IllegalOperationError("Cannot set width of stage");
    }
    
    /** @private */
    public override function set height(value:Float):Void
    {
        throw new IllegalOperationError("Cannot set height of stage");
    }
    
    /** @private */
    public override function set x(value:Float):Void
    {
        throw new IllegalOperationError("Cannot set x-coordinate of stage");
    }
    
    /** @private */
    public override function set y(value:Float):Void
    {
        throw new IllegalOperationError("Cannot set y-coordinate of stage");
    }
    
    /** @private */
    public override function set scaleX(value:Float):Void
    {
        throw new IllegalOperationError("Cannot scale stage");
    }

    /** @private */
    public override function set scaleY(value:Float):Void
    {
        throw new IllegalOperationError("Cannot scale stage");
    }
    
    /** @private */
    public override function set rotation(value:Float):Void
    {
        throw new IllegalOperationError("Cannot rotate stage");
    }
    
    /** @private */
    public override function set skewX(value:Float):Void
    {
        throw new IllegalOperationError("Cannot skew stage");
    }
    
    /** @private */
    public override function set skewY(value:Float):Void
    {
        throw new IllegalOperationError("Cannot skew stage");
    }
    
    /** @private */
    public override function set filter(value:FragmentFilter):Void
    {
        throw new IllegalOperationError("Cannot add filter to stage. Add it to 'root' instead!");
    }
    
    /** The background color of the stage. */
    public function get color():UInt { return mColor; }
    public function set color(value:UInt):Void { mColor = value; }
    
    /** The width of the stage coordinate system. Change it to scale its contents relative
     *  to the <code>viewPort</code> property of the Starling object. */ 
    public function get stageWidth():Int { return mWidth; }
    public function set stageWidth(value:Int):Void { mWidth = value; }
    
    /** The height of the stage coordinate system. Change it to scale its contents relative
     *  to the <code>viewPort</code> property of the Starling object. */
    public function get stageHeight():Int { return mHeight; }
    public function set stageHeight(value:Int):Void { mHeight = value; }
}
}
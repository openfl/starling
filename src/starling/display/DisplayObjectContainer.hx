// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.errors.ArgumentError;
import openfl.errors.RangeError;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.Vector;

import starling.events.Event;
import starling.filters.FragmentFilter;
import starling.rendering.BatchToken;
import starling.rendering.Painter;
import starling.utils.MatrixUtil;
import starling.utils.Max;

/**
 *  A DisplayObjectContainer represents a collection of display objects.
 *  It is the base class of all display objects that act as a container for other objects. By 
 *  maintaining an ordered list of children, it defines the back-to-front positioning of the 
 *  children within the display tree.
 *  
 *  <p>A container does not a have size in itself. The width and height properties represent the 
 *  extents of its children. Changing those properties will scale all children accordingly.</p>
 *  
 *  <p>As this is an abstract class, you can't instantiate it directly, but have to 
 *  use a subclass instead. The most lightweight container class is "Sprite".</p>
 *  
 *  <strong>Adding and removing children</strong>
 *  
 *  <p>The class defines methods that allow you to add or remove children. When you add a child, 
 *  it will be added at the frontmost position, possibly occluding a child that was added 
 *  before. You can access the children via an index. The first child will have index 0, the 
 *  second child index 1, etc.</p> 
 *  
 *  Adding and removing objects from a container triggers non-bubbling events.
 *  
 *  <ul>
 *   <li><code>Event.ADDED</code>: the object was added to a parent.</li>
 *   <li><code>Event.ADDED_TO_STAGE</code>: the object was added to a parent that is 
 *       connected to the stage, thus becoming visible now.</li>
 *   <li><code>Event.REMOVED</code>: the object was removed from a parent.</li>
 *   <li><code>Event.REMOVED_FROM_STAGE</code>: the object was removed from a parent that 
 *       is connected to the stage, thus becoming invisible now.</li>
 *  </ul>
 *  
 *  Especially the <code>ADDED_TO_STAGE</code> event is very helpful, as it allows you to 
 *  automatically execute some logic (e.g. start an animation) when an object is rendered the 
 *  first time.
 *  
 *  @see Sprite
 *  @see DisplayObject
 */
class DisplayObjectContainer extends DisplayObject
{
    // members

    @:noCompletion private var __children:Vector<DisplayObject>;
    @:noCompletion private var __touchGroup:Bool;
    
    // helper objects
    private static var sHitTestMatrix:Matrix = new Matrix();
	private static var sHitTestPoint:Point = new Point();
	private static var sBoundsMatrix:Matrix = new Matrix();
	private static var sBoundsPoint:Point = new Point();
    private static var sBroadcastListeners:Vector<DisplayObject> = new Vector<DisplayObject>();
    private static var sSortBuffer:Vector<DisplayObject> = new Vector<DisplayObject>();
    private static var sCacheToken:BatchToken = new BatchToken();
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DisplayObjectContainer.prototype, {
            "numChildren": { get: untyped __js__ ("function () { return this.get_numChildren (); }") },
            "touchGroup": { get: untyped __js__ ("function () { return this.get_touchGroup (); }"), set: untyped __js__ ("function (v) { return this.set_touchGroup (v); }") },
        });
        
    }
    #end
    
    // construction
    
    /** @private */
    private function new()
    {
        super();

        __children = new Vector<DisplayObject>();
    }
    
    /** Disposes the resources of all children. */
    public override function dispose():Void
    {
        var i:Int = __children.length - 1;
        while (i >= 0)
        {
            __children[i].dispose();
            --i;
        }
        
        super.dispose();
    }
    
    // child management
    
    /** Adds a child to the container. It will be at the frontmost position. */
    public function addChild(child:DisplayObject):DisplayObject
    {
        return addChildAt(child, __children.length);
    }
    
    /** Adds a child to the container at a certain index. */
    public function addChildAt(child:DisplayObject, index:Int):DisplayObject
    {
        var numChildren:Int = __children.length;

        if (index >= 0 && index <= numChildren)
        {
            setRequiresRedraw();

            if (child.parent == this)
            {
                setChildIndex(child, index); // avoids dispatching events
            }
            else
            {
                __children.insertAt(index, child);

                child.removeFromParent();
                child.__setParent(this);
                child.dispatchEventWith(Event.ADDED, true);
                
                if (stage != null)
                {
                    var container:DisplayObjectContainer = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(child, DisplayObjectContainer) ? cast child : null;
                    if (container != null) container.broadcastEventWith(Event.ADDED_TO_STAGE);
                    else           child.dispatchEventWith(Event.ADDED_TO_STAGE);
                }
            }
            
            return child;
        }
        else
        {
            throw new RangeError("Invalid child index");
        }
    }
    
    /** Removes a child from the container. If the object is not a child, the method returns
     * <code>null</code>. If requested, the child will be disposed right away. */
    public function removeChild(child:DisplayObject, dispose:Bool=false):DisplayObject
    {
        var childIndex:Int = getChildIndex(child);
        if (childIndex != -1) return removeChildAt(childIndex, dispose);
        else return null;
    }
    
    /** Removes a child at a certain index. The index positions of any display objects above
     * the child are decreased by 1. If requested, the child will be disposed right away. */
    public function removeChildAt(index:Int, dispose:Bool=false):DisplayObject
    {
        if (index >= 0 && index < __children.length)
        {
            setRequiresRedraw();

            var child:DisplayObject = __children[index];
            child.dispatchEventWith(Event.REMOVED, true);
            
            if (stage != null)
            {
                var container:DisplayObjectContainer = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(child, DisplayObjectContainer) ? cast child : null;
                if (container != null) container.broadcastEventWith(Event.REMOVED_FROM_STAGE);
                else           child.dispatchEventWith(Event.REMOVED_FROM_STAGE);
            }
            
            child.__setParent(null);
            index = __children.indexOf(child); // index might have changed by event handler
            if (index >= 0) __children.removeAt(index);
            if (dispose) child.dispose();
            
            return child;
        }
        else
        {
            throw new RangeError("Invalid child index");
        }
    }
    
    /** Removes a range of children from the container (endIndex included). 
     * If no arguments are given, all children will be removed. */
    public function removeChildren(beginIndex:Int=0, endIndex:Int=-1, dispose:Bool=false):Void
    {
        if (endIndex < 0 || endIndex >= numChildren) 
            endIndex = numChildren - 1;
        
        var i:Int = beginIndex;
        while (i <= endIndex)
        {
            removeChildAt(beginIndex, dispose);
            ++i;
        }
    }

    /** Returns a child object at a certain index. If you pass a negative index,
     * '-1' will return the last child, '-2' the second to last child, etc. */
    public function getChildAt(index:Int):DisplayObject
    {
        var numChildren:Int = __children.length;

        if (index < 0)
            index = numChildren + index;

        if (index >= 0 && index < numChildren)
            return __children[index];
        else
            throw new RangeError("Invalid child index");
    }
    
    /** Returns a child object with a certain name (non-recursively). */
    public function getChildByName(name:String):DisplayObject
    {
        var numChildren:Int = __children.length;
        for (i in 0...numChildren)
            if (__children[i].name == name) return __children[i];

        return null;
    }
    
    /** Returns the index of a child within the container, or "-1" if it is not found. */
    public function getChildIndex(child:DisplayObject):Int
    {
        return __children.indexOf(child);
    }
    
    /** Moves a child to a certain index. Children at and after the replaced position move up.*/
    public function setChildIndex(child:DisplayObject, index:Int):Void
    {
        var oldIndex:Int = getChildIndex(child);
        if (oldIndex == index) return;
        if (oldIndex == -1) throw new ArgumentError("Not a child of this container");

        __children.removeAt(oldIndex);
        __children.insertAt(index, child);
        setRequiresRedraw();
    }
    
    /** Swaps the indexes of two children. */
    public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
    {
        var index1:Int = getChildIndex(child1);
        var index2:Int = getChildIndex(child2);
        if (index1 == -1 || index2 == -1) throw new ArgumentError("Not a child of this container");
        swapChildrenAt(index1, index2);
    }
    
    /** Swaps the indexes of two children. */
    public function swapChildrenAt(index1:Int, index2:Int):Void
    {
        var child1:DisplayObject = getChildAt(index1);
        var child2:DisplayObject = getChildAt(index2);
        __children[index1] = child2;
        __children[index2] = child1;
        setRequiresRedraw();
    }
    
    /** Sorts the children according to a given function (that works just like the sort function
     * of the Vector class). */
    public function sortChildren(compareFunction:DisplayObject->DisplayObject->Int):Void
    {
        sSortBuffer.length = __children.length;
        mergeSort(__children, compareFunction, 0, __children.length, sSortBuffer);
        sSortBuffer.length = 0;
        setRequiresRedraw();
    }
    
    /** Determines if a certain object is a child of the container (recursively). */
    public function contains(child:DisplayObject):Bool
    {
        while (child != null)
        {
            if (child == this) return true;
            else child = child.parent;
        }
        return false;
    }
    
    // other methods
    
    /** @inheritDoc */ 
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        if (out == null) out = new Rectangle();
        
        var numChildren:Int = __children.length;
        
        if (numChildren == 0)
        {
            getTransformationMatrix(targetSpace, sBoundsMatrix);
            MatrixUtil.transformCoords(sBoundsMatrix, 0.0, 0.0, sBoundsPoint);
            out.setTo(sBoundsPoint.x, sBoundsPoint.y, 0, 0);
        }
        else if (numChildren == 1)
        {
            __children[0].getBounds(targetSpace, out);
        }
        else
        {
            var minX:Float = Max.MAX_VALUE, maxX:Float = -Max.MAX_VALUE;
            var minY:Float = Max.MAX_VALUE, maxY:Float = -Max.MAX_VALUE;

            var i:Int = 0;
            for (i in 0...numChildren)
            {
                __children[i].getBounds(targetSpace, out);

                if (minX > out.x)      minX = out.x;
                if (maxX < out.right)  maxX = out.right;
                if (minY > out.y)      minY = out.y;
                if (maxY < out.bottom) maxY = out.bottom;
            }

            out.setTo(minX, minY, maxX - minX, maxY - minY);
        }
        
        return out;
    }

    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject
    {
        if (!visible || !touchable || !hitTestMask(localPoint)) return null;

        var target:DisplayObject = null;
        var localX:Float = localPoint.x;
        var localY:Float = localPoint.y;
        var numChildren:Int = __children.length;

        var child:DisplayObject;
        var i:Int = numChildren - 1;
        while (i >= 0) // front to back!
        {
            child = __children[i];
            if (child.isMask) {
                --i;
                continue;
            }

            sHitTestMatrix.copyFrom(child.transformationMatrix);
            sHitTestMatrix.invert();

            MatrixUtil.transformCoords(sHitTestMatrix, localX, localY, sHitTestPoint);
            target = child.hitTest(sHitTestPoint);

            if (target != null) return __touchGroup ? this : target;
            --i;
        }

        return null;
    }
    
    /** @inheritDoc */
    public override function render(painter:Painter):Void
    {
        var numChildren:Int = __children.length;
        var frameID:UInt = painter.frameID;
        var cacheEnabled:Bool = frameID != 0;
        var selfOrParentChanged:Bool = __lastParentOrSelfChangeFrameID == frameID;

        painter.pushState();

        var child:DisplayObject, filter:FragmentFilter, mask:DisplayObject;
        var pushToken:BatchToken, popToken:BatchToken;

        for (i in 0...numChildren)
        {
            child = __children[i];

            if (child.__hasVisibleArea)
            {
                if (i != 0)
                    painter.restoreState();

                if (selfOrParentChanged)
                    child.__lastParentOrSelfChangeFrameID = frameID;

                if (child.__lastParentOrSelfChangeFrameID != frameID &&
                    child.__lastChildChangeFrameID != frameID &&
                    child.__tokenFrameID == frameID - 1 && cacheEnabled)
                {
                    painter.fillToken(sCacheToken);
                    painter.drawFromCache(child.__pushToken, child.__popToken);
                    painter.fillToken(child.__popToken);

                    child.__pushToken.copyFrom(sCacheToken);
                }
                else
                {
                    pushToken = cacheEnabled ? child.__pushToken : null;
                    popToken  = cacheEnabled ? child.__popToken  : null;
                    filter    = child.__filter;
                    mask      = child.__mask;

                    painter.fillToken(pushToken);
                    painter.setStateTo(child.transformationMatrix, child.alpha, child.blendMode);

                    if (mask != null) painter.drawMask(mask, child);

                    if (filter != null) filter.render(painter);
                    else                child.render(painter);

                    if (mask != null) painter.eraseMask(mask, child);

                    painter.fillToken(popToken);
                }

                if (cacheEnabled)
                    child.__tokenFrameID = frameID;
            }
        }

        painter.popState();
    }

    /** Dispatches an event on all children (recursively). The event must not bubble. */
    public function broadcastEvent(event:Event):Void
    {
        if (event.bubbles)
            throw new ArgumentError("Broadcast of bubbling events is prohibited");
        
        // The event listeners might modify the display tree, which could make the loop crash. 
        // Thus, we collect them in a list and iterate over that list instead.
        // And since another listener could call this method internally, we have to take 
        // care that the static helper vector does not get corrupted.
        
        var fromIndex:Int = sBroadcastListeners.length;
        __getChildEventListeners(this, event.type, sBroadcastListeners);
        var toIndex:Int = sBroadcastListeners.length;
        
        for (i in fromIndex...toIndex)
            sBroadcastListeners[i].dispatchEvent(event);
        
        sBroadcastListeners.length = fromIndex;
    }
    
    /** Dispatches an event with the given parameters on all children (recursively). 
     * The method uses an internal pool of event objects to avoid allocations. */
    public function broadcastEventWith(eventType:String, data:Dynamic=null):Void
    {
        var event:Event = Event.fromPool(eventType, false, data);
        broadcastEvent(event);
        Event.toPool(event);
    }
    
    /** The number of children of this container. */
    public var numChildren(get, never):Int;
    private function get_numChildren():Int { return __children.length; }
    
    /** If a container is a 'touchGroup', it will act as a single touchable object.
     * Touch events will have the container as target, not the touched child.
     * (Similar to 'mouseChildren' in the classic display list, but with inverted logic.)
     * @default false */
    public var touchGroup(get, set):Bool;
    private function get_touchGroup():Bool { return __touchGroup; }
    private function set_touchGroup(value:Bool):Bool { return __touchGroup = value; }

    // helpers
    
    private static function mergeSort(input:Vector<DisplayObject>, compareFunc:DisplayObject->DisplayObject->Int, 
                                      startIndex:Int, length:Int, 
                                      buffer:Vector<DisplayObject>):Void
    {
        // This is a port of the C++ merge sort algorithm shown here:
        // http://www.cprogramming.com/tutorial/computersciencetheory/mergesort.html
        
        if (length > 1)
        {
            var i:Int = 0;
            var endIndex:Int = startIndex + length;
            var halfLength:Int = Std.int(length / 2);
            var l:Int = startIndex;              // current position in the left subvector
            var r:Int = startIndex + halfLength; // current position in the right subvector
            
            // sort each subvector
            mergeSort(input, compareFunc, startIndex, halfLength, buffer);
            mergeSort(input, compareFunc, startIndex + halfLength, length - halfLength, buffer);
            
            // merge the vectors, using the buffer vector for temporary storage
            for (i in 0...length)
            {
                // Check to see if any elements remain in the left vector; 
                // if so, we check if there are any elements left in the right vector;
                // if so, we compare them. Otherwise, we know that the merge must
                // take the element from the left vector. */
                if (l < startIndex + halfLength && 
                    (r == endIndex || compareFunc(input[l], input[r]) <= 0))
                {
                    buffer[i] = input[l];
                    l++;
                }
                else
                {
                    buffer[i] = input[r];
                    r++;
                }
            }
            
            // copy the sorted subvector back to the input
            for (i in startIndex...endIndex)
                input[i] = buffer[i - startIndex];
        }
    }

    /** @private */
    @:noCompletion private function __getChildEventListeners(object:DisplayObject, eventType:String, 
                                             listeners:Vector<DisplayObject>):Void
    {
        var container:DisplayObjectContainer = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(object, DisplayObjectContainer) ? cast object : null;
        if (object == null) return;
        
        if (object.hasEventListener(eventType))
            listeners[listeners.length] = object; // avoiding 'push'                
        
        if (container != null)
        {
            var children:Vector<DisplayObject> = container.__children;
            var numChildren:Int = children.length;
            
            for (i in 0...numChildren)
                __getChildEventListeners(children[i], eventType, listeners);
        }
    }
}
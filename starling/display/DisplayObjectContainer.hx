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
import flash.errors.ArgumentError;
import flash.errors.RangeError;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.system.Capabilities;
import starling.utils.ArrayUtil;
//import flash.utils.getQualifiedClassName;

import starling.core.RenderSupport;
import starling.errors.AbstractClassError;
import starling.events.Event;
import starling.filters.FragmentFilter;
import starling.utils.MatrixUtil;
import starling.utils.Max;
import starling.utils.SafeCast.safe_cast;

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

    private var mChildren:Array<DisplayObject>;
    private var mTouchGroup:Bool;
    
    /** Helper objects. */
    private static var sHelperMatrix:Matrix = new Matrix();
    private static var sHelperPoint:Point = new Point();
    private static var sBroadcastListeners:Array<DisplayObject> = new Array<DisplayObject>();
    private static var sSortBuffer:Array<DisplayObject> = new Array<DisplayObject>();
    
    // construction
    
    /** @private */
    public function new()
    {
        super();
        /*
        if (Capabilities.isDebugger &&
            Type.getClassName(this) == "starling.display::DisplayObjectContainer")
        {
            throw new AbstractClassError();
        }
        */
        
        mChildren = new Array<DisplayObject>();
    }
    
    /** Disposes the resources of all children. */
    public override function dispose():Void
    {
        //for (var i:Int=mChildren.length-1; i>=0; --i)
        var i:Int = mChildren.length - 1;
        while (i >= 0)
        {
            mChildren[i].dispose();
            --i;
        }
        
        super.dispose();
    }
    
    // child management
    
    /** Adds a child to the container. It will be at the frontmost position. */
    public function addChild(child:DisplayObject):DisplayObject
    {
        return addChildAt(child, mChildren.length);
    }
    
    /** Adds a child to the container at a certain index. */
    public function addChildAt(child:DisplayObject, index:Int):DisplayObject
    {
        var numChildren:Int = mChildren.length;

        if (index >= 0 && index <= numChildren)
        {
            if (child.parent == this)
            {
                setChildIndex(child, index); // avoids dispatching events
            }
            else
            {
                child.removeFromParent();

                if (index == numChildren) mChildren[numChildren] = child;
                else spliceChildren(index, 0, child);

                child.setParent(this);
                child.dispatchEventWith(Event.ADDED, true);
                
                if (stage != null)
                {
                    var container:DisplayObjectContainer = safe_cast(child, DisplayObjectContainer);
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
    
    /** Removes a child from the container. If the object is not a child, nothing happens. 
     *  If requested, the child will be disposed right away. */
    public function removeChild(child:DisplayObject, dispose:Bool=false):DisplayObject
    {
        var childIndex:Int = getChildIndex(child);
        if (childIndex != -1) removeChildAt(childIndex, dispose);
        return child;
    }
    
    /** Removes a child at a certain index. The index positions of any display objects above
     *  the child are decreased by 1. If requested, the child will be disposed right away. */
    public function removeChildAt(index:Int, dispose:Bool=false):DisplayObject
    {
        if (index >= 0 && index < mChildren.length)
        {
            var child:DisplayObject = mChildren[index];
            child.dispatchEventWith(Event.REMOVED, true);
            
            if (stage != null)
            {
                var container:DisplayObjectContainer = safe_cast(child, DisplayObjectContainer);
                if (container != null) container.broadcastEventWith(Event.REMOVED_FROM_STAGE);
                else           child.dispatchEventWith(Event.REMOVED_FROM_STAGE);
            }
            
            child.setParent(null);
            index = mChildren.indexOf(child); // index might have changed by event handler
            if (index >= 0) spliceChildren(index, 1);
            if (dispose) child.dispose();
            
            return child;
        }
        else
        {
            throw new RangeError("Invalid child index");
        }
    }
    
    /** Removes a range of children from the container (endIndex included). 
     *  If no arguments are given, all children will be removed. */
    public function removeChildren(beginIndex:Int=0, endIndex:Int=-1, dispose:Bool=false):Void
    {
        if (endIndex < 0 || endIndex >= numChildren) 
            endIndex = numChildren - 1;
        
        var i:Int = beginIndex;
        //for (var i:Int=beginIndex; i<=endIndex; ++i)
        while (i <= endIndex)
        {
            removeChildAt(beginIndex, dispose);
            ++i;
        }
    }

    /** Returns a child object at a certain index. If you pass a negative index,
     *  '-1' will return the last child, '-2' the second to last child, etc. */
    public function getChildAt(index:Int):DisplayObject
    {
        var numChildren:Int = mChildren.length;

        if (index < 0)
            index = numChildren + index;

        if (index >= 0 && index < numChildren)
            return mChildren[index];
        else
            throw new RangeError("Invalid child index");
    }
    
    /** Returns a child object with a certain name (non-recursively). */
    public function getChildByName(name:String):DisplayObject
    {
        var numChildren:Int = mChildren.length;
        for (i in 0 ... numChildren)
            if (mChildren[i].name == name) return mChildren[i];

        return null;
    }
    
    /** Returns the index of a child within the container, or "-1" if it is not found. */
    public function getChildIndex(child:DisplayObject):Int
    {
        return mChildren.indexOf(child);
    }
    
    /** Moves a child to a certain index. Children at and after the replaced position move up.*/
    public function setChildIndex(child:DisplayObject, index:Int):Void
    {
        var oldIndex:Int = getChildIndex(child);
        if (oldIndex == index) return;
        if (oldIndex == -1) throw new ArgumentError("Not a child of this container");
        spliceChildren(oldIndex, 1);
        spliceChildren(index, 0, child);
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
        mChildren[index1] = child2;
        mChildren[index2] = child1;
    }
    
    /** Sorts the children according to a given function (that works just like the sort function
     *  of the Vector class). */
    public function sortChildren(compareFunction:DisplayObject->DisplayObject->Int):Void
    {
        ArrayUtil.resize(sSortBuffer, mChildren.length);
        mergeSort(mChildren, compareFunction, 0, mChildren.length, sSortBuffer);
        ArrayUtil.clear(sSortBuffer);
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
    public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
    {
        if (resultRect == null) resultRect = new Rectangle();
        
        var numChildren:Int = mChildren.length;
        
        if (numChildren == 0)
        {
            getTransformationMatrix(targetSpace, sHelperMatrix);
            MatrixUtil.transformCoords(sHelperMatrix, 0.0, 0.0, sHelperPoint);
            resultRect.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
        }
        else if (numChildren == 1)
        {
            mChildren[0].getBounds(targetSpace, resultRect);
        }
        else
        {
            var minX:Float = Max.MAX_VALUE, maxX:Float = -Max.MAX_VALUE;
            var minY:Float = Max.MAX_VALUE, maxY:Float = -Max.MAX_VALUE;

            var i:Int = 0;
            for (i in 0 ... numChildren)
            {
                mChildren[i].getBounds(targetSpace, resultRect);

                if (minX > resultRect.x)      minX = resultRect.x;
                if (maxX < resultRect.right)  maxX = resultRect.right;
                if (minY > resultRect.y)      minY = resultRect.y;
                if (maxY < resultRect.bottom) maxY = resultRect.bottom;
            }
            
            resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
        }
        
        return resultRect;
    }

    /** @inheritDoc */
    public override function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
    {
        if (forTouch && (!visible || !touchable)) return null;
        if (!hitTestMask(localPoint)) return null;

        var target:DisplayObject = null;
        var localX:Float = localPoint.x;
        var localY:Float = localPoint.y;
        var numChildren:Int = mChildren.length;
        
        //for (var i:Int = numChildren - 1; i >= 0; --i) // front to back!
        var i:Int = numChildren - 1;
        while(i >= 0)
        {
            var child:DisplayObject = mChildren[i];
            if (child.isMask) continue;

            sHelperMatrix.copyFrom(child.transformationMatrix);
            sHelperMatrix.invert();

            MatrixUtil.transformCoords(sHelperMatrix, localX, localY, sHelperPoint);
            target = child.hitTest(sHelperPoint, forTouch);

            if (target != null) return forTouch && mTouchGroup ? this : target;
            --i;
        }

        return null;
    }
    
    /** @inheritDoc */
    public override function render(support:RenderSupport, parentAlpha:Float):Void
    {
        var alpha:Float = parentAlpha * this.alpha;
        var numChildren:Int = mChildren.length;
        var blendMode:String = support.blendMode;
        
        for (i in 0 ... numChildren)
        {
            var child:DisplayObject = mChildren[i];
            
            if (child.hasVisibleArea)
            {
                var filter:FragmentFilter = child.filter;
                var mask:DisplayObject = child.mask;

                support.pushMatrix();
                support.transformMatrix(child);
                support.blendMode = child.blendMode;

                if (mask != null) support.pushMask(mask);

                if (filter != null) filter.render(child, support, alpha);
                else        child.render(support, alpha);

                if (mask != null) support.popMask();
                
                support.blendMode = blendMode;
                support.popMatrix();
            }
        }
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
        getChildEventListeners(this, event.type, sBroadcastListeners);
        var toIndex:Int = sBroadcastListeners.length;
        
        for(i in fromIndex ... toIndex)
            sBroadcastListeners[i].dispatchEvent(event);
        
        ArrayUtil.resize(sBroadcastListeners, fromIndex);
    }
    
    /** Dispatches an event with the given parameters on all children (recursively). 
     *  The method uses an internal pool of event objects to avoid allocations. */
    public function broadcastEventWith(type:String, data:Dynamic=null):Void
    {
        var event:Event = Event.fromPool(type, false, data);
        broadcastEvent(event);
        Event.toPool(event);
    }
    
    /** The number of children of this container. */
    public var numChildren(get, never):Int;
    private function get_numChildren():Int { return mChildren.length; }
    
    /** If a container is a 'touchGroup', it will act as a single touchable object.
     *  Touch events will have the container as target, not the touched child.
     *  (Similar to 'mouseChildren' in the classic display list, but with inverted logic.)
     *  @default false */
    public var touchGroup(get, set):Bool;
    private function get_touchGroup():Bool { return mTouchGroup; }
    private function set_touchGroup(value:Bool):Bool { return mTouchGroup = value; }

    // helpers
    
    private static function mergeSort(input:Array<DisplayObject>, compareFunc:DisplayObject->DisplayObject->Int, 
                                      startIndex:Int, length:Int, 
                                      buffer:Array<DisplayObject>):Void
    {
        // This is a port of the C++ merge sort algorithm shown here:
        // http://www.cprogramming.com/tutorial/computersciencetheory/mergesort.html
        
        if (length <= 1) return;
        else
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
            for (i in 0 ... length)
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
            for (i in startIndex ... endIndex)
                input[i] = buffer[i - startIndex];
        }
    }

    /** Custom implementation of 'Vector.splice'. The native method always create temporary
     *  objects that have to be garbage collected. This implementation does not cause such
     *  issues. */
    private function spliceChildren(startIndex:Int, deleteCount:Int=Max.INT_MAX_VALUE,
                                    insertee:DisplayObject=null):Void
    {
        var vector:Array<DisplayObject> = mChildren;
        var oldLength:Int  = vector.length;

        if (startIndex < 0) startIndex += oldLength;
        if (startIndex < 0) startIndex = 0; else if (startIndex > oldLength) startIndex = oldLength;
        if (startIndex + deleteCount > oldLength) deleteCount = oldLength - startIndex;

        var i:Int;
        var insertCount:Int = insertee != null ? 1 : 0;
        var deltaLength:Int = insertCount - deleteCount;
        var newLength:UInt  = oldLength + deltaLength;
        var shiftCount:Int  = oldLength - startIndex - deleteCount;

        if (deltaLength < 0)
        {
            i = startIndex + insertCount;
            while (shiftCount != 0)
            {
                vector[i] = vector[i - deltaLength];
                --shiftCount; ++i;
            }
            ArrayUtil.resize(vector, newLength);
        }
        else if (deltaLength > 0)
        {
            i = 1;
            while (shiftCount != 0)
            {
                vector[newLength - i] = vector[oldLength - i];
                --shiftCount; ++i;
            }
            ArrayUtil.resize(vector, newLength);
        }

        if (insertee != null)
            vector[startIndex] = insertee;
    }

    /** @private */
    private function getChildEventListeners(object:DisplayObject, eventType:String, 
                                             listeners:Array<DisplayObject>):Void
    {
        var container:DisplayObjectContainer = safe_cast(object, DisplayObjectContainer);
        
        if (object.hasEventListener(eventType))
            listeners[listeners.length] = object; // avoiding 'push'                
        
        if (container != null)
        {
            var children:Array<DisplayObject> = container.mChildren;
            var numChildren:Int = children.length;
            
            for (i in 0 ... numChildren)
                getChildEventListeners(children[i], eventType, listeners);
        }
    }
}

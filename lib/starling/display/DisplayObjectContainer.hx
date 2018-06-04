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

@:jsRequire("starling/display/DisplayObjectContainer", "default")

extern class DisplayObjectContainer extends DisplayObject
{
    /** Disposes the resources of all children. */
    public override function dispose():Void;
    
    // child management
    
    /** Adds a child to the container. It will be at the frontmost position. */
    public function addChild(child:DisplayObject):DisplayObject;
    
    /** Adds a child to the container at a certain index. */
    public function addChildAt(child:DisplayObject, index:Int):DisplayObject;
    
    /** Removes a child from the container. If the object is not a child, the method returns
     * <code>null</code>. If requested, the child will be disposed right away. */
    public function removeChild(child:DisplayObject, dispose:Bool=false):DisplayObject;
    
    /** Removes a child at a certain index. The index positions of any display objects above
     * the child are decreased by 1. If requested, the child will be disposed right away. */
    public function removeChildAt(index:Int, dispose:Bool=false):DisplayObject;
    
    /** Removes a range of children from the container (endIndex included). 
     * If no arguments are given, all children will be removed. */
    public function removeChildren(beginIndex:Int=0, endIndex:Int=-1, dispose:Bool=false):Void;

    /** Returns a child object at a certain index. If you pass a negative index,
     * '-1' will return the last child, '-2' the second to last child, etc. */
    public function getChildAt(index:Int):DisplayObject;
    
    /** Returns a child object with a certain name (non-recursively). */
    public function getChildByName(name:String):DisplayObject;
    
    /** Returns the index of a child within the container, or "-1" if it is not found. */
    public function getChildIndex(child:DisplayObject):Int;
    
    /** Moves a child to a certain index. Children at and after the replaced position move up.*/
    public function setChildIndex(child:DisplayObject, index:Int):Void;
    
    /** Swaps the indexes of two children. */
    public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void;
    
    /** Swaps the indexes of two children. */
    public function swapChildrenAt(index1:Int, index2:Int):Void;
    
    /** Sorts the children according to a given function (that works just like the sort function
     * of the Vector class). */
    public function sortChildren(compareFunction:DisplayObject->DisplayObject->Int):Void;
    
    /** Determines if a certain object is a child of the container (recursively). */
    public function contains(child:DisplayObject):Bool;
    
    // other methods
    
    /** @inheritDoc */ 
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;

    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject;
    
    /** @inheritDoc */
    public override function render(painter:Painter):Void;

    /** Dispatches an event on all children (recursively). The event must not bubble. */
    public function broadcastEvent(event:Event):Void;
    
    /** Dispatches an event with the given parameters on all children (recursively). 
     * The method uses an internal pool of event objects to avoid allocations. */
    public function broadcastEventWith(eventType:String, data:Dynamic=null):Void;
    
    /** The number of children of this container. */
    public var numChildren(get, never):Int;
    private function get_numChildren():Int;
    
    /** If a container is a 'touchGroup', it will act as a single touchable object.
     * Touch events will have the container as target, not the touched child.
     * (Similar to 'mouseChildren' in the classic display list, but with inverted logic.)
     * @default false */
    public var touchGroup(get, set):Bool;
    private function get_touchGroup():Bool;
    private function set_touchGroup(value:Bool):Bool;
}
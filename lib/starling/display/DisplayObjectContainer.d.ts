import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import Event from "./../events/Event";
import Painter from "./../rendering/Painter";
import DisplayObject from "./DisplayObject";

declare namespace starling.display
{
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
	export class DisplayObjectContainer extends DisplayObject
	{
		/** Disposes the resources of all children. */
		public /*override*/ dispose():void;
		
		// child management
		
		/** Adds a child to the container. It will be at the frontmost position. */
		public addChild(child:DisplayObject):DisplayObject;
		
		/** Adds a child to the container at a certain index. */
		public addChildAt(child:DisplayObject, index:number):DisplayObject;
		
		/** Removes a child from the container. If the object is not a child, the method returns
		 * <code>null</code>. If requested, the child will be disposed right away. */
		public removeChild(child:DisplayObject, dispose?:boolean):DisplayObject;
		
		/** Removes a child at a certain index. The index positions of any display objects above
		 * the child are decreased by 1. If requested, the child will be disposed right away. */
		public removeChildAt(index:number, dispose?:boolean):DisplayObject;
		
		/** Removes a range of children from the container (endIndex included). 
		 * If no arguments are given, all children will be removed. */
		public removeChildren(beginIndex?:number, endIndex?:number, dispose?:boolean):void;
	
		/** Returns a child object at a certain index. If you pass a negative index,
		 * '-1' will return the last child, '-2' the second to last child, etc. */
		public getChildAt(index:number):DisplayObject;
		
		/** Returns a child object with a certain name (non-recursively). */
		public getChildByName(name:string):DisplayObject;
		
		/** Returns the index of a child within the container, or "-1" if it is not found. */
		public getChildIndex(child:DisplayObject):number;
		
		/** Moves a child to a certain index. Children at and after the replaced position move up.*/
		public setChildIndex(child:DisplayObject, index:number):void;
		
		/** Swaps the indexes of two children. */
		public swapChildren(child1:DisplayObject, child2:DisplayObject):void;
		
		/** Swaps the indexes of two children. */
		public swapChildrenAt(index1:number, index2:number):void;
		
		/** Sorts the children according to a given (that works just like the sort function
		 * of the Vector class). */
		public sortChildren(compareFunction:(DisplayObject, DisplayObject)=>number):void;
		
		/** Determines if a certain object is a child of the container (recursively). */
		public contains(child:DisplayObject):boolean;
		
		// other methods
		
		/** @inheritDoc */ 
		public /*override*/ getBounds(targetSpace:DisplayObject, out?:Rectangle):Rectangle;
	
		/** @inheritDoc */
		public /*override*/ hitTest(localPoint:Point):DisplayObject;
		
		/** @inheritDoc */
		public /*override*/ render(painter:Painter):void;
	
		/** Dispatches an event on all children (recursively). The event must not bubble. */
		public broadcastEvent(event:Event):void;
		
		/** Dispatches an event with the given parameters on all children (recursively). 
		 * The method uses an internal pool of event objects to avoid allocations. */
		public broadcastEventWith(eventType:string, data?:any):void;
		
		/** The number of children of this container. */
		public readonly numChildren:number;
		protected get_numChildren():number;
		
		/** If a container is a 'touchGroup', it will act as a single touchable object.
		 * Touch events will have the container as target, not the touched child.
		 * (Similar to 'mouseChildren' in the classic display list, but with inverted logic.)
		 * @default false */
		public touchGroup:boolean;
		protected get_touchGroup():boolean;
		protected set_touchGroup(value:boolean):boolean;
	}
}

export default starling.display.DisplayObjectContainer;
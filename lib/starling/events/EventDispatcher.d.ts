import ArgumentError from "openfl/errors/ArgumentError";
import Vector from "openfl/Vector";
import DisplayObject from "./../../starling/display/DisplayObject";
import Event from "./../../starling/events/Event";

declare namespace starling.events
{
	/** The EventDispatcher class is the base class for all classes that dispatch events. 
	 *  This is the Starling version of the Flash class with the same name. 
	 *  
	 *  <p>The event mechanism is a key feature of Starling's architecture. Objects can communicate 
	 *  with each other through events. Compared the the Flash event system, Starling's event system
	 *  was simplified. The main difference is that Starling events have no "Capture" phase.
	 *  They are simply dispatched at the target and may optionally bubble up. They cannot move 
	 *  in the opposite direction.</p>  
	 *  
	 *  <p>As in the conventional Flash classes, display objects inherit from EventDispatcher 
	 *  and can thus dispatch events. Beware, though, that the Starling event classes are 
	 *  <em>not compatible with Flash events:</em> Starling display objects dispatch 
	 *  Starling events, which will bubble along Starling display objects - but they cannot 
	 *  dispatch Flash events or bubble along Flash display objects.</p>
	 *  
	 *  @see Event
	 *  @see starling.display.DisplayObject DisplayObject
	 */
	export class EventDispatcher
	{
		/** Creates an EventDispatcher. */
		public constructor();
		
		/** Registers an event listener at a certain object. */
		public addEventListener(type:string, listener:Function):void;
		
		/** Removes an event listener from the object. */
		public removeEventListener(type:string, listener:Function):void;
		
		/** Removes all event listeners with a certain type, or all of them if type is null. 
		 * Be careful when removing all event listeners: you never know who else was listening. */
		public removeEventListeners(type?:string):void;
		
		/** Dispatches an event to all objects that have registered listeners for its type. 
		 * If an event with enabled 'bubble' property is dispatched to a display object, it will 
		 * travel up along the line of parents, until it either hits the root object or someone
		 * stops its propagation manually. */
		public dispatchEvent(event:Event):void;
		
		/** Dispatches an event with the given parameters to all objects that have registered 
		 * listeners for the given type. The method uses an internal pool of event objects to 
		 * avoid allocations. */
		public dispatchEventWith(type:string, bubbles?:boolean, data?:any):void;
		
		/** If called with one argument, figures out if there are any listeners registered for
		 * the given event type. If called with two arguments, also determines if a specific
		 * listener is registered. */
		public hasEventListener(type:string, listener?:any):boolean;
	}
}

export default starling.events.EventDispatcher;
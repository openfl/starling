import Event from "./../../starling/events/Event";
import Vector from "openfl/Vector";
import EventDispatcher from "./../../starling/events/EventDispatcher";
import DisplayObject from "./../display/DisplayObject";

declare namespace starling.events
{
	/** A TouchEvent is triggered either by touch or mouse input.  
	 *  
	 *  <p>In Starling, both touch events and mouse events are handled through the same class: 
	 *  TouchEvent. To process user input from a touch screen or the mouse, you have to register
	 *  an event listener for events of the type <code>TouchEvent.TOUCH</code>. This is the only
	 *  event type you need to handle; the long list of mouse event types as they are used in
	 *  conventional Flash are mapped to so-called "TouchPhases" instead.</p> 
	 * 
	 *  <p>The difference between mouse input and touch input is that</p>
	 *  
	 *  <ul>
	 *    <li>only one mouse cursor can be present at a given moment and</li>
	 *    <li>only the mouse can "hover" over an object without a pressed button.</li>
	 *  </ul> 
	 *  
	 *  <strong>Which objects receive touch events?</strong>
	 * 
	 *  <p>In Starling, any display object receives touch events, as long as the  
	 *  <code>touchable</code> property of the object and its parents is enabled. There 
	 *  is no "InteractiveObject" class in Starling.</p>
	 *  
	 *  <strong>How to work with individual touches</strong>
	 *  
	 *  <p>The event contains a list of all touches that are currently present. Each individual
	 *  touch is stored in an object of type "Touch". Since you are normally only interested in 
	 *  the touches that occurred on top of certain objects, you can query the event for touches
	 *  with a specific target:</p>
	 * 
	 *  <code>touches:Vector.&lt;Touch&gt; = touchEvent.getTouches(this);</code>
	 *  
	 *  <p>This will return all touches of "this" or one of its children. When you are not using 
	 *  multitouch, you can also access the touch object directly, like this:</p>
	 * 
	 *  <code>touch:Touch = touchEvent.getTouch(this);</code>
	 *  
	 *  @see Touch
	 *  @see TouchPhase
	 */
	export class TouchEvent extends Event
	{
		/** Event type for touch or mouse input. */
		public static TOUCH:string;
	
		/** Creates a new TouchEvent instance. */
		public constructor(type:string, touches?:Vector<Touch>, shiftKey?:boolean,
							 ctrlKey?:boolean, bubbles?:boolean);
		
		/** Returns a list of touches that originated over a certain target. If you pass an
		 * <code>out</code>-vector, the touches will be added to this vector instead of creating
		 * a new object. */
		public getTouches(target:DisplayObject, phase?:string,
									out?:Vector<Touch>):Vector<Touch>;
		
		/** Returns a touch that originated over a certain target. 
		 * 
		 * @param target   The object that was touched; may also be a parent of the actual
		 *                 touch-target.
		 * @param phase    The phase the touch must be in, or null if you don't care.
		 * @param id       The ID of the requested touch, or -1 if you don't care.
		 */
		public getTouch(target:DisplayObject, phase?:string, id?:number):Touch;
		
		/** Indicates if a target is currently being touched or hovered over. */
		public interactsWith(target:DisplayObject):boolean;
		
		// custom dispatching
		
		/** @private
		 * Dispatches the event along a custom bubble chain. During the lifetime of the event,
		 * each object is visited only once. */
		public dispatch(chain:Vector<EventDispatcher>):void;
		
		// properties
		
		/** The time the event occurred (in seconds since application launch). */
		public readonly timestamp:number;
		protected get_timestamp():number;
		
		/** All touches that are currently available. */
		public readonly touches:Vector<Touch>;
		protected get_touches():Vector<Touch>;
		
		/** Indicates if the shift key was pressed when the event occurred. */
		public readonly shiftKey:boolean;
		protected get_shiftKey():boolean;
		
		/** Indicates if the ctrl key was pressed when the event occurred. (Mac OS: Cmd or Ctrl) */
		public readonly ctrlKey:boolean;
		protected get_ctrlKey():boolean;
	}
}

export default starling.events.TouchEvent;
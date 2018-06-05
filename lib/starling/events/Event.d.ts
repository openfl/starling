import StringUtil from "./../../starling/utils/StringUtil";
import Vector from "openfl/Vector";
import EventDispatcher from "./EventDispatcher";

declare namespace starling.events
{
	/** Event objects are passed as parameters to event listeners when an event occurs.  
	 *  This is Starling's version of the Flash Event class. 
	 *
	 *  <p>EventDispatchers create instances of this class and send them to registered listeners. 
	 *  An event object contains information that characterizes an event, most importantly the 
	 *  event type and if the event bubbles. The target of an event is the object that 
	 *  dispatched it.</p>
	 * 
	 *  <p>For some event types, this information is sufficient; other events may need additional 
	 *  information to be carried to the listener. In that case, you can subclass "Event" and add 
	 *  properties with all the information you require. The "EnterFrameEvent" is an example for 
	 *  this practice; it adds a property about the time that has passed since the last frame.</p>
	 * 
	 *  <p>Furthermore, the event class contains methods that can stop the event from being 
	 *  processed by other listeners - either completely or at the next bubble stage.</p>
	 * 
	 *  @see EventDispatcher
	 */
	export class Event
	{
		/** Event type for a display object that is added to a parent. */
		public static ADDED:string;
		/** Event type for a display object that is added to the stage */
		public static ADDED_TO_STAGE:string;
		/** Event type for a display object that is entering a new frame. */
		public static ENTER_FRAME:string;
		/** Event type for a display object that is removed from its parent. */
		public static REMOVED:string;
		/** Event type for a display object that is removed from the stage. */
		public static REMOVED_FROM_STAGE:string;
		/** Event type for a triggered button. */
		public static TRIGGERED:string;
		/** Event type for a resized Flash Player. */
		public static RESIZE:string;
		/** Event type that may be used whenever something finishes. */
		public static COMPLETE:string;
		/** Event type for a (re)created stage3D rendering context. */
		public static CONTEXT3D_CREATE:string;
		/** Event type that is dispatched by the Starling instance directly before rendering. */
		public static RENDER:string;
		/** Event type that indicates that the root DisplayObject has been created. */
		public static ROOT_CREATED:string;
		/** Event type for an animated object that requests to be removed from the juggler. */
		public static REMOVE_FROM_JUGGLER:string;
		/** Event type that is dispatched by the AssetManager after a context loss. */
		public static TEXTURES_RESTORED:string;
		/** Event type that is dispatched by the AssetManager when a file/url cannot be loaded. */
		public static IO_ERROR:string;
		/** Event type that is dispatched by the AssetManager when a file/url cannot be loaded. */
		public static SECURITY_ERROR:string;
		/** Event type that is dispatched by the AssetManager when an xml or json file couldn't
		 * be parsed. */
		public static PARSE_ERROR:string;
		/** Event type that is dispatched by the Starling instance when it encounters a problem
		 * from which it cannot recover, e.g. a lost device context. */
		public static FATAL_ERROR:string;
	
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static CHANGE:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static CANCEL:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static SCROLL:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static OPEN:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static CLOSE:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static SELECT:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static READY:string;
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static UPDATE:string;
	
		/** Creates an event object that can be passed to listeners. */
		public constructor(type:string, bubbles?:boolean, data?:any);
		
		/** Prevents listeners at the next bubble stage from receiving the event. */
		public stopPropagation():void;
		
		/** Prevents any other listeners from receiving the event. */
		public stopImmediatePropagation():void;
		
		/** Returns a description of the event, containing type and bubble information. */
		public toString():string;
		
		/** Indicates if event will bubble. */
		public readonly bubbles:boolean;
		
		/** The object that dispatched the event. */
		public readonly target:EventDispatcher;
		
		/** The object the event is currently bubbling at. */
		public readonly currentTarget:EventDispatcher;
		
		/** A string that identifies the event. */
		public readonly type:string;
		
		/** Arbitrary data that is attached to the event. */
		public readonly data:any;
	}
}

export default starling.events.Event;
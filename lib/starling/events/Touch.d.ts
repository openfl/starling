import Point from "openfl/geom/Point";
import StringUtil from "./../../starling/utils/StringUtil";
import Vector from "openfl/Vector";
import DisplayObject from "./../display/DisplayObject";

declare namespace starling.events
{
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
	export class Touch
	{
		/** Creates a new Touch object. */
		public constructor(id:number);
		
		/** Converts the current location of a touch to the local coordinate system of a display 
		 * object. If you pass an <code>out</code>-point, the result will be stored in this point
		 * instead of creating a new object.*/
		public getLocation(space:DisplayObject, out?:Point):Point;
		
		/** Converts the previous location of a touch to the local coordinate system of a display 
		 * object. If you pass an <code>out</code>-point, the result will be stored in this point
		 * instead of creating a new object.*/
		public getPreviousLocation(space:DisplayObject, out?:Point):Point;
		
		/** Returns the movement of the touch between the current and previous location. 
		 * If you pass an <code>out</code>-point, the result will be stored in this point instead
		 * of creating a new object. */ 
		public getMovement(space:DisplayObject, out?:Point):Point;
		
		/** Indicates if the target or one of its children is touched. */ 
		public isTouching(target:DisplayObject):boolean;
		
		/** Returns a description of the object. */
		public toString():string;
		
		/** Creates a clone of the Touch object. */
		public clone():Touch;
		
		// properties
		
		/** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
		public readonly id:number;
		protected get_id():number;
		
		/** The previous x-position of the touch in stage coordinates. */
		public readonly previousGlobalX:number;
		protected get_previousGlobalX():number;
		
		/** The previous y-position of the touch in stage coordinates. */
		public readonly previousGlobalY:number;
		protected get_previousGlobalY():number;
	
		/** The x-position of the touch in stage coordinates. If you change this value,
		 * the previous one will be moved to "previousGlobalX". */
		public globalX:number;
		protected get_globalX():number;
		protected set_globalX(value:number):number;
	
		/** The y-position of the touch in stage coordinates. If you change this value,
		 * the previous one will be moved to "previousGlobalY". */
		public globalY:number;
		protected get_globalY():number;
		protected set_globalY(value:number):number;
		
		/** The number of taps the finger made in a short amount of time. Use this to detect 
		 * double-taps / double-clicks, etc. */ 
		public tapCount:number;
		protected get_tapCount():number;
		protected set_tapCount(value:number):number;
		
		/** The current phase the touch is in. @see TouchPhase */
		public phase:string;
		protected get_phase():string;
		protected set_phase(value:string):string;
		
		/** The display object at which the touch occurred. */
		public target:DisplayObject;
		protected get_target():DisplayObject;
		protected set_target(value:DisplayObject):DisplayObject;
		
		/** The moment the touch occurred (in seconds since application start). */
		public timestamp:number;
		protected get_timestamp():number;
		protected set_timestamp(value:number):number;
		
		/** A value between 0.0 and 1.0 indicating force of the contact with the device. 
		 * If the device does not support detecting the pressure, the value is 1.0. */ 
		public pressure:number;
		protected get_pressure():number;
		protected set_pressure(value:number):number;
		
		/** Width of the contact area. 
		 * If the device does not support detecting the pressure, the value is 1.0. */
		public width:number;
		protected get_width():number;
		protected set_width(value:number):number;
		
		/** Height of the contact area. 
		 * If the device does not support detecting the pressure, the value is 1.0. */
		public height:number;
		protected get_height():number;
		protected set_height(value:number):number;
	
		/** Indicates if the touch has been cancelled, which may happen when the app moves into
		 * the background ('Event.DEACTIVATE'). @default false */
		public cancelled:boolean;
		protected get_cancelled():boolean;
		protected set_cancelled(value:boolean):boolean;
	}
}

export default starling.events.Touch;
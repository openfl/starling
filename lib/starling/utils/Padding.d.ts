import EventDispatcher from "./../../starling/events/EventDispatcher";

declare namespace starling.utils
{
	/** Dispatched when any property of the instance changes. */
	// @:meta(Event(name="change", type="starling.events.Event"))
	
	/** The padding class stores one number for each of four directions,
	 *  thus describing the padding around a 2D object. */
	export class Padding extends EventDispatcher
	{
		/** Creates a new instance with the given properties. */
		public constructor(left?:number, right?:number, top?:number, bottom?:number);
	
		/** Sets all four values at once. */
		public setTo(left?:number, right?:number, top?:number, bottom?:number):void;
	
		/** Sets all four sides to the same value. */
		public setToUniform(value:number):void;
	
		/** Sets left and right to <code>horizontal</code>, top and bottom to <code>vertical</code>. */
		public setToSymmetric(horizontal:number, vertical:number):void;
	
		/** Copies all properties from another Padding instance.
			*  Pass <code>null</code> to reset all values to zero. */
		public copyFrom(padding:Padding):void;
	
		/** Creates a new instance with the exact same values. */
		public clone():Padding;
	
		/** The padding on the left side. */
		public left:number;
		protected get_left():number;
		protected set_left(value:number):number;
	
		/** The padding on the right side. */
		public right:number;
		protected get_right():number;
		protected set_right(value:number):number;
	
		/** The padding towards the top. */
		public top:number;
		protected get_top():number;
		protected set_top(value:number):number;
	
		/** The padding towards the bottom. */
		public bottom:number;
		protected get_bottom():number;
		protected set_bottom(value:number):number;
	}
}

export default starling.utils.Padding;
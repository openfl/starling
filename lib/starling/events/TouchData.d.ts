declare namespace starling.events
{
	/** Stores the information about raw touches in a pool of object instances.
	 *
	 *  <p>This class is purely for internal use of the TouchProcessor.</p>
	 */
	export class TouchData
	{
		/** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
		public readonly id:number;
		
		/** The current phase the touch is in. @see TouchPhase */
		public readonly phase:number;
		
		/** The x-position of the touch in stage coordinates. */
		public readonly globalX:number;
		
		/** The y-position of the touch in stage coordinates. */
		public readonly globalY:number;
		
		/** A value between 0.0 and 1.0 indicating force of the contact with the device.
		 *  If the device does not support detecting the pressure, the value is 1.0. */
		public readonly pressure:number;
		
		/** Width of the contact area.
		 *  If the device does not support detecting the pressure, the value is 1.0. */
		public readonly width:number;
		
		/** Height of the contact area.
		 *  If the device does not support detecting the pressure, the value is 1.0. */
		public readonly height:number;

		/** Creates a new TouchData instance with the given properties or returns one from
			*  the object pool. */
		public static fromPool(touchID:number, phase:string, globalX:number, globalY:number,
										pressure:number=1.0, width:number=1.0, height:number=1.0):TouchData;

		/** Moves an instance back into the pool. */
		public static toPool(rawTouch:TouchData):void;
	}
}

export default starling.events.TouchData;
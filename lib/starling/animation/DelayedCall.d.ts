import IAnimatable from "./../../starling/animation/IAnimatable";
import EventDispatcher from "./../../starling/events/EventDispatcher";
import Vector from "openfl/Vector";

declare namespace starling.animation
{
	/** A DelayedCall allows you to execute a method after a certain time has passed. Since it 
	 *  implements the IAnimatable interface, it can be added to a juggler. In most cases, you 
	 *  do not have to use this class directly; the juggler class contains a method to delay
	 *  calls directly. 
	 * 
	 *  <p>DelayedCall dispatches an Event of type 'Event.REMOVE_FROM_JUGGLER' when it is finished,
	 *  so that the juggler automatically removes it when its no longer needed.</p>
	 * 
	 *  @see Juggler
	 */
	export class DelayedCall extends EventDispatcher implements IAnimatable
	{
		/** Creates a delayed call. */
		public constructor(callback:Function, delay:number, args?:Array<any>)
		
		/** Resets the delayed call to its default values, which is useful for pooling. */
		public reset(callback:Function, delay:number, args?:Array<any>):DelayedCall
		
		/** @inheritDoc */
		public advanceTime(time:number):void

		/** Advances the delayed call so that it is executed right away. If 'repeatCount' is
		 * anything else than '1', this method will complete only the current iteration. */
		public complete():void
		
		/** Indicates if enough time has passed, and the call has already been executed. */
		public readonly isComplete:boolean;
		protected get_isComplete():boolean;
		
		/** The time for which calls will be delayed (in seconds). */
		public readonly totalTime:number;
		protected get_totalTime():number;
		
		/** The time that has already passed (in seconds). */
		public readonly currentTime:number;
		protected get_currentTime():number;
		
		/** The number of times the call will be repeated. 
		 * Set to '0' to repeat indefinitely. @default 1 */
		public repeatCount:number;
		protected get_repeatCount():number;
		protected set_repeatCount(value:number):number;
		
		/** The callback that will be executed when the time is up. */
		public readonly callback:Function;
		protected get_callback():Function;
	
		/** The arguments that the callback will be executed with.
			*  Beware: not a copy, but the actual object! */
		public readonly arguments:Array<any>;
		protected get_arguments():Array<any>;
	}
}

export default starling.animation.DelayedCall;
declare namespace starling.animation
{
	/**  The IAnimatable interface describes objects that are animated depending on the passed time. 
	 *   Any object that implements this interface can be added to a juggler.
	 *   
	 *   <p>When an object should no longer be animated, it has to be removed from the juggler. 
	 *   To do this, you can manually remove it via the method <code>juggler.remove(object)</code>,
	 *   or the object can request to be removed by dispatching a Starling event with the type
	 *   <code>Event.REMOVE_FROM_JUGGLER</code>. The "Tween" class is an example of a class that
	 *   dispatches such an event; you don't have to remove tweens manually from the juggler.</p> 
	 *   
	 *   @see Juggler
	 *   @see Tween
	 */
	export class IAnimatable
	{
		/** Advance the time by a number of seconds. @param time in seconds. */
		advanceTime(time:number):void;
	}
}

export default starling.animation.IAnimatable;
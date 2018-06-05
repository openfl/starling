import IAnimatable from "./../../starling/animation/IAnimatable";
import EventDispatcher from "./../../starling/events/EventDispatcher";
import Color from "./../../starling/utils/Color";
import Transitions from "./../../starling/animation/Transitions";

declare namespace starling.animation
{
	/** A Tween animates numeric properties of objects. It uses different transition functions
	 *  to give the animations various styles.
	 *  
	 *  <p>The primary use of this class is to do standard animations like movement, fading, 
	 *  rotation, etc. But there are no limits on what to animate; as long as the property you want
	 *  to animate is numeric (<code>int, uint, Number</code>), the tween can handle it. For a list 
	 *  of available Transition types, look at the "Transitions" class.</p> 
	 *  
	 *  <p>Here is an example of a tween that moves an object to the right, rotates it, and 
	 *  fades it out:</p>
	 *  
	 *  <listing>
	 *  tween:Tween = new Tween(object, 2.0, Transitions.EASE_IN_OUT);
	 *  tween.animate("x", object.x + 50);
	 *  tween.animate("rotation", deg2rad(45));
	 *  tween.fadeTo(0);    // equivalent to 'animate("alpha", 0)'
	 *  Starling.juggler.add(tween);</listing> 
	 *  
	 *  <p>Note that the object is added to a juggler at the end of this sample. That's because a 
	 *  tween will only be executed if its "advanceTime" method is executed regularly - the 
	 *  juggler will do that for you, and will remove the tween when it is finished.</p>
	 *  
	 *  @see Juggler
	 *  @see Transitions
	 */ 
	export class Tween extends EventDispatcher implements IAnimatable
	{
		/** Creates a tween with a target, duration (in seconds) and a transition function.
		 * @param target the object that you want to animate
		 * @param time the duration of the Tween (in seconds)
		 * @param transition can be either a String (e.g. one of the constants defined in the
		 *        Transitions class) or a function. Look up the 'Transitions' class for a   
		 *        documentation about the required signature. */ 
		public constructor(target:any, time:number, transition?:any);
	
		/** Resets the tween to its default values. Useful for pooling tweens. */
		public reset(target:any, time:number, transition?:any):Tween;
		
		/** Animates the property of the target to a certain value. You can call this method
		 * multiple times on one tween.
		 *
		 * <p>Some property types are handled in a special way:</p>
		 * <ul>
		 *   <li>If the property contains the string <code>color</code> or <code>Color</code>,
		 *       it will be treated as an unsigned integer with a color value
		 *       (e.g. <code>0xff0000</code> for red). Each color channel will be animated
		 *       individually.</li>
		 *   <li>The same happens if you append the string <code>#rgb</code> to the name.</li>
		 *   <li>If you append <code>#rad</code>, the property is treated as an angle in radians,
		 *       making sure it always uses the shortest possible arc for the rotation.</li>
		 *   <li>The string <code>#deg</code> does the same for angles in degrees.</li>
		 * </ul>
		 */
		public animate(property:string, endValue:number):void;
	
		/** Animates the 'scaleX' and 'scaleY' properties of an object simultaneously. */
		public scaleTo(factor:number):void;
		
		/** Animates the 'x' and 'y' properties of an object simultaneously. */
		public moveTo(x:number, y:number):void;
		
		/** Animates the 'alpha' property of an object to a certain target value. */ 
		public fadeTo(alpha:number):void;
	
		/** Animates the 'rotation' property of an object to a certain target value, using the
		 * smallest possible arc. 'type' may be either 'rad' or 'deg', depending on the unit of
		 * measurement. */
		public rotateTo(angle:number, type?:string):void;
		
		/** @inheritDoc */
		public advanceTime(time:number):void;
		
		/** The end value a certain property is animated to. Throws an ArgumentError if the 
		 * property is not being animated. */
		public getEndValue(property:string):number;
	
		/** Indicates if a property with the given name is being animated by this tween. */
		public animatesProperty(property:string):boolean;
		
		/** Indicates if the tween is finished. */
		public readonly isComplete:boolean;
		protected get_isComplete():boolean;
		
		/** The target object that is animated. */
		public readonly target:any;
		protected get_target():any;
		
		/** The transition method used for the animation. @see Transitions */
		public transition:string;
		protected get_transition():string;
		protected set_transition(value:string):string;
		
		/** The actual transition used for the animation. */
		public transitionFunc:(number)=>number;
		protected get_transitionFunc():(number)=>number;
		protected set_transitionFunc(value:(number)=>number):(number)=>number;
		
		/** The total time the tween will take per repetition (in seconds). */
		public readonly totalTime:number;
		protected get_totalTime():number;
		
		/** The time that has passed since the tween was created (in seconds). */
		public readonly currentTime:number;
		protected get_currentTime():number;
		
		/** The current progress between 0 and 1, as calculated by the transition function. */
		public readonly progress:number;
		protected get_progress():number;
		
		/** The delay before the tween is started (in seconds). @default 0 */
		public delay:number;
		protected get_delay():number;
		protected set_delay(value:number):number;
		
		/** The number of times the tween will be executed. 
		 * Set to '0' to tween indefinitely. @default 1 */
		public repeatCount:number;
		protected get_repeatCount():number;
		protected set_repeatCount(value:number):number;
		
		/** The amount of time to wait between repeat cycles (in seconds). @default 0 */
		public repeatDelay:number;
		protected get_repeatDelay():number;
		protected set_repeatDelay(value:number):number;
		
		/** Indicates if the tween should be reversed when it is repeating. If enabled, 
		 * every second repetition will be reversed. @default false */
		public reverse:boolean;
		protected get_reverse():boolean;
		protected set_reverse(value:boolean):boolean;
		
		/** Indicates if the numeric values should be cast to Integers. @default false */
		public roundToInt:boolean;
		protected get_roundToInt():boolean;
		protected set_roundToInt(value:boolean):boolean;
		
		/** A that will be called when the tween starts (after a possible delay). */
		public onStart:Function;
		protected get_onStart():Function;
		protected set_onStart(value:Function):Function;
		
		/** A that will be called each time the tween is advanced. */
		public onUpdate:Function;
		protected get_onUpdate():Function;
		protected set_onUpdate(value:Function):Function;
		
		/** A that will be called each time the tween finishes one repetition
		 * (except the last, which will trigger 'onComplete'). */
		public onRepeat:Function;
		protected get_onRepeat():Function;
		protected set_onRepeat(value:Function):Function;
		
		/** A that will be called when the tween is complete. */
		public onComplete:Function;
		protected get_onComplete():Function;
		protected set_onComplete(value:Function):Function;
		
		/** The arguments that will be passed to the 'onStart' function. */
		public onStartArgs:Array<any>;
		protected get_onStartArgs():Array<any>;
		protected set_onStartArgs(value:Array<any>):Array<any>;
		
		/** The arguments that will be passed to the 'onUpdate' function. */
		public onUpdateArgs:Array<any>;
		protected get_onUpdateArgs():Array<any>;
		protected set_onUpdateArgs(value:Array<any>):Array<any>;
		
		/** The arguments that will be passed to the 'onRepeat' function. */
		public onRepeatArgs:Array<any>;
		protected get_onRepeatArgs():Array<any>;
		protected set_onRepeatArgs(value:Array<any>):Array<any>;
		
		/** The arguments that will be passed to the 'onComplete' function. */
		public onCompleteArgs:Array<any>;
		protected get_onCompleteArgs():Array<any>;
		protected set_onCompleteArgs(value:Array<any>):Array<any>;
		
		/** Another tween that will be started (i.e. added to the same juggler) as soon as 
		 * this tween is completed. */
		public nextTween:Tween;
		protected get_nextTween():Tween;
		protected set_nextTween(value:Tween):Tween;
	}
}

export default starling.animation.Tween;
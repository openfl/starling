declare namespace starling.animation
{
	/** The Transitions class contains static methods that define easing functions. 
	 *  Those functions are used by the Tween class to execute animations.
	 * 
	 *  <p>Here is a visual representation of the available transitions:</p> 
	 *  <img src="http://gamua.com/img/blog/2010/sparrow-transitions.png"/>
	 *  
	 *  <p>You can define your own transitions through the "registerTransition" function. A 
	 *  transition must have the following signature, where <code>ratio</code> is 
	 *  in the range 0-1:</p>
	 *  
	 *  <pre>myTransition(ratio:number):number</pre>
	 */
	export class Transitions
	{
		public static LINEAR:string;
		public static EASE_IN:string;
		public static EASE_OUT:string;
		public static EASE_IN_OUT:string;
		public static EASE_OUT_IN:string;
		public static EASE_IN_BACK:string;
		public static EASE_OUT_BACK:string;
		public static EASE_IN_OUT_BACK:string;
		public static EASE_OUT_IN_BACK:string;
		public static EASE_IN_ELASTIC:string;
		public static EASE_OUT_ELASTIC:string;
		public static EASE_IN_OUT_ELASTIC:string;
		public static EASE_OUT_IN_ELASTIC:string;
		public static EASE_IN_BOUNCE:string;
		public static EASE_OUT_BOUNCE:string;
		public static EASE_IN_OUT_BOUNCE:string;
		public static EASE_OUT_IN_BOUNCE:string;
		
		/** Returns the transition that was registered under a certain name. */ 
		public static getTransition(name:string):(number)=>number;
		
		/** Registers a new transition under a certain name. */
		public static register(name:string, func:(number)=>number):void;
	}
}

export default starling.animation.Transitions;
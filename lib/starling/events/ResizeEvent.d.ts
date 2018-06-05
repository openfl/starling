import Event from "./../../starling/events/Event";
import Point from "openfl/geom/Point";

declare namespace starling.events
{
	/** A ResizeEvent is dispatched by the stage when the size of the Flash container changes.
	 *  Use it to update the Starling viewport and the stage size.
	 *  
	 *  <p>The event contains properties containing the updated width and height of the Flash 
	 *  player. If you want to scale the contents of your stage to fill the screen, update the 
	 *  <code>Starling.current.viewPort</code> rectangle accordingly. If you want to make use of
	 *  the additional screen estate, update the values of <code>stage.stageWidth</code> and 
	 *  <code>stage.stageHeight</code> as well.</p>
	 *  
	 *  @see starling.display.Stage
	 *  @see starling.core.Starling
	 */
	export class ResizeEvent extends Event
	{
		/** Event type for a resized Flash player. */
		public static RESIZE:string;
		
		/** Creates a new ResizeEvent. */
		public constructor(type:string, width:number, height:number, bubbles?:boolean);
		
		/** The updated width of the player. */
		public readonly width:number;
		protected get_width():number;
		
		/** The updated height of the player. */
		public readonly height:number;
		protected get_height():number;
	}
}

export default starling.events.ResizeEvent;
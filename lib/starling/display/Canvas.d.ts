import DisplayObject from "./DisplayObject";
import DisplayObjectContainer from "./DisplayObjectContainer";
import Polygon from "./../geom/Polygon";

declare namespace starling.display
{
	/** A display object supporting basic vector drawing functionality. In its current state,
	 *  the main use of this class is to provide a range of forms that can be used as masks.
	 */
	export class Canvas extends DisplayObjectContainer
	{
		/** Creates a new (empty) Canvas. Call one or more of the 'draw' methods to add content. */
		public constructor();
	
		/** @inheritDoc */
		public /*override*/ dispose():void;
	
		/** @inheritDoc */
		public /*override*/ hitTest(localPoint:Point):DisplayObject;
	
		/** Draws a circle. */
		public drawCircle(x:number, y:number, radius:number):void;
	
		/** Draws an ellipse. */
		public drawEllipse(x:number, y:number, width:number, height:number):void;
	
		/** Draws a rectangle. */
		public drawRectangle(x:number, y:number, width:number, height:number):void;
	
		/** Draws an arbitrary polygon. */
		public drawPolygon(polygon:Polygon):void;
	
		/** Specifies a simple one-color fill that subsequent calls to drawing methods
		 * (such as <code>drawCircle()</code>) will use. */
		public beginFill(color?:number, alpha?:number):void;
	
		/** Resets the color to 'white' and alpha to '1'. */
		public endFill():void;
	
		/** Removes all existing vertices. */
		public clear():void;
	}
}

export default starling.display.Canvas;
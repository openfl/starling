import Point from "openfl/geom/Point";
import Vector3D from "openfl/geom/Vector3D";
import Vector from "openfl/Vector";
import Rectangle from "openfl/geom/Rectangle";
import ScaleMode from "./../../starling/utils/ScaleMode";
import ArgumentError from "openfl/errors/ArgumentError";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import MathUtil from "./../../starling/utils/MathUtil";
import Matrix from "openfl/geom/Matrix";
import Matrix3D from "openfl/geom/Matrix3D";

declare namespace starling.utils
{
	/** A utility class containing methods related to the Rectangle class. */
	export class RectangleUtil
	{
		/** Calculates the intersection between two Rectangles. If the rectangles do not intersect,
		 *  this method returns an empty Rectangle object with its properties set to 0. */
		public static intersect(rect1:Rectangle, rect2:Rectangle, 
										 out?:Rectangle):Rectangle;
		
		/** Calculates a rectangle with the same aspect ratio as the given 'rectangle',
		 *  centered within 'into'.  
		 * 
		 *  <p>This method is useful for calculating the optimal viewPort for a certain display 
		 *  size. You can use different scale modes to specify how the result should be calculated;
		 *  furthermore, you can avoid pixel alignment errors by only allowing whole-number  
		 *  multipliers/divisors (e.g. 3, 2, 1, 1/2, 1/3).</p>
		 *  
		 *  @see starling.utils.ScaleMode
		 */
		public static fit(rectangle:Rectangle, into:Rectangle, 
								   scaleMode?:string, pixelPerfect?:boolean,
								   out?:Rectangle):Rectangle;
	
		/** If the rectangle contains negative values for width or height, all coordinates
		 *  are adjusted so that the rectangle describes the same region with positive values. */
		public static normalize(rect:Rectangle):void;
	
		/** Extends the rectangle in all four directions. */
		public static extend(rect:Rectangle, left?:number, right?:number,
									  top?:number, bottom?:number):void;
	
		/** Extends the rectangle in all four directions so that it is exactly on pixel bounds. */
		public static extendToWholePixels(rect:Rectangle, scaleFactor?:number):void;
	
		/** Calculates the bounds of a rectangle after transforming it by a matrix.
		 *  If you pass an <code>out</code>-rectangle, the result will be stored in this rectangle
		 *  instead of creating a new object. */
		public static getBounds(rectangle:Rectangle, matrix:Matrix,
										 out?:Rectangle):Rectangle;
	
		/** Calculates the bounds of a rectangle projected into the XY-plane of a certain 3D space
		 *  as they appear from the given camera position. Note that 'camPos' is expected in the
		 *  target coordinate system (the same that the XY-plane lies in).
		 *
		 *  <p>If you pass an 'out' Rectangle, the result will be stored in this rectangle
		 *  instead of creating a new object.</p> */
		public static getBoundsProjected(rectangle:Rectangle, matrix:Matrix3D,
												  camPos:Vector3D, out?:Rectangle):Rectangle;
	
		/** Returns a vector containing the positions of the four edges of the given rectangle. */
		public static getPositions(rectangle:Rectangle,
											out?:Vector<Point>):Vector<Point>;
	
		/** Compares all properties of the given rectangle, returning true only if
		 *  they are equal (with the given accuracy 'e'). */
		public static compare(r1:Rectangle, r2:Rectangle, e?:number):boolean;
	}
}

export default starling.utils.RectangleUtil;
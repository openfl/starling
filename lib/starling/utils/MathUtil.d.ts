import Point from "openfl/geom/Point";
import Vector3D from "openfl/geom/Vector3D";

declare namespace starling.utils
{
	/** A utility class containing methods you might need for math problems. */
	export class MathUtil
	{
		protected static TWO_PI:number;
	
		/** Calculates the intersection point between the xy-plane and an infinite line
		 *  that is defined by two 3D points in the same coordinate system. */
		public static intersectLineWithXYPlane(pointA:Vector3D, pointB:Vector3D,
														out?:Point):Point;
	
		/** Calculates if the point <code>p</code> is inside the triangle <code>a-b-c</code>. */
		public static isPointInTriangle(p:Point, a:Point, b:Point, c:Point):boolean;
	
		/** Moves a radian angle into the range [-PI, +PI], while keeping the direction intact. */
		public static normalizeAngle(angle:number):number;
	
		/** Returns the next power of two that is equal to or bigger than the specified number. */
		public static getNextPowerOfTwo(number:number):number;
	
		/** Indicates if two float (Number) values are equal, give or take <code>epsilon</code>. */
		public static isEquivalent(a:number, b:number, epsilon?:number):boolean;
	
		/** Returns the larger of the two values. Different to the native <code>Math.max</code>,
		 *  this doesn't create any temporary objects when using the AOT compiler. */
		public static max(a:number, b:number):number;
	
		/** Returns the smaller of the two values. Different to the native <code>Math.min</code>,
		 *  this doesn't create any temporary objects when using the AOT compiler. */
		public static min(a:number, b:number):number;
	
		/** Moves <code>value</code> into the range between <code>min</code> and <code>max</code>. */
		public static clamp(value:number, min:number, max:number):number;
		
		/** Returns the smallest value in an array. */
		public static minValues(values:Array<number>):number;
		
		/** Converts an angle from degrees into radians. */
		public static deg2rad(deg:number):number;
		
		/** Converts an angle from radians into degrees. */
		public static rad2deg(rad:number):number;
		
		public static toFixed(value:number, precision:number):string;
	}
}

export default starling.utils.MathUtil;
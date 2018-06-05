import Vector from "openfl/Vector";
import Point from "openfl/geom/Point";
import Vector3D from "openfl/geom/Vector3D";
import Matrix from "openfl/geom/Matrix";
import Matrix3D from "openfl/geom/Matrix3D";
import Rectangle from "openfl/geom/Rectangle";

declare namespace starling.utils
{
	/** A simple object pool supporting the most basic utility objects.
	 *
	 *  <p>If you want to retrieve an object, but the pool does not contain any more instances,
	 *  it will silently create a new one.</p>
	 *
	 *  <p>It's important that you use the pool in a balanced way, i.e. don't just "get" or "put"
	 *  alone! Always make the calls in pairs; whenever you get an object, be sure to put it back
	 *  later, and the other way round. Otherwise, the pool will empty or (even worse) grow
	 *  in size uncontrolled.</p>
	 */
	export class Pool
	{
		/** Retrieves a Point instance from the pool. */
		public static getPoint(x?:number, y?:number):Point;
	
		/** Stores a Point instance in the pool.
		 *  Don't keep any references to the object after moving it to the pool! */
		public static putPoint(point:Point):void;
	
		/** Retrieves a Vector3D instance from the pool. */
		public static getPoint3D(x?:number, y?:number, z?:number):Vector3D;
	
		/** Stores a Vector3D instance in the pool.
		 *  Don't keep any references to the object after moving it to the pool! */
		public static putPoint3D(point:Vector3D):void;
	
		/** Retrieves a Matrix instance from the pool. */
		public static getMatrix(a?:number, b?:number, c?:number, d?:number,
										 tx?:number, ty?:number):Matrix;
	
		/** Stores a Matrix instance in the pool.
		 *  Don't keep any references to the object after moving it to the pool! */
		public static putMatrix(matrix:Matrix):void;
	
		/** Retrieves a Matrix3D instance from the pool.
		 *
		 *  @param identity   If enabled, the matrix will be reset to the identity.
		 *                    Otherwise, its contents is undefined.
		 */
		public static getMatrix3D(identity?:boolean):Matrix3D;
	
		/** Stores a Matrix3D instance in the pool.
		 *  Don't keep any references to the object after moving it to the pool! */
		public static putMatrix3D(matrix:Matrix3D):void;
	
		/** Retrieves a Rectangle instance from the pool. */
		public static getRectangle(x?:number, y?:number,
											width?:number, height?:number):Rectangle;
	
		/** Stores a Rectangle instance in the pool.
		 *  Don't keep any references to the object after moving it to the pool! */
		public static putRectangle(rectangle:Rectangle):void;
	}
}

export default starling.utils.Pool;
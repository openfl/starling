import Vector from "openfl/Vector";
import Vector3D from "openfl/geom/Vector3D";
import Matrix3D from "openfl/geom/Matrix3D";
import Matrix from "openfl/geom/Matrix";
import Point from "openfl/geom/Point";
import MathUtil from "./../../starling/utils/MathUtil";

declare namespace starling.utils
{
	/** A utility class containing methods related to the Matrix class. */
	export class MatrixUtil
	{
		/** Converts a 2D matrix to a 3D matrix. If you pass an <code>out</code>-matrix,
		 * the result will be stored in this matrix instead of creating a new object. */
		public static convertTo3D(matrix:Matrix, out?:Matrix3D):Matrix3D;
	
		/** Converts a 3D matrix to a 2D matrix. Beware that this will work only for a 3D matrix
		 * describing a pure 2D transformation. */
		public static convertTo2D(matrix3D:Matrix3D, out?:Matrix):Matrix;
	
		/** Determines if the matrix is an identity matrix. */
		public static isIdentity(matrix:Matrix):boolean;
	
		/** Determines if the 3D matrix is an identity matrix. */
		public static isIdentity3D(matrix:Matrix3D):boolean;
	
		/** Transform a point with the given matrix. */
		public static transformPoint(matrix:Matrix, point:Point,
												out?:Point):Point;
	
		/** Transforms a 3D point with the given matrix. */
		public static transformPoint3D(matrix:Matrix3D, point:Vector3D,
												out?:Vector3D):Vector3D;
	
		/** Uses a matrix to transform 2D coordinates into a different space. If you pass an
		 * <code>out</code>-point, the result will be stored in this point instead of creating a
		 * new object. */
		public static transformCoords(matrix:Matrix, x:number, y:number,
											   out?:Point):Point;
	
		/** Uses a matrix to transform 3D coordinates into a different space. If you pass a
		 * 'resultVector', the result will be stored in this vector3D instead of creating a
		 * new object. */
		public static transformCoords3D(matrix:Matrix3D, x:number, y:number, z:number,
												 out?:Vector3D):Vector3D;
	
		/** Appends a skew transformation to a matrix (angles in radians). The skew matrix
		 * has the following form:
		 * <pre>
		 * | cos(skewY)  -sin(skewX)  0 |
		 * | sin(skewY)   cos(skewX)  0 |
		 * |     0            0       1 |
		 * </pre>
		 */
		public static skew(matrix:Matrix, skewX:number, skewY:number):void;
	
		/** Prepends a matrix to 'base' by multiplying it with another matrix. */
		public static prependMatrix(base:Matrix, prep:Matrix):void;
	
		/** Prepends an incremental translation to a Matrix object. */
		public static prependTranslation(matrix:Matrix, tx:number, ty:number):void;
	
		/** Prepends an incremental scale change to a Matrix object. */
		public static prependScale(matrix:Matrix, sx:number, sy:number):void;
	
		/** Prepends an incremental rotation to a Matrix object (angle in radians). */
		public static prependRotation(matrix:Matrix, angle:number):void;
	
		/** Prepends a skew transformation to a Matrix object (angles in radians). The skew matrix
		 * has the following form:
		 * <pre>
		 * | cos(skewY)  -sin(skewX)  0 |
		 * | sin(skewY)   cos(skewX)  0 |
		 * |     0            0       1 |
		 * </pre>
		 */
		public static prependSkew(matrix:Matrix, skewX:number, skewY:number):void;
	
		/** Converts a Matrix3D instance to a String, which is useful when debugging. Per default,
			*  the raw data is displayed transposed, so that the columns are displayed vertically. */
		public static toString3D(matrix:Matrix3D, transpose?:boolean,
											precision:Int=3):string;
	
		/** Converts a Matrix instance to a String, which is useful when debugging. */
		public static toString(matrix:Matrix, precision:Int=3):string;
	
		/** Updates the given matrix so that it points exactly to pixel boundaries. This works
			*  only if the object is unscaled and rotated by a multiple of 90 degrees.
			*
			*  @param matrix    The matrix to manipulate in place (normally the modelview matrix).
			*  @param pixelSize The size (in points) that represents one pixel in the back buffer.
			*/
		public static snapToPixels(matrix:Matrix, pixelSize:number):void;
	
		/** Creates a perspective projection matrix suitable for 2D and 3D rendering.
			*
			*  <p>The first 4 parameters define which area of the stage you want to view (the camera
			*  will 'zoom' to exactly this region). The final 3 parameters determine the perspective
			*  in which you're looking at the stage.</p>
			*
			*  <p>The stage is always on the rectangle that is spawned up between x- and y-axis (with
			*  the given size). All objects that are exactly on that rectangle (z equals zero) will be
			*  rendered in their true size, without any distortion.</p>
			*
			*  <p>If you pass only the first 4 parameters, the camera will be set up above the center
			*  of the stage, with a field of view of 1.0 rad.</p>
			*/
		public static createPerspectiveProjectionMatrix(
				x:number, y:number, width:number, height:number,
				stageWidth?:number, stageHeight?:number, cameraPos?:Vector3D,
				out?:Matrix3D):Matrix3D;
	
		/** Creates a orthographic projection matrix suitable for 2D rendering. */
		public static createOrthographicProjectionMatrix(
				x:number, y:number, width:number, height:number, out?:Matrix):Matrix;
	}
}

export default starling.utils.MatrixUtil;
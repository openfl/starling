import Point from "openfl/geom/Point";
import ArgumentError from "openfl/errors/ArgumentError";

import RangeError from "openfl/errors/RangeError";
import IndexData from "./../../starling/rendering/IndexData";
import Pool from "./../../starling/utils/Pool";
import MathUtil from "./../../starling/utils/MathUtil";
import Vector from "openfl/Vector";

declare namespace starling.geom
{
	/** A polygon describes a closed two-dimensional shape bounded by a number of straight
	 *  line segments.
	 *
	 *  <p>The vertices of a polygon form a closed path (i.e. the last vertex will be connected
	 *  to the first). It is recommended to provide the vertices in clockwise order.
	 *  Self-intersecting paths are not supported and will give wrong results on triangulation,
	 *  area calculation, etc.</p>
	 */
	export class Polygon
	{
		/** Creates a Polygon with the given coordinates.
		 * @param vertices an array that contains either 'Point' instances or
		 *                 alternating 'x' and 'y' coordinates.
		 */
		public constructor(vertices:Array<any>=null);
	
		/** Creates a clone of this polygon. */
		public clone():Polygon;
	
		/** Reverses the order of the vertices. Note that some methods of the Polygon class
		 * require the vertices in clockwise order. */
		public reverse():void;
	
		/** Adds vertices to the polygon. Pass either a list of 'Point' instances or alternating
		 * 'x' and 'y' coordinates. */
		public addVertices(args:Array<any>):void;
	
		/** Moves a given vertex to a certain position or adds a new vertex at the end. */
		public setVertex(index:number, x:number, y:number):void;
	
		/** Returns the coordinates of a certain vertex. */
		public getVertex(index:number, out?:Point):Point;
	
		/** Figures out if the given coordinates lie within the polygon. */
		public contains(x:number, y:number):boolean;
	
		/** Figures out if the given point lies within the polygon. */
		public containsPoint(point:Point):boolean;
	
		/** Calculates a possible representation of the polygon via triangles. The resulting
		 *  IndexData instance will reference the polygon vertices as they are saved in this
		 *  Polygon instance, optionally incremented by the given offset.
		 *
		 *  <p>If you pass an indexData object, the new indices will be appended to it.
		 *  Otherwise, a new instance will be created.</p> */
		public triangulate(indexData:IndexData=null, offset?:number):IndexData;
	
		/** Copies all vertices to a 'VertexData' instance, beginning at a certain target index. */
		public copyToVertexData(target:VertexData, targetVertexID?:number,
										 attrName?:string):void;
	
		/** Creates a string that contains the values of all included points. */
		public toString():string;
	
		// factory methods
	
		/** Creates an ellipse with optimized implementations of triangulation, hitTest, etc. */
		public static createEllipse(x:number, y:number, radiusX:number, radiusY:number, numSides?:number):Polygon;
	
		/** Creates a circle with optimized implementations of triangulation, hitTest, etc. */
		public static createCircle(x:number, y:number, radius:number, numSides?:number):Polygon;
	
		/** Creates a rectangle with optimized implementations of triangulation, hitTest, etc. */
		public static createRectangle(x:number, y:number,
											   width:number, height:number):Polygon;
	
		// properties
	
		/** Indicates if the polygon's line segments are not self-intersecting.
		 * Beware: this is a brute-force implementation with <code>O(n^2)</code>. */
		public readonly isSimple:boolean;
		protected get_isSimple():boolean;
	
		/** Indicates if the polygon is convex. In a convex polygon, the vector between any two
		 * points inside the polygon lies inside it, as well. */
		public readonly isConvex:boolean;
		protected get_isConvex():boolean;
	
		/** Calculates the total area of the polygon. */
		public readonly area:number;
		protected get_area():number;
	
		/** Returns the total number of vertices spawning up the polygon. Assigning a value
		 * that's smaller than the current number of vertices will crop the path; a bigger
		 * value will fill up the path with zeros. */
		public numVertices:number;
		protected get_numVertices():number;
	
		protected set_numVertices(value:number):number;
	
		/** Returns the number of triangles that will be required when triangulating the polygon. */
		public readonly numTriangles:number;
		protected get_numTriangles():number;
	}
}

export default starling.geom.Polygon;
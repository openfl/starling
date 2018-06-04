// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.geom;

import openfl.errors.ArgumentError;
import openfl.errors.RangeError;
import openfl.geom.Point;
import openfl.Vector;

import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.utils.MathUtil;
import starling.utils.Pool;

/** A polygon describes a closed two-dimensional shape bounded by a number of straight
 *  line segments.
 *
 *  <p>The vertices of a polygon form a closed path (i.e. the last vertex will be connected
 *  to the first). It is recommended to provide the vertices in clockwise order.
 *  Self-intersecting paths are not supported and will give wrong results on triangulation,
 *  area calculation, etc.</p>
 */

@:jsRequire("starling/geom/Polygon", "default")

extern class Polygon
{
    /** Creates a Polygon with the given coordinates.
     * @param vertices an array that contains either 'Point' instances or
     *                 alternating 'x' and 'y' coordinates.
     */
    public function new(vertices:Array<Dynamic>=null);

    /** Creates a clone of this polygon. */
    public function clone():Polygon;

    /** Reverses the order of the vertices. Note that some methods of the Polygon class
     * require the vertices in clockwise order. */
    public function reverse():Void;

    /** Adds vertices to the polygon. Pass either a list of 'Point' instances or alternating
     * 'x' and 'y' coordinates. */
    public function addVertices(args:Array<Dynamic>):Void;

    /** Moves a given vertex to a certain position or adds a new vertex at the end. */
    public function setVertex(index:Int, x:Float, y:Float):Void;

    /** Returns the coordinates of a certain vertex. */
    public function getVertex(index:Int, out:Point=null):Point;

    /** Figures out if the given coordinates lie within the polygon. */
    public function contains(x:Float, y:Float):Bool;

    /** Figures out if the given point lies within the polygon. */
    public function containsPoint(point:Point):Bool;

    /** Calculates a possible representation of the polygon via triangles. The resulting
     *  IndexData instance will reference the polygon vertices as they are saved in this
     *  Polygon instance, optionally incremented by the given offset.
     *
     *  <p>If you pass an indexData object, the new indices will be appended to it.
     *  Otherwise, a new instance will be created.</p> */
    public function triangulate(indexData:IndexData=null, offset:Int=0):IndexData;

    /** Copies all vertices to a 'VertexData' instance, beginning at a certain target index. */
    public function copyToVertexData(target:VertexData, targetVertexID:Int=0,
                                     attrName:String="position"):Void;

    /** Creates a string that contains the values of all included points. */
    public function toString():String;

    // factory methods

    /** Creates an ellipse with optimized implementations of triangulation, hitTest, etc. */
    public static function createEllipse(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1):Polygon;

    /** Creates a circle with optimized implementations of triangulation, hitTest, etc. */
    public static function createCircle(x:Float, y:Float, radius:Float, numSides:Int = -1):Polygon;

    /** Creates a rectangle with optimized implementations of triangulation, hitTest, etc. */
    public static function createRectangle(x:Float, y:Float,
                                           width:Float, height:Float):Polygon;

    // properties

    /** Indicates if the polygon's line segments are not self-intersecting.
     * Beware: this is a brute-force implementation with <code>O(n^2)</code>. */
    public var isSimple(get, never):Bool;
    private function get_isSimple():Bool;

    /** Indicates if the polygon is convex. In a convex polygon, the vector between any two
     * points inside the polygon lies inside it, as well. */
    public var isConvex(get, never):Bool;
    private function get_isConvex():Bool;

    /** Calculates the total area of the polygon. */
    public var area(get, never):Float;
    private function get_area():Float;

    /** Returns the total number of vertices spawning up the polygon. Assigning a value
     * that's smaller than the current number of vertices will crop the path; a bigger
     * value will fill up the path with zeros. */
    public var numVertices(get, set):Int;
    private function get_numVertices():Int;

    private function set_numVertices(value:Int):Int;

    /** Returns the number of triangles that will be required when triangulating the polygon. */
    public var numTriangles(get, never):Int;
    private function get_numTriangles():Int;
}
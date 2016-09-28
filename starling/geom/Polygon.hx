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

import flash.errors.ArgumentError;
import flash.errors.RangeError;
import flash.geom.Point;

import openfl.Vector;

import starling.utils.VectorUtil;
import starling.utils.VertexData;

/** A polygon describes a closed two-dimensional shape bounded by a number of straight
 *  line segments.
 *
 *  <p>The vertices of a polygon form a closed path (i.e. the last vertex will be connected
 *  to the first). It is recommended to provide the vertices in clockwise order.
 *  Self-intersecting paths are not supported and will give wrong results on triangulation,
 *  area calculation, etc.</p>
 */
class Polygon
{
    private var mCoords:Vector<Float>;

    // Helper object
    private static var sRestIndices:Vector<UInt> = new Vector<UInt>();

    /** Creates a Polygon with the given coordinates.
     *  @param vertices an array that contains either 'Point' instances or
     *                  alternating 'x' and 'y' coordinates.
     */
    public function new(vertices:Array<Dynamic>=null)
    {
        mCoords = new Vector<Float>();
        addVertices(vertices);
    }

    /** Creates a clone of this polygon. */
    public function clone():Polygon
    {
        var clone:Polygon = new Polygon();
        var numCoords:Int = mCoords.length;

        for (i in 0...numCoords)
            clone.mCoords[i] = mCoords[i];

        return clone;
    }

    /** Reverses the order of the vertices. Note that some methods of the Polygon class
     *  require the vertices in clockwise order. */
    public function reverse():Void
    {
        var numCoords:Int = mCoords.length;
        var numVertices:Int = Std.int(numCoords / 2);
        var tmp:Float;

        var i:Int = 0;
        while (i < numVertices)
        {
            tmp = mCoords[i];
            mCoords[i] = mCoords[numCoords - i - 2];
            mCoords[numCoords - i - 2] = tmp;

            tmp = mCoords[i + 1];
            mCoords[i + 1] = mCoords[numCoords - i - 1];
            mCoords[numCoords - i - 1] = tmp;

            i += 2;
        }
    }

    /** Adds vertices to the polygon. Pass either a list of 'Point' instances or alternating
     *  'x' and 'y' coordinates. */
    public function addVertices(args:Array<Dynamic>):Void
    {
        var i:Int;
        var numArgs:Int = args.length;
        var numCoords:Int = mCoords.length;

        if (numArgs > 0)
        {
            if (Std.is(args[0], Point))
            {
                for (i in 0...numArgs)
                {
                    mCoords[numCoords + i * 2    ] = cast(args[i], Point).x;
                    mCoords[numCoords + i * 2 + 1] = cast(args[i], Point).y;
                }
            }
            else if (Std.is(args[0], Float))
            {
                for (i in 0...numArgs)
                    mCoords[numCoords + i] = args[i];
            }
            else throw new ArgumentError("Invalid type: " + Type.getClassName(Type.getClass(args[0])));
        }
    }

    /** Moves a given vertex to a certain position or adds a new vertex at the end. */
    public function setVertex(index:Int, x:Float, y:Float):Void
    {
        if (index >= 0 && index <= numVertices)
        {
            mCoords[index * 2    ] = x;
            mCoords[index * 2 + 1] = y;
        }
        else throw new RangeError("Invalid index: " + index);
    }

    /** Returns the coordinates of a certain vertex. */
    public function getVertex(index:Int, result:Point=null):Point
    {
        if (index >= 0 && index < numVertices)
        {
            result = (result == null) ? new Point() : result;
            result.setTo(mCoords[index * 2], mCoords[index * 2 + 1]);
            return result;
        }
        else throw new RangeError("Invalid index: " + index);
    }

    /** Figures out if the given coordinates lie within the polygon. */
    public function contains(x:Float, y:Float):Bool
    {
        // Algorithm & implementation thankfully taken from:
        // -> http://alienryderflex.com/polygon/

        var i:Int, j:Int = numVertices - 1;
        var oddNodes:UInt = 0;

        for (i in 0...numVertices)
        {
            var ix:Float = mCoords[i * 2];
            var iy:Float = mCoords[i * 2 + 1];
            var jx:Float = mCoords[j * 2];
            var jy:Float = mCoords[j * 2 + 1];

            if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
                oddNodes ^= (ix + (y - iy) / (jy - iy) * (jx - ix) < x) ? 1 : 0;

            j = i;
        }

        return oddNodes != 0;
    }

    /** Figures out if the given point lies within the polygon. */
    public function containsPoint(point:Point):Bool
    {
        return contains(point.x, point.y);
    }

    /** Calculates a possible representation of the polygon via triangles. The resulting
     *  vector contains a list of vertex indices, where every three indices describe a triangle
     *  referencing the vertices of the polygon. */
    public function triangulate(result:Vector<UInt>=null):Vector<UInt>
    {
        // Algorithm "Ear clipping method" described here:
        // -> https://en.wikipedia.org/wiki/Polygon_triangulation
        //
        // Implementation inspired by:
        // -> http://polyk.ivank.net

        if (result == null) result = new Vector<UInt>();

        var numVertices:Int = this.numVertices;
        var i:Int, restIndexPos:Int, numRestIndices:Int, resultPos:Int;

        if (numVertices < 3) return result;

        sRestIndices.length = numVertices;
        for (i in 0...numVertices) sRestIndices[i] = i;

        restIndexPos = 0;
        resultPos = result.length;
        numRestIndices = numVertices;

        while (numRestIndices > 3)
        {
            // In each step, we look at 3 subsequent vertices. If those vertices spawn up
            // a triangle that is convex and does not contain any other vertices, it is an 'ear'.
            // We remove those ears until only one remains -> each ear is one of our wanted
            // triangles.

            var i0:UInt = sRestIndices[ restIndexPos      % numRestIndices];
            var i1:UInt = sRestIndices[(restIndexPos + 1) % numRestIndices];
            var i2:UInt = sRestIndices[(restIndexPos + 2) % numRestIndices];

            var ax:Float = mCoords[2 * i0];
            var ay:Float = mCoords[2 * i0 + 1];
            var bx:Float = mCoords[2 * i1];
            var by:Float = mCoords[2 * i1 + 1];
            var cx:Float = mCoords[2 * i2];
            var cy:Float = mCoords[2 * i2 + 1];
            var earFound:Bool = false;

            if (isConvexTriangle(ax, ay, bx, by, cx, cy))
            {
                earFound = true;
                for (i in 3...numRestIndices)
                {
                    var otherIndex:UInt = sRestIndices[(restIndexPos + i) % numRestIndices];
                    if (isPointInTriangle(mCoords[2 * otherIndex], mCoords[2 * otherIndex + 1],
                            ax, ay, bx, by, cx, cy))
                    {
                        earFound = false;
                        break;
                    }
                }
            }

            if (earFound)
            {
                result[resultPos++] = i0; // -> result.push(i0, i1, i2);
                result[resultPos++] = i1;
                result[resultPos++] = i2;
                VectorUtil.removeUnsignedIntAt(sRestIndices, (restIndexPos + 1) % numRestIndices);

                numRestIndices--;
                restIndexPos = 0;
            }
            else
            {
                restIndexPos++;
                if (restIndexPos == numRestIndices) break; // no more ears
            }
        }

        result[resultPos++] = sRestIndices[0]; // -> result.push(...);
        result[resultPos++] = sRestIndices[1];
        result[resultPos  ] = sRestIndices[2];

        return result;
    }

    /** Copies all vertices to a 'VertexData' instance, beginning at a certain target index. */
    public function copyToVertexData(target:VertexData, targetIndex:Int=0):Void
    {
        var requiredTargetLength:Int = targetIndex + numVertices;
        if (target.numVertices < requiredTargetLength)
            target.numVertices = requiredTargetLength;

        copyToVector(target.rawData,
            targetIndex * VertexData.ELEMENTS_PER_VERTEX,
            VertexData.ELEMENTS_PER_VERTEX - 2);
    }

    /** Copies all vertices to a 'Vector', beginning at a certain target index and skipping
     *  'stride' coordinates between each 'x, y' pair. */
    public function copyToVector(target:Vector<Float>, targetIndex:Int=0,
                                 stride:Int=0):Void
    {
        var numVertices:Int = this.numVertices;

        for (i in 0...numVertices)
        {
            target[targetIndex++] = mCoords[i * 2];
            target[targetIndex++] = mCoords[i * 2 + 1];
            targetIndex += stride;
        }
    }

    /** Creates a string that contains the values of all included points. */
    public function toString():String
    {
        var result:String = "[Polygon \n";
        var numPoints:Int = this.numVertices;

        for (i in 0...numPoints)
        {
            result += "  [Vertex " + i + ": " +
                "x=" + mCoords[i * 2    ] + ", " +
                "y=" + mCoords[i * 2 + 1] + "]"  +
                (i == numPoints - 1 ? "\n" : ",\n");
        }

        return result + "]";
    }

    // factory methods

    /** Creates an ellipse with optimized implementations of triangulation, hitTest, etc. */
    public static function createEllipse(x:Float, y:Float, radiusX:Float, radiusY:Float):Polygon
    {
        return new Ellipse(x, y, radiusX, radiusY);
    }

    /** Creates a circle with optimized implementations of triangulation, hitTest, etc. */
    public static function createCircle(x:Float, y:Float, radius:Float):Polygon
    {
        return new Ellipse(x, y, radius, radius);
    }

    /** Creates a rectangle with optimized implementations of triangulation, hitTest, etc. */
    public static function createRectangle(x:Float, y:Float,
                                           width:Float, height:Float):Polygon
    {
        return new Rectangle(x, y, width, height);
    }

    // helpers

    /** Calculates if the area of the triangle a->b->c is to on the right-hand side of a->b. */
    inline private static function isConvexTriangle(ax:Float, ay:Float,
                                             bx:Float, by:Float,
                                             cx:Float, cy:Float):Bool
    {
        // dot product of [the normal of (a->b)] and (b->c) must be positive
        return (ay - by) * (cx - bx) + (bx - ax) * (cy - by) >= 0;
    }

    /** Calculates if a point (px, py) is inside the area of a 2D triangle. */
    private static function isPointInTriangle(px:Float, py:Float,
                                              ax:Float, ay:Float,
                                              bx:Float, by:Float,
                                              cx:Float, cy:Float):Bool
    {
        // This algorithm is described well in this article:
        // http://www.blackpawn.com/texts/pointinpoly/default.html

        var v0x:Float = cx - ax;
        var v0y:Float = cy - ay;
        var v1x:Float = bx - ax;
        var v1y:Float = by - ay;
        var v2x:Float = px - ax;
        var v2y:Float = py - ay;

        var dot00:Float = v0x * v0x + v0y * v0y;
        var dot01:Float = v0x * v1x + v0y * v1y;
        var dot02:Float = v0x * v2x + v0y * v2y;
        var dot11:Float = v1x * v1x + v1y * v1y;
        var dot12:Float = v1x * v2x + v1y * v2y;

        var invDen:Float = 1.0 / (dot00 * dot11 - dot01 * dot01);
        var u:Float = (dot11 * dot02 - dot01 * dot12) * invDen;
        var v:Float = (dot00 * dot12 - dot01 * dot02) * invDen;

        return (u >= 0) && (v >= 0) && (u + v < 1);
    }

    /** Finds out if the vector a->b intersects c->d. */
    private static function areVectorsIntersecting(ax:Float, ay:Float, bx:Float, by:Float,
                                                   cx:Float, cy:Float, dx:Float, dy:Float):Bool
    {
        if ((ax == bx && ay == by) || (cx == dx && cy == dy)) return false; // length = 0

        var abx:Float = bx - ax;
        var aby:Float = by - ay;
        var cdx:Float = dx - cx;
        var cdy:Float = dy - cy;
        var tDen:Float = cdy * abx - cdx * aby;

        if (tDen == 0.0) return false; // parallel or identical

        var t:Float = (aby * (cx - ax) - abx * (cy - ay)) / tDen;

        if (t < 0 || t > 1) return false; // outside c->d

        var s:Float = aby != 0.0 ? (cy - ay + t * cdy) / aby :
                             (cx - ax + t * cdx) / abx;

        return s >= 0.0 && s <= 1.0; // inside a->b
    }

    // properties

    /** Indicates if the polygon's line segments are not self-intersecting.
     *  Beware: this is a brute-force implementation with <code>O(n^2)</code>. */
    public var isSimple(get, never):Bool;
    private function get_isSimple():Bool
    {
        var numCoords:Int = mCoords.length;
        if (numCoords <= 6) return true;

        var i:Int = 0;
        while (i < numCoords)
        {
            var ax:Float = mCoords[ i ];
            var ay:Float = mCoords[ i + 1 ];
            var bx:Float = mCoords[(i + 2) % numCoords];
            var by:Float = mCoords[(i + 3) % numCoords];
            var endJ:Float = i + numCoords - 2;

            var j:Int = i + 4;
            while (j<endJ)
            {
                var cx:Float = mCoords[ j      % numCoords];
                var cy:Float = mCoords[(j + 1) % numCoords];
                var dx:Float = mCoords[(j + 2) % numCoords];
                var dy:Float = mCoords[(j + 3) % numCoords];

                if (areVectorsIntersecting(ax, ay, bx, by, cx, cy, dx, dy))
                    return false;

                j += 2;
            }

            i += 2;
        }

        return true;
    }

    /** Indicates if the polygon is convex. In a convex polygon, the vector between any two
     *  points inside the polygon lies inside it, as well. */
    public var isConvex(get, never):Bool;
    private function get_isConvex():Bool
    {
        var numCoords:Int = mCoords.length;

        if (numCoords < 6) return true;
        else
        {
            var i:Int = 0;
            while (i < numCoords)
            {
                if (!isConvexTriangle(mCoords[i], mCoords[i+1],
                                      mCoords[(i+2) % numCoords], mCoords[(i+3) % numCoords],
                                      mCoords[(i+4) % numCoords], mCoords[(i+5) % numCoords]))
                {
                    return false;
                }

                i += 2;
            }
        }

        return true;
    }

    /** Calculates the total area of the polygon. */
    public var area(get, never):Float;
    private function get_area():Float
    {
        var area:Float = 0;
        var numCoords:Int = mCoords.length;

        if (numCoords >= 6)
        {
            var i:Int = 0;
            while (i < numCoords)
            {
                area += mCoords[i  ] * mCoords[(i+3) % numCoords];
                area -= mCoords[i+1] * mCoords[(i+2) % numCoords];

                i += 2;
            }
        }

        return area / 2.0;
    }

    /** Returns the total number of vertices spawning up the polygon. Assigning a value
     *  that's smaller than the current number of vertices will crop the path; a bigger
     *  value will fill up the path with zeros. */
    public var numVertices(get, set):Int;
    private function get_numVertices():Int
    {
        return Std.int(mCoords.length / 2);
    }

    private function set_numVertices(value:Int):Int
    {
        var oldLength:Int = numVertices;
        mCoords.length = value * 2;

        if (oldLength < value)
        {
            for (i in oldLength...value)
                mCoords[i * 2] = mCoords[i * 2 + 1] = 0.0;
        }
        return Std.int(mCoords.length / 2);
    }
}
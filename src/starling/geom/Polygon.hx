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
class Polygon
{
    private var __coords:Vector<Float>;

    // Helper object
    private static var sRestIndices:Vector<UInt> = new Vector<UInt>();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (Polygon.prototype, {
            "isSimple": { get: untyped __js__ ("function () { return this.get_isSimple (); }") },
            "isConvex": { get: untyped __js__ ("function () { return this.get_isConvex (); }") },
            "area": { get: untyped __js__ ("function () { return this.get_area (); }") },
            "numVertices": { get: untyped __js__ ("function () { return this.get_numVertices (); }"), set: untyped __js__ ("function (v) { return this.set_numVertices (v); }") },
            "numTriangles": { get: untyped __js__ ("function () { return this.get_numTriangles (); }") },
        });
        
    }
    #end

    /** Creates a Polygon with the given coordinates.
     * @param vertices an array that contains either 'Point' instances or
     *                 alternating 'x' and 'y' coordinates.
     */
    public function new(vertices:Array<Dynamic>=null)
    {
        __coords = new Vector<Float>();
        addVertices(vertices);
    }

    /** Creates a clone of this polygon. */
    public function clone():Polygon
    {
        var clone:Polygon = new Polygon();
        var numCoords:Int = __coords.length;

        for (i in 0...numCoords)
            clone.__coords[i] = __coords[i];

        return clone;
    }

    /** Reverses the order of the vertices. Note that some methods of the Polygon class
     * require the vertices in clockwise order. */
    public function reverse():Void
    {
        var numCoords:Int = __coords.length;
        var numVertices:Int = Std.int(numCoords / 2);
        var tmp:Float;

        var i:Int = 0;
        while (i < numVertices)
        {
            tmp = __coords[i];
            __coords[i] = __coords[numCoords - i - 2];
            __coords[numCoords - i - 2] = tmp;

            tmp = __coords[i + 1];
            __coords[i + 1] = __coords[numCoords - i - 1];
            __coords[numCoords - i - 1] = tmp;
            i += 2;
        }
    }

    /** Adds vertices to the polygon. Pass either a list of 'Point' instances or alternating
     * 'x' and 'y' coordinates. */
    public function addVertices(args:Array<Dynamic>):Void
    {
        var i:Int;
        var numArgs:Int = args.length;
        var numCoords:Int = __coords.length;

        if (numArgs > 0)
        {
            if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(args[0], Point))
            {
                for (i in 0...numArgs)
                {
                    __coords[numCoords + i * 2    ] = cast(args[i], Point).x;
                    __coords[numCoords + i * 2 + 1] = cast(args[i], Point).y;
                }
            }
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(args[0], Float))
            {
                for (i in 0...numArgs)
                    __coords[numCoords + i] = args[i];
            }
            else throw new ArgumentError("Invalid type: " + Type.getClassName(Type.getClass(args[0])));
        }
    }

    /** Moves a given vertex to a certain position or adds a new vertex at the end. */
    public function setVertex(index:Int, x:Float, y:Float):Void
    {
        if (index >= 0 && index <= numVertices)
        {
            __coords[index * 2    ] = x;
            __coords[index * 2 + 1] = y;
        }
        else throw new RangeError("Invalid index: " + index);
    }

    /** Returns the coordinates of a certain vertex. */
    public function getVertex(index:Int, out:Point=null):Point
    {
        if (index >= 0 && index < numVertices)
        {
            out = (out == null) ? new Point() : out;
            out.setTo(__coords[index * 2], __coords[index * 2 + 1]);
            return out;
        }
        else throw new RangeError("Invalid index: " + index);
    }

    /** Figures out if the given coordinates lie within the polygon. */
    public function contains(x:Float, y:Float):Bool
    {
        // Algorithm & implementation thankfully taken from:
        // -> http://alienryderflex.com/polygon/

		var numVertices:Int = this.numVertices;
        var i:Int, j:Int = numVertices - 1;
        var oddNodes:UInt = 0;

        for (i in 0...numVertices)
        {
            var ix:Float = __coords[i * 2];
            var iy:Float = __coords[i * 2 + 1];
            var jx:Float = __coords[j * 2];
            var jy:Float = __coords[j * 2 + 1];

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
     *  IndexData instance will reference the polygon vertices as they are saved in this
     *  Polygon instance, optionally incremented by the given offset.
     *
     *  <p>If you pass an indexData object, the new indices will be appended to it.
     *  Otherwise, a new instance will be created.</p> */
    public function triangulate(indexData:IndexData=null, offset:Int=0):IndexData
    {
        // Algorithm "Ear clipping method" described here:
        // -> https://en.wikipedia.org/wiki/Polygon_triangulation
        //
        // Implementation inspired by:
        // -> http://polyk.ivank.net

        var numVertices:Int = this.numVertices;
        var numTriangles:Int = this.numTriangles;
        var i:Int, restIndexPos:Int, numRestIndices:Int;

        if (indexData == null) indexData = new IndexData(numTriangles * 3);
        if (numTriangles == 0) return indexData;

        sRestIndices.length = numVertices;
        for (i in 0...numVertices) sRestIndices[i] = i;

        restIndexPos = 0;
        numRestIndices = numVertices;

        var a:Point = Pool.getPoint();
        var b:Point = Pool.getPoint();
        var c:Point = Pool.getPoint();
        var p:Point = Pool.getPoint();

        while (numRestIndices > 3)
        {
            // In each step, we look at 3 subsequent vertices. If those vertices spawn up
            // a triangle that is convex and does not contain any other vertices, it is an 'ear'.
            // We remove those ears until only one remains -> each ear is one of our wanted
            // triangles.

            var otherIndex:UInt;
            var earFound:Bool = false;
            var i0:UInt = sRestIndices[ restIndexPos      % numRestIndices];
            var i1:UInt = sRestIndices[(restIndexPos + 1) % numRestIndices];
            var i2:UInt = sRestIndices[(restIndexPos + 2) % numRestIndices];

            a.setTo(__coords[2 * i0], __coords[2 * i0 + 1]);
            b.setTo(__coords[2 * i1], __coords[2 * i1 + 1]);
            c.setTo(__coords[2 * i2], __coords[2 * i2 + 1]);

            if (isConvexTriangle(a.x, a.y, b.x, b.y, c.x, c.y))
            {
                earFound = true;
                for (i in 3...numRestIndices)
                {
                    otherIndex = sRestIndices[(restIndexPos + i) % numRestIndices];
                    p.setTo(__coords[2 * otherIndex], __coords[2 * otherIndex + 1]);

                    if (MathUtil.isPointInTriangle(p, a, b, c))
                    {
                        earFound = false;
                        break;
                    }
                }
            }

            if (earFound)
            {
                indexData.addTriangle(i0 + offset, i1 + offset, i2 + offset);
                sRestIndices.removeAt((restIndexPos + 1) % numRestIndices);

                numRestIndices--;
                restIndexPos = 0;
            }
            else
            {
                restIndexPos++;
                if (restIndexPos == numRestIndices) break; // no more ears
            }
        }

        Pool.putPoint(a);
        Pool.putPoint(b);
        Pool.putPoint(c);
        Pool.putPoint(p);

        indexData.addTriangle(sRestIndices[0] + offset,
                                 sRestIndices[1] + offset,
                                 sRestIndices[2] + offset);
        return indexData;
    }

    /** Copies all vertices to a 'VertexData' instance, beginning at a certain target index. */
    public function copyToVertexData(target:VertexData, targetVertexID:Int=0,
                                     attrName:String="position"):Void
    {
        var numVertices:Int = this.numVertices;
        var requiredTargetLength:Int = targetVertexID + numVertices;

        if (target.numVertices < requiredTargetLength)
            target.numVertices = requiredTargetLength;

        for (i in 0...numVertices)
            target.setPoint(targetVertexID + i, attrName, __coords[i * 2], __coords[i * 2 + 1]);
    }

    /** Creates a string that contains the values of all included points. */
    public function toString():String
    {
        var result:String = "[Polygon";
        var numPoints:Int = this.numVertices;

        if (numPoints > 0) result += "\n";

        for (i in 0...numPoints)
        {
            result += "  [Vertex " + i + ": " +
                "x=" + MathUtil.toFixed(__coords[i * 2    ], 1) + ", " +
                "y=" + MathUtil.toFixed(__coords[i * 2 + 1], 1) + "]"  +
                (i == numPoints - 1 ? "\n" : ",\n");
        }

        return result + "]";
    }

    // factory methods

    /** Creates an ellipse with optimized implementations of triangulation, hitTest, etc. */
    public static function createEllipse(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1):Polygon
    {
        return new Ellipse(x, y, radiusX, radiusY, numSides);
    }

    /** Creates a circle with optimized implementations of triangulation, hitTest, etc. */
    public static function createCircle(x:Float, y:Float, radius:Float, numSides:Int = -1):Polygon
    {
        return new Ellipse(x, y, radius, radius, numSides);
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
     * Beware: this is a brute-force implementation with <code>O(n^2)</code>. */
    public var isSimple(get, never):Bool;
    private function get_isSimple():Bool
    {
        var numCoords:Int = __coords.length;
        if (numCoords <= 6) return true;

        var i:Int = 0;
        while (i < numCoords)
        {
            var ax:Float = __coords[ i ];
            var ay:Float = __coords[ i + 1 ];
            var bx:Float = __coords[(i + 2) % numCoords];
            var by:Float = __coords[(i + 3) % numCoords];
            var endJ:Float = i + numCoords - 2;

            var j:Int = i + 4;
            while (j<endJ)
            {
                var cx:Float = __coords[ j      % numCoords];
                var cy:Float = __coords[(j + 1) % numCoords];
                var dx:Float = __coords[(j + 2) % numCoords];
                var dy:Float = __coords[(j + 3) % numCoords];

                if (areVectorsIntersecting(ax, ay, bx, by, cx, cy, dx, dy))
                    return false;
                j += 2;
            }
            i += 2;
        }

        return true;
    }

    /** Indicates if the polygon is convex. In a convex polygon, the vector between any two
     * points inside the polygon lies inside it, as well. */
    public var isConvex(get, never):Bool;
    private function get_isConvex():Bool
    {
        var numCoords:Int = __coords.length;

        if (numCoords < 6) return true;
        else
        {
            var i:Int = 0;
            while (i < numCoords)
            {
                if (!isConvexTriangle(__coords[i], __coords[i+1],
                                      __coords[(i+2) % numCoords], __coords[(i+3) % numCoords],
                                      __coords[(i+4) % numCoords], __coords[(i+5) % numCoords]))
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
        var numCoords:Int = __coords.length;

        if (numCoords >= 6)
        {
            var i:Int = 0;
            while (i < numCoords)
            {
                area += __coords[i  ] * __coords[(i+3) % numCoords];
                area -= __coords[i+1] * __coords[(i+2) % numCoords];
                i += 2;
            }
        }

        return area / 2.0;
    }

    /** Returns the total number of vertices spawning up the polygon. Assigning a value
     * that's smaller than the current number of vertices will crop the path; a bigger
     * value will fill up the path with zeros. */
    public var numVertices(get, set):Int;
    private function get_numVertices():Int
    {
        return Std.int(__coords.length / 2);
    }

    private function set_numVertices(value:Int):Int
    {
        var oldLength:Int = numVertices;
        __coords.length = value * 2;

        if (oldLength < value)
        {
            for (i in oldLength...value)
                __coords[i * 2] = __coords[i * 2 + 1] = 0.0;
        }
        return value;
    }

    /** Returns the number of triangles that will be required when triangulating the polygon. */
    public var numTriangles(get, never):Int;
    private function get_numTriangles():Int
    {
        var numVertices:Int = this.numVertices;
        return numVertices >= 3 ? numVertices - 2 : 0;
    }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.geom
{
import flash.geom.Point;
import flash.utils.getQualifiedClassName;

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
public class Polygon
{
    private var _coords:Vector.<Float>;

    // Helper object
    private static var sRestIndices:Vector.<UInt> = new <UInt>[];

    /** Creates a Polygon with the given coordinates.
     *  @param vertices an array that contains either 'Point' instances or
     *                  alternating 'x' and 'y' coordinates.
     */
    public function Polygon(vertices:Array=null)
    {
        _coords = new <Float>[];
        addVertices.apply(this, vertices);
    }

    /** Creates a clone of this polygon. */
    public function clone():Polygon
    {
        var clone:Polygon = new Polygon();
        var numCoords:Int = _coords.length;

        for (var i:Int=0; i<numCoords; ++i)
            clone._coords[i] = _coords[i];

        return clone;
    }

    /** Reverses the order of the vertices. Note that some methods of the Polygon class
     *  require the vertices in clockwise order. */
    public function reverse():Void
    {
        var numCoords:Int = _coords.length;
        var numVertices:Int = numCoords / 2;
        var tmp:Float;

        for (var i:Int=0; i<numVertices; i += 2)
        {
            tmp = _coords[i];
            _coords[i] = _coords[numCoords - i - 2];
            _coords[numCoords - i - 2] = tmp;

            tmp = _coords[i + 1];
            _coords[i + 1] = _coords[numCoords - i - 1];
            _coords[numCoords - i - 1] = tmp;
        }
    }

    /** Adds vertices to the polygon. Pass either a list of 'Point' instances or alternating
     *  'x' and 'y' coordinates. */
    public function addVertices(...args):Void
    {
        var i:Int;
        var numArgs:Int = args.length;
        var numCoords:Int = _coords.length;

        if (numArgs > 0)
        {
            if (args[0] is Point)
            {
                for (i=0; i<numArgs; i++)
                {
                    _coords[numCoords + i * 2    ] = (args[i] as Point).x;
                    _coords[numCoords + i * 2 + 1] = (args[i] as Point).y;
                }
            }
            else if (args[0] is Float)
            {
                for (i=0; i<numArgs; ++i)
                    _coords[numCoords + i] = args[i];
            }
            else throw new ArgumentError("Invalid type: " + getQualifiedClassName(args[0]));
        }
    }

    /** Moves a given vertex to a certain position or adds a new vertex at the end. */
    public function setVertex(index:Int, x:Float, y:Float):Void
    {
        if (index >= 0 && index <= numVertices)
        {
            _coords[index * 2    ] = x;
            _coords[index * 2 + 1] = y;
        }
        else throw new RangeError("Invalid index: " + index);
    }

    /** Returns the coordinates of a certain vertex. */
    public function getVertex(index:Int, out:Point=null):Point
    {
        if (index >= 0 && index < numVertices)
        {
            out ||= new Point();
            out.setTo(_coords[index * 2], _coords[index * 2 + 1]);
            return out;
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

        for (i=0; i<numVertices; ++i)
        {
            var ix:Float = _coords[i * 2];
            var iy:Float = _coords[i * 2 + 1];
            var jx:Float = _coords[j * 2];
            var jy:Float = _coords[j * 2 + 1];

            if ((iy < y && jy >= y || jy < y && iy >= y) && (ix <= x || jx <= x))
                oddNodes ^= UInt(ix + (y - iy) / (jy - iy) * (jx - ix) < x);

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
        for (i=0; i<numVertices; ++i) sRestIndices[i] = i;

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

            a.setTo(_coords[2 * i0], _coords[2 * i0 + 1]);
            b.setTo(_coords[2 * i1], _coords[2 * i1 + 1]);
            c.setTo(_coords[2 * i2], _coords[2 * i2 + 1]);

            if (isConvexTriangle(a.x, a.y, b.x, b.y, c.x, c.y))
            {
                earFound = true;
                for (i = 3; i < numRestIndices; ++i)
                {
                    otherIndex = sRestIndices[(restIndexPos + i) % numRestIndices];
                    p.setTo(_coords[2 * otherIndex], _coords[2 * otherIndex + 1]);

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
    public function copyToVertexData(target:VertexData=null, targetVertexID:Int=0,
                                     attrName:String="position"):Void
    {
        var numVertices:Int = this.numVertices;
        var requiredTargetLength:Int = targetVertexID + numVertices;

        if (target.numVertices < requiredTargetLength)
            target.numVertices = requiredTargetLength;

        for (var i:Int=0; i<numVertices; ++i)
            target.setPoint(targetVertexID + i, attrName, _coords[i * 2], _coords[i * 2 + 1]);
    }

    /** Creates a string that contains the values of all included points. */
    public function toString():String
    {
        var result:String = "[Polygon";
        var numPoints:Int = this.numVertices;

        if (numPoints > 0) result += "\n";

        for (var i:Int=0; i<numPoints; ++i)
        {
            result += "  [Vertex " + i + ": " +
                "x=" + _coords[i * 2    ].toFixed(1) + ", " +
                "y=" + _coords[i * 2 + 1].toFixed(1) + "]"  +
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
    [Inline]
    private static function isConvexTriangle(ax:Float, ay:Float,
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

        var s:Float = aby ? (cy - ay + t * cdy) / aby :
                             (cx - ax + t * cdx) / abx;

        return s >= 0.0 && s <= 1.0; // inside a->b
    }

    // properties

    /** Indicates if the polygon's line segments are not self-intersecting.
     *  Beware: this is a brute-force implementation with <code>O(n^2)</code>. */
    public function get isSimple():Bool
    {
        var numCoords:Int = _coords.length;
        if (numCoords <= 6) return true;

        for (var i:Int=0; i<numCoords; i += 2)
        {
            var ax:Float = _coords[ i ];
            var ay:Float = _coords[ i + 1 ];
            var bx:Float = _coords[(i + 2) % numCoords];
            var by:Float = _coords[(i + 3) % numCoords];
            var endJ:Float = i + numCoords - 2;

            for (var j:Int = i + 4; j<endJ; j += 2)
            {
                var cx:Float = _coords[ j      % numCoords];
                var cy:Float = _coords[(j + 1) % numCoords];
                var dx:Float = _coords[(j + 2) % numCoords];
                var dy:Float = _coords[(j + 3) % numCoords];

                if (areVectorsIntersecting(ax, ay, bx, by, cx, cy, dx, dy))
                    return false;
            }
        }

        return true;
    }

    /** Indicates if the polygon is convex. In a convex polygon, the vector between any two
     *  points inside the polygon lies inside it, as well. */
    public function get isConvex():Bool
    {
        var numCoords:Int = _coords.length;

        if (numCoords < 6) return true;
        else
        {
            for (var i:Int = 0; i < numCoords; i += 2)
            {
                if (!isConvexTriangle(_coords[i], _coords[i+1],
                                      _coords[(i+2) % numCoords], _coords[(i+3) % numCoords],
                                      _coords[(i+4) % numCoords], _coords[(i+5) % numCoords]))
                {
                    return false;
                }
            }
        }

        return true;
    }

    /** Calculates the total area of the polygon. */
    public function get area():Float
    {
        var area:Float = 0;
        var numCoords:Int = _coords.length;

        if (numCoords >= 6)
        {
            for (var i:Int = 0; i < numCoords; i += 2)
            {
                area += _coords[i  ] * _coords[(i+3) % numCoords];
                area -= _coords[i+1] * _coords[(i+2) % numCoords];
            }
        }

        return area / 2.0;
    }

    /** Returns the total number of vertices spawning up the polygon. Assigning a value
     *  that's smaller than the current number of vertices will crop the path; a bigger
     *  value will fill up the path with zeros. */
    public function get numVertices():Int
    {
        return _coords.length / 2;
    }

    public function set numVertices(value:Int):Void
    {
        var oldLength:Int = numVertices;
        _coords.length = value * 2;

        if (oldLength < value)
        {
            for (var i:Int=oldLength; i < value; ++i)
                _coords[i * 2] = _coords[i * 2 + 1] = 0.0;
        }
    }

    /** Returns the number of triangles that will be required when triangulating the polygon. */
    public function get numTriangles():Int
    {
        var numVertices:Int = this.numVertices;
        return numVertices >= 3 ? numVertices - 2 : 0;
    }
}
}

import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;

import starling.geom.Polygon;
import starling.rendering.IndexData;

class ImmutablePolygon extends Polygon
{
private var _frozen:Bool;

public function ImmutablePolygon(vertices:Array)
{
    super(vertices);
    _frozen = true;
}

override public function addVertices(...args):Void
{
    if (_frozen) throw getImmutableError();
    else super.addVertices.apply(this, args);
}

override public function setVertex(index:Int, x:Float, y:Float):Void
{
    if (_frozen) throw getImmutableError();
    else super.setVertex(index, x, y);
}

override public function reverse():Void
{
    if (_frozen) throw getImmutableError();
    else super.reverse();
}

override public function set numVertices(value:Int):Void
{
    if (_frozen) throw getImmutableError();
    else super.reverse();
}

private function getImmutableError():Error
{
    var className:String = getQualifiedClassName(this).split("::").pop();
    var msg:String = className + " cannot be modified. Call 'clone' to create a mutable copy.";
    return new IllegalOperationError(msg);
}
}

class Ellipse extends ImmutablePolygon
{
private var _x:Float;
private var _y:Float;
private var _radiusX:Float;
private var _radiusY:Float;

public function Ellipse(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1)
{
    _x = x;
    _y = y;
    _radiusX = radiusX;
    _radiusY = radiusY;

    super(getVertices(numSides));
}

private function getVertices(numSides:Int):Array
{
    if (numSides < 0) numSides = Math.PI * (_radiusX + _radiusY) / 4.0;
    if (numSides < 6) numSides = 6;

    var vertices:Array = [];
    var angleDelta:Float = 2 * Math.PI / numSides;
    var angle:Float = 0;

    for (var i:Int=0; i<numSides; ++i)
    {
        vertices[i * 2    ] = Math.cos(angle) * _radiusX + _x;
        vertices[i * 2 + 1] = Math.sin(angle) * _radiusY + _y;
        angle += angleDelta;
    }

    return vertices;
}

override public function triangulate(indexData:IndexData=null, offset:Int=0):IndexData
{
    if (indexData == null) indexData = new IndexData((numVertices - 2) * 3);

    var from:UInt = 1;
    var to:UInt = numVertices - 1;

    for (var i:Int=from; i<to; ++i)
        indexData.addTriangle(offset, offset + i, offset + i + 1);

    return indexData;
}

override public function contains(x:Float, y:Float):Bool
{
    var vx:Float = x - _x;
    var vy:Float = y - _y;

    var a:Float = vx / _radiusX;
    var b:Float = vy / _radiusY;

    return a * a + b * b <= 1;
}

override public function get area():Float
{
    return Math.PI * _radiusX * _radiusY;
}

override public function get isSimple():Bool
{
    return true;
}

override public function get isConvex():Bool
{
    return true;
}
}

class Rectangle extends ImmutablePolygon
{
private var _x:Float;
private var _y:Float;
private var _width:Float;
private var _height:Float;

public function Rectangle(x:Float, y:Float, width:Float, height:Float)
{
    _x = x;
    _y = y;
    _width = width;
    _height = height;

    super([x, y, x + width, y, x + width, y + height, x, y + height]);
}

override public function triangulate(indexData:IndexData=null, offset:Int=0):IndexData
{
    if (indexData == null) indexData = new IndexData(6);

    indexData.addTriangle(offset,     offset + 1, offset + 3);
    indexData.addTriangle(offset + 1, offset + 2, offset + 3);

    return indexData;
}

override public function contains(x:Float, y:Float):Bool
{
    return x >= _x && x <= _x + _width &&
           y >= _y && y <= _y + _height;
}

override public function get area():Float
{
    return _width * _height;
}

override public function get isSimple():Bool
{
    return true;
}

override public function get isConvex():Bool
{
    return true;
}
}

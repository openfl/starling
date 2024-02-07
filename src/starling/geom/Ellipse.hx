package starling.geom;

import openfl.Vector;

import starling.rendering.IndexData;

class Ellipse extends ImmutablePolygon
{
    @:noCompletion private var __x:Float;
    @:noCompletion private var __y:Float;
    @:noCompletion private var __radiusX:Float;
    @:noCompletion private var __radiusY:Float;

    public function new(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1)
    {
        __x = x;
        __y = y;
        __radiusX = radiusX;
        __radiusY = radiusY;

        super(getVertices(numSides));
    }

    private function getVertices(numSides:Int):Array<Float>
    {
        if (numSides < 0) numSides = Std.int(Math.PI * (__radiusX + __radiusY) / 4.0);
        if (numSides < 6) numSides = 6;

        var vertices:Array<Float> = [];
        var angleDelta:Float = 2 * Math.PI / numSides;
        var angle:Float = 0;

        for (i in 0...numSides)
        {
            vertices[i * 2    ] = Math.cos(angle) * __radiusX + __x;
            vertices[i * 2 + 1] = Math.sin(angle) * __radiusY + __y;
            angle += angleDelta;
        }

        return vertices;
    }

    override public function triangulate(indexData:IndexData=null, offset:Int=0):IndexData
    {
        if (indexData == null) indexData = new IndexData((numVertices - 2) * 3);

        var from:UInt = 1;
        var to:UInt = numVertices - 1;

        for (i in from...to)
            indexData.addTriangle(offset, offset + i, offset + i + 1);

        return indexData;
    }

    override public function contains(x:Float, y:Float):Bool
    {
        var vx:Float = x - __x;
        var vy:Float = y - __y;

        var a:Float = vx / __radiusX;
        var b:Float = vy / __radiusY;

        return a * a + b * b <= 1;
    }

    override private function get_area():Float
    {
        return Math.PI * __radiusX * __radiusY;
    }

    override private function get_isSimple():Bool
    {
        return true;
    }

    override private function get_isConvex():Bool
    {
        return true;
    }
}
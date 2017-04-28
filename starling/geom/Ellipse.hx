package starling.geom;

import openfl.Vector;

class Ellipse extends ImmutablePolygon
{
    private var __x:Float;
    private var __y:Float;
    private var mRadiusX:Float;
    private var mRadiusY:Float;

    public function new(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1)
    {
        __x = x;
        __y = y;
        mRadiusX = radiusX;
        mRadiusY = radiusY;

        super(getVertices(numSides));
    }

    private function getVertices(numSides:Int):Array<Float>
    {
        if (numSides < 0) numSides = Std.int(Math.PI * (mRadiusX + mRadiusY) / 4.0);
        if (numSides < 6) numSides = 6;

        var vertices:Array<Float> = [];
        var angleDelta:Float = 2 * Math.PI / numSides;
        var angle:Float = 0;

        for (i in 0...numSides)
        {
            vertices[i * 2    ] = Math.cos(angle) * mRadiusX + __x;
            vertices[i * 2 + 1] = Math.sin(angle) * mRadiusY + __y;
            angle += angleDelta;
        }

        return vertices;
    }

    override public function triangulate(result:Vector<UInt> = null):Vector<UInt>
    {
        if (result == null) result = new Vector<UInt>();

        var from:UInt = 1;
        var to:UInt = numVertices - 1;
        var pos:UInt = result.length;

        //for (var i:Int=from; i<to; ++i)
        for (i in from...to)
        {
            result[pos++] = 0;
            result[pos++] = i;
            result[pos++] = i + 1;
        }

        return result;
    }

    override public function contains(x:Float, y:Float):Bool
    {
        var vx:Float = x - __x;
        var vy:Float = y - __y;

        var a:Float = vx / mRadiusX;
        var b:Float = vy / mRadiusY;

        return a * a + b * b <= 1;
    }

    override private function get_area():Float
    {
        return Math.PI * mRadiusX * mRadiusY;
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
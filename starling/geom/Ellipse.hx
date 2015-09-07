package starling.geom;

class Ellipse extends ImmutablePolygon
{
    private var mX:Float;
    private var mY:Float;
    private var mRadiusX:Float;
    private var mRadiusY:Float;

    public function new(x:Float, y:Float, radiusX:Float, radiusY:Float, numSides:Int = -1)
    {
        mX = x;
        mY = y;
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

        //for (var i:Int=0; i<numSides; ++i)
        for(i in 0 ... numSides)
        {
            vertices[i * 2    ] = Math.cos(angle) * mRadiusX + mX;
            vertices[i * 2 + 1] = Math.sin(angle) * mRadiusY + mY;
            angle += angleDelta;
        }

        return vertices;
    }

    override public function triangulate(result:Array<UInt> = null):Array<UInt>
    {
        if (result == null) result = new Array<UInt>();

        var from:UInt = 1;
        var to:UInt = numVertices - 1;
        var pos:UInt = result.length;

        //for (var i:Int=from; i<to; ++i)
        for(i in from ... to)
        {
            result[pos++] = 0;
            result[pos++] = i;
            result[pos++] = i + 1;
        }

        return result;
    }

    override public function contains(x:Float, y:Float):Bool
    {
        var vx:Float = x - mX;
        var vy:Float = y - mY;

        var a:Float = vx / mRadiusX;
        var b:Float = vy / mRadiusY;

        return a * a + b * b <= 1;
    }

    override public function get_area():Float
    {
        return Math.PI * mRadiusX * mRadiusY;
    }

    override public function get_isSimple():Bool
    {
        return true;
    }

    override public function get_isConvex():Bool
    {
        return true;
    }
}
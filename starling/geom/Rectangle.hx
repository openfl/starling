package starling.geom;

class Rectangle extends ImmutablePolygon
{
    private var mX:Float;
    private var mY:Float;
    private var mWidth:Float;
    private var mHeight:Float;

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        mX = x;
        mY = y;
        mWidth = width;
        mHeight = height;

        super([x, y, x + width, y, x + width, y + height, x, y + height]);
    }

    override public function triangulate(result:Array<UInt> = null):Array<UInt>
    {
        if (result == null) result = new Array<UInt>();
        result.push(0);
        result.push(1);
        result.push(3);
        result.push(1);
        result.push(2);
        result.push(3);
        return result;
    }

    override public function contains(x:Float, y:Float):Bool
    {
        return x >= mX && x <= mX + mWidth &&
               y >= mY && y <= mY + mHeight;
    }

    override public function get_area():Float
    {
        return mWidth * mHeight;
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
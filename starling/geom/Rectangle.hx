package starling.geom;

import openfl.Vector;

class Rectangle extends ImmutablePolygon
{
    private var __x:Float;
    private var __y:Float;
    private var mWidth:Float;
    private var mHeight:Float;

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        __x = x;
        __y = y;
        mWidth = width;
        mHeight = height;

        super([x, y, x + width, y, x + width, y + height, x, y + height]);
    }

    override public function triangulate(result:Vector<UInt> = null):Vector<UInt>
    {
        if (result == null) result = new Vector<UInt>();
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
        return x >= __x && x <= __x + mWidth &&
               y >= __y && y <= __y + mHeight;
    }

    override private function get_area():Float
    {
        return mWidth * mHeight;
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
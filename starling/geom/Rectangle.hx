package starling.geom;

import openfl.Vector;

class Rectangle extends ImmutablePolygon
{
    private var __x:Float;
    private var __y:Float;
    private var __width:Float;
    private var __height:Float;

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        __x = x;
        __y = y;
        __width = width;
        __height = height;

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
        return x >= __x && x <= __x + __width &&
               y >= __y && y <= __y + __height;
    }

    override private function get_area():Float
    {
        return __width * __height;
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
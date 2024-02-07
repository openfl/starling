package starling.geom;

import openfl.Vector;

import starling.rendering.IndexData;

class Rectangle extends ImmutablePolygon
{
    @:noCompletion private var __x:Float;
    @:noCompletion private var __y:Float;
    @:noCompletion private var __width:Float;
    @:noCompletion private var __height:Float;

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        __x = x;
        __y = y;
        __width = width;
        __height = height;

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
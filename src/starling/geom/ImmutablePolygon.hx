package starling.geom;

import openfl.errors.Error;
import openfl.errors.IllegalOperationError;

import starling.geom.Polygon;

class ImmutablePolygon extends Polygon
{
    @:noCompletion private var __frozen:Bool;

    public function new(vertices:Array<Dynamic>)
    {
        super(vertices);
        __frozen = true;
    }

    override public function addVertices(args:Array<Dynamic>):Void
    {
        if (__frozen) throw getImmutableError();
        else super.addVertices(args);
    }

    override public function setVertex(index:Int, x:Float, y:Float):Void
    {
        if (__frozen) throw getImmutableError();
        else super.setVertex(index, x, y);
    }

    override public function reverse():Void
    {
        if (__frozen) throw getImmutableError();
        else super.reverse();
    }

    override private function set_numVertices(value:Int):Int
    {
        if (__frozen) throw getImmutableError();
        else super.reverse();
        return super.numVertices;
    }

    private function getImmutableError():Error
    {
        var className:String = Type.getClassName(Type.getClass(this)).split(".").pop();
        var msg:String = className + " cannot be modified. Call 'clone' to create a mutable copy.";
        return new IllegalOperationError(msg);
    }
}
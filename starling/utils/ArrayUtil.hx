package starling.utils;
import haxe.ds.Vector;

class ArrayUtil
{

    public static function copyVectorToArray<T>(from:Vector<T>, to:Array<T>)
    {
        for (i in 0 ... from.length)
            to[i] = from[i];
    }
    
    public static function copyArrayToVector<T>(from:Array<T>, to:Vector<T>)
    {
        for (i in 0 ... from.length)
            to[i] = from[i];
    }
}
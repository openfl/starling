// =================================================================================================
//
//	Starling Framework
//	Copyright 2014 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
class Execute{
/** Executes a function with the specified arguments. If the argument count does not match
 *  the function, the argument list is cropped / filled up with <code>null</code> values. */
public static function execute(func:Dynamic, args:Array<Dynamic>):Void
{
    if (func != null)
    {
        var i:Int;
        var maxNumArgs:Int = func.length;

        for(i in 0 ... maxNumArgs)
            args[i] = null;

        func.apply(null, args.slice(0, maxNumArgs));
    }
}
}

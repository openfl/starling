// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import haxe.Constraints.Function;

class Execute
{
    /** Executes a function with the specified arguments. If the argument count does not match
     *  the function, the argument list is cropped / filled up with <code>null</code> values. */
    public static function execute(func:Function, args:Array<Dynamic> = null):Void
    {
        if (func != null)
        {
            if (args == null) args = [];
            
            #if flash
            var maxNumArgs:Int = untyped func.length;
            #elseif neko
            var maxNumArgs:Int = untyped ($nargs)(func);
            #elseif cpp
            var maxNumArgs:Int = untyped func.__ArgCount();
			#elseif html5
			var maxNumArgs:Int = untyped func.length;
            #else
            var maxNumArgs:Int = -1;
            #end

            for (i in args.length...maxNumArgs)
                args[i] = null;

            // In theory, the 'default' case would always work,
            // but we want to avoid the 'slice' allocations.

            switch (maxNumArgs)
            {
                case 0:  func();
                case 1:  func(args[0]);
                case 2:  func(args[0], args[1]);
                case 3:  func(args[0], args[1], args[2]);
                case 4:  func(args[0], args[1], args[2], args[3]);
                case 5:  func(args[0], args[1], args[2], args[3], args[4]);
                case 6:  func(args[0], args[1], args[2], args[3], args[4], args[5]);
                case 7:  func(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                case -1: Reflect.callMethod(func, func, args);
                default: Reflect.callMethod(func, func, args.slice(0, maxNumArgs));
            }
        }
    }
}
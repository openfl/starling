// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
class StringUtil
{
// TODO: add number formatting options

/** Formats a String in .Net-style, with curly braces ("{0}"). Does not support any 
 *  number formatting options yet. */
public static function formatString(format:String, args:Array<Dynamic>):String
{
    for (i in 0 ... args.length)
	{
		var r:EReg = new EReg("\\{" + i + "\\}", "g");
        format = r.replace(format, Std.string (args[i]));
	}
    
    return format;
}
}
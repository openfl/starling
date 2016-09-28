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

/** A class that provides constant values for vertical alignment of objects. */
class VAlign
{
    /** Top alignment. */
    public static inline var TOP:String    = "top";
    
    /** Centered alignment. */
    public static inline var CENTER:String = "center";
    
    /** Bottom alignment. */
    public static inline var BOTTOM:String = "bottom";
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(vAlign:String):Bool
    {
        return vAlign == TOP || vAlign == CENTER || vAlign == BOTTOM;
    }
}
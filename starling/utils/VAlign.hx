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
import starling.errors.AbstractClassError;

/** A class that provides constant values for vertical alignment of objects. */
class VAlign
{
    /** @private */
    public function new() { throw new AbstractClassError(); }
    
    /** Top alignment. */
    inline public static var TOP:String    = "top";
    
    /** Centered alignment. */
    inline public static var CENTER:String = "center";
    
    /** Bottom alignment. */
    inline public static var BOTTOM:String = "bottom";
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(vAlign:String):Bool
    {
        return vAlign == TOP || vAlign == CENTER || vAlign == BOTTOM;
    }
}
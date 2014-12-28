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
import starling.errors.AbstractClassError;

/** A class that provides constant values for horizontal alignment of objects. */
class HAlign
{
    /** @private */
    public function new() { throw new AbstractClassError(); }
    
    /** Left alignment. */
    inline public static var LEFT:String   = "left";
    
    /** Centered alignement. */
    inline public static var CENTER:String = "center";
    
    /** Right alignment. */
    inline public static var RIGHT:String  = "right";
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(hAlign:String):Bool
    {
        return hAlign == LEFT || hAlign == CENTER || hAlign == RIGHT;
    }
}
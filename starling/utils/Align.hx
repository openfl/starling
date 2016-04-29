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

/** A class that provides constant values for horizontal and vertical alignment of objects. */
@:final class Align
{
    /** @private */
    public function new() { throw new AbstractClassError(); }
    
    /** Horizontal left alignment. */
    inline public static var LEFT:String   = "left";
    
    /** Horizontal right alignment. */
    inline public static var RIGHT:String  = "right";

    /** Vertical top alignment. */
    inline public static var TOP:String = "top";

    /** Vertical bottom alignment. */
    inline public static var BOTTOM:String = "bottom";

    /** Centered alignment. */
    inline public static var CENTER:String = "center";
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(align:String):Bool
    {
        return align == LEFT || align == RIGHT || align == CENTER ||
               align == TOP  || align == BOTTOM;
    }

    /** Indicates if the given string is a valid horizontal alignment. */
    public static function isValidHorizontal(align:String):Bool
    {
        return align == LEFT || align == CENTER || align == RIGHT;
    }

    /** Indicates if the given string is a valid vertical alignment. */
    public static function isValidVertical(align:String):Bool
    {
        return align == TOP || align == CENTER || align == BOTTOM;
    }
}
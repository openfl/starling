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

/** A class that provides constant values for horizontal alignment of objects. */
class HAlign
{
    /** Left alignment. */
    public static inline var LEFT:String   = "left";
    
    /** Centered alignement. */
    public static inline var CENTER:String = "center";
    
    /** Right alignment. */
    public static inline var RIGHT:String  = "right";
   
	public static inline var JUSTIFY:String  = "justify";
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(hAlign:String):Bool
    {
        return hAlign == LEFT || hAlign == CENTER || hAlign == RIGHT;
    }
}
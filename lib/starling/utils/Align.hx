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

@:jsRequire("starling/utils/Align", "default")

extern class Align
{
    /** Horizontal left alignment. */
    public static var LEFT:String;
    
    /** Horizontal right alignment. */
    public static var RIGHT:String;

    /** Vertical top alignment. */
    public static var TOP:String;

    /** Vertical bottom alignment. */
    public static var BOTTOM:String;

    /** Centered alignment. */
    public static var CENTER:String;
    
    /** Indicates whether the given alignment string is valid. */
    public static function isValid(align:String):Bool;

    /** Indicates if the given string is a valid horizontal alignment. */
    public static function isValidHorizontal(align:String):Bool;

    /** Indicates if the given string is a valid vertical alignment. */
    public static function isValidVertical(align:String):Bool;
}
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
import openfl.Vector;

/** A utility class containing predefined colors and methods converting between different
 *  color representations. */

@:jsRequire("starling/utils/Color", "default")

extern class Color
{
    public static var WHITE:UInt;
    public static var SILVER:UInt;
    public static var GRAY:UInt;
    public static var BLACK:UInt;
    public static var RED:UInt;
    public static var MAROON:UInt;
    public static var YELLOW:UInt;
    public static var OLIVE:UInt;
    public static var LIME:UInt;
    public static var GREEN:UInt;
    public static var AQUA:UInt;
    public static var TEAL:UInt;
    public static var BLUE:UInt;
    public static var NAVY:UInt;
    public static var FUCHSIA:UInt;
    public static var PURPLE:UInt;

    /** Returns the alpha part of an ARGB color (0 - 255). */
    public static function getAlpha(color:UInt):Int;

    /** Returns the red part of an (A)RGB color (0 - 255). */
    public static function getRed(color:UInt):Int;

    /** Returns the green part of an (A)RGB color (0 - 255). */
    public static function getGreen(color:UInt):Int;

    /** Returns the blue part of an (A)RGB color (0 - 255). */
    public static function getBlue(color:UInt):Int;

    /** Sets the alpha part of an ARGB color (0 - 255). */
    public static function setAlpha(color:UInt, alpha:Int):UInt;

    /** Sets the red part of an (A)RGB color (0 - 255). */
    public static function setRed(color:UInt, red:Int):UInt;

    /** Sets the green part of an (A)RGB color (0 - 255). */
    public static function setGreen(color:UInt, green:Int):UInt;

    /** Sets the blue part of an (A)RGB color (0 - 255). */
    public static function setBlue(color:UInt, blue:Int):UInt;

    /** Creates an RGB color, stored in an unsigned integer. Channels are expected
     * in the range 0 - 255. */
    public static function rgb(red:Int, green:Int, blue:Int):UInt;

    /** Creates an ARGB color, stored in an unsigned integer. Channels are expected
     * in the range 0 - 255. */
    public static function argb(alpha:Int, red:Int, green:Int, blue:Int):UInt;

    /** Converts a color to a vector containing the RGBA components (in this order) scaled
        *  between 0 and 1. */
    public static function toVector(color:UInt, out:Vector<Float>=null):Vector<Float>;

    /** Multiplies all channels of an (A)RGB color with a certain factor. */
    public static function multiply(color:UInt, factor:Float):UInt;

    /** Calculates a smooth transition between one color to the next.
        *  <code>ratio</code> is expected between 0 and 1. */
    public static function interpolate(startColor:UInt, endColor:UInt, ratio:Float):UInt;
}
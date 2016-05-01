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
import starling.errors.AbstractClassError;

/** A utility class containing predefined colors and methods converting between different
 *  color representations. */
class Color
{
    inline public static var WHITE:UInt   = 0xffffff;
    inline public static var SILVER:UInt  = 0xc0c0c0;
    inline public static var GRAY:UInt    = 0x808080;
    inline public static var BLACK:UInt   = 0x000000;
    inline public static var RED:UInt     = 0xff0000;
    inline public static var MAROON:UInt  = 0x800000;
    inline public static var YELLOW:UInt  = 0xffff00;
    inline public static var OLIVE:UInt   = 0x808000;
    inline public static var LIME:UInt    = 0x00ff00;
    inline public static var GREEN:UInt   = 0x008000;
    inline public static var AQUA:UInt    = 0x00ffff;
    inline public static var TEAL:UInt    = 0x008080;
    inline public static var BLUE:UInt    = 0x0000ff;
    inline public static var NAVY:UInt    = 0x000080;
    inline public static var FUCHSIA:UInt = 0xff00ff;
    inline public static var PURPLE:UInt  = 0x800080;
    
    /** Returns the alpha part of an ARGB color (0 - 255). */
    public static function getAlpha(color:UInt):Int { return (color >> 24) & 0xff; }
    
    /** Returns the red part of an (A)RGB color (0 - 255). */
    public static function getRed(color:UInt):Int   { return (color >> 16) & 0xff; }
    
    /** Returns the green part of an (A)RGB color (0 - 255). */
    public static function getGreen(color:UInt):Int { return (color >>  8) & 0xff; }
    
    /** Returns the blue part of an (A)RGB color (0 - 255). */
    public static function getBlue(color:UInt):Int  { return  color        & 0xff; }
    
    /** Creates an RGB color, stored in an unsigned integer. Channels are expected
     *  in the range 0 - 255. */
    public static function rgb(red:Int, green:Int, blue:Int):UInt
    {
        return (red << 16) | (green << 8) | blue;
    }
    
    /** Creates an ARGB color, stored in an unsigned integer. Channels are expected
     *  in the range 0 - 255. */
    public static function argb(alpha:Int, red:Int, green:Int, blue:Int):UInt
    {
        return (alpha << 24) | (red << 16) | (green << 8) | blue;
    }

    /** Converts a color to a vector containing the RGBA components (in this order) scaled
     *  between 0 and 1. */
    public static function toVector(color:UInt, out:Array<Float>=null):Vector<Float>
    {
        if (out == null) out = new Vector<Float>(4);

        out[0] = ((color >> 16) & 0xff) / 255.0;
        out[1] = ((color >>  8) & 0xff) / 255.0;
        out[2] = ( color        & 0xff) / 255.0;
        out[3] = ((color >> 24) & 0xff) / 255.0;

        return out;
    }

    /** Multiplies all channels of an (A)RGB color with a certain factor. */
    public static function multiply(color:UInt, factor:Float):UInt
    {
        var alpha:UInt = Std.int(((color >> 24) & 0xff) * factor);
        var red:UInt   = Std.int(((color >> 16) & 0xff) * factor);
        var green:UInt = Std.int(((color >>  8) & 0xff) * factor);
        var blue:UInt  = Std.int(( color        & 0xff) * factor);

        if (alpha > 255) alpha = 255;
        if (red   > 255) red   = 255;
        if (green > 255) green = 255;
        if (blue  > 255) blue  = 255;

        return argb(alpha, red, green, blue);
    }

    /** Calculates a smooth transition between one color to the next.
     *  <code>ratio</code> is expected between 0 and 1. */
    public static function interpolate(startColor:UInt, endColor:UInt, ratio:Float):UInt
    {
        var startA:UInt = (startColor >> 24) & 0xff;
        var startR:UInt = (startColor >> 16) & 0xff;
        var startG:UInt = (startColor >>  8) & 0xff;
        var startB:UInt = (startColor      ) & 0xff;

        var endA:UInt = (endColor >> 24) & 0xff;
        var endR:UInt = (endColor >> 16) & 0xff;
        var endG:UInt = (endColor >>  8) & 0xff;
        var endB:UInt = (endColor      ) & 0xff;

        var newA:UInt = Std.int(startA + (endA - startA) * ratio);
        var newR:UInt = Std.int(startR + (endR - startR) * ratio);
        var newG:UInt = Std.int(startG + (endG - startG) * ratio);
        var newB:UInt = Std.int(startB + (endB - startB) * ratio);

        return (newA << 24) | (newR << 16) | (newG << 8) | newB;
    }
    
    /** @private */
    public function new() { throw new AbstractClassError(); }
}
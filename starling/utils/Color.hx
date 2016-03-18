// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils
{
import starling.errors.AbstractClassError;

/** A utility class containing predefined colors and methods converting between different
 *  color representations. */
public class Color
{
    public static const WHITE:UInt   = 0xffffff;
    public static const SILVER:UInt  = 0xc0c0c0;
    public static const GRAY:UInt    = 0x808080;
    public static const BLACK:UInt   = 0x000000;
    public static const RED:UInt     = 0xff0000;
    public static const MAROON:UInt  = 0x800000;
    public static const YELLOW:UInt  = 0xffff00;
    public static const OLIVE:UInt   = 0x808000;
    public static const LIME:UInt    = 0x00ff00;
    public static const GREEN:UInt   = 0x008000;
    public static const AQUA:UInt    = 0x00ffff;
    public static const TEAL:UInt    = 0x008080;
    public static const BLUE:UInt    = 0x0000ff;
    public static const NAVY:UInt    = 0x000080;
    public static const FUCHSIA:UInt = 0xff00ff;
    public static const PURPLE:UInt  = 0x800080;
    
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
    
    /** @private */
    public function Color() { throw new AbstractClassError(); }
}
}
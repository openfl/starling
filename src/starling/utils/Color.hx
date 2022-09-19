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
 *  color representations.
 *
 *  <p>The HSL and HSV calculations conform to theory and implementation found on
 *  <a href="https://en.wikipedia.org/wiki/HSL_and_HSV">Wikipedia</a> and
 *  <a href="https://www.rapidtables.com/convert/color/">rapidtables.com</a>.</p>
 */
class Color
{
    public static inline var WHITE:UInt   = 0xffffff;
    public static inline var SILVER:UInt  = 0xc0c0c0;
    public static inline var GRAY:UInt    = 0x808080;
    public static inline var BLACK:UInt   = 0x000000;
    public static inline var RED:UInt     = 0xff0000;
    public static inline var MAROON:UInt  = 0x800000;
    public static inline var YELLOW:UInt  = 0xffff00;
    public static inline var OLIVE:UInt   = 0x808000;
    public static inline var LIME:UInt    = 0x00ff00;
    public static inline var GREEN:UInt   = 0x008000;
    public static inline var AQUA:UInt    = 0x00ffff;
    public static inline var TEAL:UInt    = 0x008080;
    public static inline var BLUE:UInt    = 0x0000ff;
    public static inline var NAVY:UInt    = 0x000080;
    public static inline var FUCHSIA:UInt = 0xff00ff;
    public static inline var PURPLE:UInt  = 0x800080;

    /** Returns the alpha part of an ARGB color (0 - 255). */
    public static function getAlpha(color:UInt):Int { return (color >> 24) & 0xff; }

    /** Returns the red part of an (A)RGB color (0 - 255). */
    public static function getRed(color:UInt):Int   { return (color >> 16) & 0xff; }

    /** Returns the green part of an (A)RGB color (0 - 255). */
    public static function getGreen(color:UInt):Int { return (color >>  8) & 0xff; }

    /** Returns the blue part of an (A)RGB color (0 - 255). */
    public static function getBlue(color:UInt):Int  { return  color        & 0xff; }

    /** Sets the alpha part of an ARGB color (0 - 255). */
    public static function setAlpha(color:UInt, alpha:Int):UInt
    {
        return (color & 0x00ffffff) | (alpha & 0xff) << 24;
    }

    /** Sets the red part of an (A)RGB color (0 - 255). */
    public static function setRed(color:UInt, red:Int):UInt
    {
        return (color & 0xff00ffff) | (red & 0xff) << 16;
    }

    /** Sets the green part of an (A)RGB color (0 - 255). */
    public static function setGreen(color:UInt, green:Int):UInt
    {
        return (color & 0xffff00ff) | (green & 0xff) << 8;
    }

    /** Sets the blue part of an (A)RGB color (0 - 255). */
    public static function setBlue(color:UInt, blue:Int):UInt
    {
        return (color & 0xffffff00) | (blue & 0xff);
    }

    /** Creates an RGB color, stored in an unsigned integer. Channels are expected
     * in the range 0 - 255. */
    public static function rgb(red:Int, green:Int, blue:Int):UInt
    {
        return (red << 16) | (green << 8) | blue;
    }

    /** Creates an ARGB color, stored in an unsigned integer. Channels are expected
     * in the range 0 - 255. */
    public static function argb(alpha:Int, red:Int, green:Int, blue:Int):UInt
    {
        return (alpha << 24) | (red << 16) | (green << 8) | blue;
    }
	
	/** Creates an RGB color from hue, saturation and value (brightness).
	 *  Assumes hue, saturation, and value are contained in the range [0, 1].
	 */
	public static function hsv(hue:Float, saturation:Float, value:Float):UInt
	{
		var r:Float = 0, g:Float = 0, b:Float = 0;
		var i:Float = Math.ffloor(hue * 6);
		var f:Float = hue * 6 - i;
		var p:Float = value * (1 - saturation);
		var q:Float = value * (1 - f * saturation);
		var t:Float = value * (1 - (1 - f) * saturation);
		
		switch (Std.int(i % 6))
		{
			case 0: r = value; g = t; b = p;
			case 1: r = q; g = value; b = p;
			case 2: r = p; g = value; b = t;
			case 3: r = p; g = q; b = value;
			case 4: r = t; g = p; b = value;
			case 5: r = value; g = p; b = q;
		}
		
		return rgb(Math.ceil(r * 255), Math.ceil(g * 255), Math.ceil(b * 255));
	}
	
	/** Creates an RGB color from hue, saturation and lightness.
	 *  Assumes hue, saturation, and lightness are contained in the range [0, 1].
	 */
	public static function hsl(hue:Float, saturation:Float, lightness:Float):UInt
	{
		var r:Float = 0, g:Float = 0, b:Float = 0;
		var c:Float = (1.0 - Math.abs(2.0 * lightness - 1.0)) * saturation;
		var h2:Float = hue * 6.0;
		var x:Float = c * (1.0 - Math.abs(h2 % 2 - 1.0));
		var m:Float = lightness - c / 2.0;
		
		switch (Std.int(h2 % 6))
		{
			case 0: r = c + m; g = x + m; b = m;
			case 1: r = x + m; g = c + m; b = m;
			case 2: r = m; g = c + m; b = x + m;
			case 3: r = m; g = x + m; b = c + m;
			case 4: r = x + m; g = m; b = c + m;
			case 5: r = c + m; g = m; b = x + m;
		}
		
		return rgb(Math.ceil(r * 255), Math.ceil(g * 255), Math.ceil(b * 255));
	}
	
	/** Converts an RGB color into a vector with HSV components.
	 *
	 *  @param rgb  the standard RGB color
	 *  @param hsv  a vector to be used for the result; passing null will create a new one.
	 *  @return     a vector containing hue, saturation, and value, in this order. Range: [0..1]
	 */
	public static function rgbToHsv(rgb:UInt, hsv:Vector<Float> = null):Vector<Float>
	{
		if (hsv == null) hsv = new Vector<Float>(3, true);
		
		var r:Float = Color.getRed(rgb) / 255.0;
		var g:Float = Color.getGreen(rgb) / 255.0;
		var b:Float = Color.getBlue(rgb) / 255.0;
		var t:Float = Math.max(r, g);
		var cMax:Float = Math.max(t, b);
		t = Math.min(r, g);
		var cMin:Float = Math.min(t, b);
		var delta:Float = cMax - cMin;
		
		// hue
		if (delta == 0)     hsv[0] = 0;
		else if (cMax == r) hsv[0] = (((g - b) / delta) % 6) / 6.0;
		else if (cMax == g) hsv[0] = ((b - r) / delta + 2) / 6.0;
		else if (cMax == b) hsv[0] = ((r - g) / delta + 4) / 6.0;

		// normalize [0..1]
		while (hsv[0] <  0.0) hsv[0] += 1.0;
		while (hsv[0] >= 1.0) hsv[0] -= 1.0;

		// value / brightness
		hsv[2] = cMax;

		// saturation
		hsv[1] = cMax == 0 ? 0 : delta / cMax;
		
		return hsv;
	}
	
	/** Converts an RGB color into a vector with HSV components.
	 *
	 *  @param rgb  the standard RGB color
	 *  @param hsl  a vector to be used for the result; passing null will create a new one.
	 *  @return     a vector containing hue, saturation, and lightness, in this order. Range: [0..1]
	 */
	public static function rgbToHsl(rgb:UInt, hsl:Vector<Float> = null):Vector<Float>
	{
		if (hsl == null) hsl = new Vector<Float>(3, true);
		
		var r:Float = Color.getRed(rgb) / 255.0;
		var g:Float = Color.getGreen(rgb) / 255.0;
		var b:Float = Color.getBlue(rgb) / 255.0;
		var t:Float = Math.max(r, g);
		var cMax:Float = Math.max(t, b);
		t = Math.min(r, g);
		var cMin:Float = Math.min(t, b);
		var delta:Float = cMax - cMin;
		
		// hue
		if (delta == 0)     hsl[0] = 0;
		else if (cMax == r) hsl[0] = (((g - b) / delta) % 6) / 6.0;
		else if (cMax == g) hsl[0] = ((b - r) / delta + 2) / 6.0;
		else if (cMax == b) hsl[0] = ((r - g) / delta + 4) / 6.0;

		// normalize [0..1]
		while (hsl[0] <  0.0) hsl[0] += 1.0;
		while (hsl[0] >= 1.0) hsl[0] -= 1.0;

		// lightness
		hsl[2] = (cMax + cMin) * 0.5;

		// saturation
		hsl[1] = delta == 0 ? 0 : delta / (1.0 - Math.abs(2.0 * hsl[2] - 1.0));

		return hsl;
	}

    /** Converts a color to a vector containing the RGBA components (in this order) scaled
	 *  between 0 and 1. */
    public static function toVector(color:UInt, out:Vector<Float>=null):Vector<Float>
    {
        if (out == null) out = new Vector<Float>(4, true);

        out[0] = ((color >> 16) & 0xff) / 255.0;
        out[1] = ((color >>  8) & 0xff) / 255.0;
        out[2] = ( color        & 0xff) / 255.0;
        out[3] = ((color >> 24) & 0xff) / 255.0;

        return out;
    }

    /** Multiplies all channels of an (A)RGB color with a certain factor. */
    public static function multiply(color:UInt, factor:Float):UInt
    {
        if (factor == 0.0) return 0x0;

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
        var startA:Int = (startColor >> 24) & 0xff;
        var startR:Int = (startColor >> 16) & 0xff;
        var startG:Int = (startColor >>  8) & 0xff;
        var startB:Int = (startColor      ) & 0xff;

        var endA:Int = (endColor >> 24) & 0xff;
        var endR:Int = (endColor >> 16) & 0xff;
        var endG:Int = (endColor >>  8) & 0xff;
        var endB:Int = (endColor      ) & 0xff;

        var newA:UInt = Std.int(startA + (endA - startA) * ratio);
        var newR:UInt = Std.int(startR + (endR - startR) * ratio);
        var newG:UInt = Std.int(startG + (endG - startG) * ratio);
        var newB:UInt = Std.int(startB + (endB - startB) * ratio);

        return (newA << 24) | (newR << 16) | (newG << 8) | newB;
    }
}
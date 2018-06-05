import Vector from "openfl/Vector";

declare namespace starling.utils
{
	/** A utility class containing predefined colors and methods converting between different
	 *  color representations. */
	export class Color
	{
		public static WHITE:number;
		public static SILVER:number;
		public static GRAY:number;
		public static BLACK:number;
		public static RED:number;
		public static MAROON:number;
		public static YELLOW:number;
		public static OLIVE:number;
		public static LIME:number;
		public static GREEN:number;
		public static AQUA:number;
		public static TEAL:number;
		public static BLUE:number;
		public static NAVY:number;
		public static FUCHSIA:number;
		public static PURPLE:number;
	
		/** Returns the alpha part of an ARGB color (0 - 255). */
		public static getAlpha(color:number):number;
	
		/** Returns the red part of an (A)RGB color (0 - 255). */
		public static getRed(color:number):number;
	
		/** Returns the green part of an (A)RGB color (0 - 255). */
		public static getGreen(color:number):number;
	
		/** Returns the blue part of an (A)RGB color (0 - 255). */
		public static getBlue(color:number):number;
	
		/** Sets the alpha part of an ARGB color (0 - 255). */
		public static setAlpha(color:number, alpha:number):number;
	
		/** Sets the red part of an (A)RGB color (0 - 255). */
		public static setRed(color:number, red:number):number;
	
		/** Sets the green part of an (A)RGB color (0 - 255). */
		public static setGreen(color:number, green:number):number;
	
		/** Sets the blue part of an (A)RGB color (0 - 255). */
		public static setBlue(color:number, blue:number):number;
	
		/** Creates an RGB color, stored in an unsigned integer. Channels are expected
		 * in the range 0 - 255. */
		public static rgb(red:number, green:number, blue:number):number;
	
		/** Creates an ARGB color, stored in an unsigned integer. Channels are expected
		 * in the range 0 - 255. */
		public static argb(alpha:number, red:number, green:number, blue:number):number;
	
		/** Converts a color to a vector containing the RGBA components (in this order) scaled
			*  between 0 and 1. */
		public static toVector(color:number, out?:Vector<number>):Vector<number>;
	
		/** Multiplies all channels of an (A)RGB color with a certain factor. */
		public static multiply(color:number, factor:number):number;
	
		/** Calculates a smooth transition between one color to the next.
			*  <code>ratio</code> is expected between 0 and 1. */
		public static interpolate(startColor:number, endColor:number, ratio:number):number;
	}
}

export default starling.utils.Color;
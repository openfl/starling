import FragmentFilter from "./../../starling/filters/FragmentFilter";
import ColorMatrixEffect from "./../../starling/filters/ColorMatrixEffect";
import Color from "./../../starling/utils/Color";
import Vector from "openfl/Vector";
import FilterEffect from "./../rendering/FilterEffect";

declare namespace starling.filters
{
	/** The ColorMatrixFilter class lets you apply a 4x5 matrix transformation to the color
	 *  and alpha values of every pixel in the input image to produce a result with a new set
	 *  of color and alpha values. This allows saturation changes, hue rotation,
	 *  luminance to alpha, and various other effects.
	 *
	 *  <p>The class contains several convenience methods for frequently used color
	 *  adjustments. All those methods change the current matrix, which means you can easily
	 *  combine them in one filter:</p>
	 *
	 *  <listing>
	 *  // create an inverted filter with 50% saturation and 180° hue rotation
	 *  filter:ColorMatrixFilter = new ColorMatrixFilter();
	 *  filter.invert();
	 *  filter.adjustSaturation(-0.5);
	 *  filter.adjustHue(1.0);</listing>
	 *
	 *  <p>If you want to gradually animate one of the predefined color adjustments, either reset
	 *  the matrix after each step, or use an identical adjustment value for each step; the
	 *  changes will add up.</p>
	 */
	export class ColorMatrixFilter extends FragmentFilter
	{
		/** Creates a new ColorMatrixFilter instance with the specified matrix.
		 *  @param matrix a vector of 20 items arranged as a 4x5 matrix.
		 */
		public constructor(matrix?:Vector<number>);
	
		// color manipulation
	
		/** Inverts the colors of the filtered object. */
		public invert():void;
	
		/** Changes the saturation. Typical values are in the range (-1, 1).
		 *  Values above zero will raise, values below zero will reduce the saturation.
		 *  '-1' will produce a grayscale image. */
		public adjustSaturation(sat:number):void;
	
		/** Changes the contrast. Typical values are in the range (-1, 1).
		 *  Values above zero will raise, values below zero will reduce the contrast. */
		public adjustContrast(value:number):void;
	
		/** Changes the brightness. Typical values are in the range (-1, 1).
		 *  Values above zero will make the image brighter, values below zero will make it darker.*/
		public adjustBrightness(value:number):void;
	
		/** Changes the hue of the image. Typical values are in the range (-1, 1). */
		public adjustHue(value:number):void;
	
		/** Tints the image in a certain color, analog to what can be done in Adobe Animate.
		 *
		 *  @param color   the RGB color with which the image should be tinted.
		 *  @param amount  the intensity with which tinting should be applied. Range (0, 1).
		 */
		public tint(color:number, amount?:number):void;
	
		// matrix manipulation
	
		/** Changes the filter matrix back to the identity matrix. */
		public reset():void;
	
		/** Concatenates the current matrix with another one. */
		public concat(matrix:Vector<number>):void;
	
		/** Concatenates the current matrix with another one, passing its contents directly. */
		public concatValues(m0:number, m1:number, m2:number, m3:number, m4:number,
									 m5:number, m6:number, m7:number, m8:number, m9:number,
									 m10:number, m11:number, m12:number, m13:number, m14:number,
									 m15:number, m16:number, m17:number, m18:number, m19:number):void;
	
		/** A vector of 20 items arranged as a 4x5 matrix. */
		public matrix:Vector<number>;
		protected get_matrix():Vector<number>;
		protected set_matrix(value:Vector<number>):Vector<number>;
	
		public readonly colorEffect:ColorMatrixEffect;
		protected get_colorEffect():ColorMatrixEffect;
	}
	
	export class ColorMatrixEffect extends FilterEffect
	{
		public constructor();
	
		// matrix manipulation
	
		public reset():void;
	
		/** Concatenates the current matrix with another one. */
		public concat(matrix:Vector<number>):void;
	
		// properties
	
		public matrix:Vector<number>;
		protected get_matrix():Vector<number>;
		protected set_matrix(value:Vector<number>):Vector<number>;
	}
}

export default starling.filters.ColorMatrixFilter;
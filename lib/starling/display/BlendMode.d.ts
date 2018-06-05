// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import Context3DBlendFactor from "openfl/display3D/Context3DBlendFactor";

declare namespace starling.display
{
	/** A class that provides constant values for visual blend mode effects. 
	 *   
	 *  <p>A blend mode is always defined by two 'Context3DBlendFactor' values. A blend factor 
	 *  represents a particular four-value vector that is multiplied with the source or destination
	 *  color in the blending formula. The blending formula is:</p>
	 * 
	 *  <pre>result = source � sourceFactor + destination � destinationFactor</pre>
	 * 
	 *  <p>In the formula, the source color is the output color of the pixel shader program. The 
	 *  destination color is the color that currently exists in the color buffer, as set by 
	 *  previous clear and draw operations.</p>
	 *  
	 *  <p>Beware that blending factors produce different output depending on the texture type.
	 *  Textures may contain 'premultiplied alpha' (pma), which means that their RGB values were 
	 *  multiplied with their alpha value (to save processing time). Textures based on 'BitmapData'
	 *  objects have premultiplied alpha values, while ATF textures haven't. For this reason, 
	 *  a blending mode may have different factors depending on the pma value.</p>
	 *  
	 *  @see openfl.display3D.Context3DBlendFactor
	 */
	export class BlendMode
	{
		/** Creates a new BlendMode instance. Don't call this method directly; instead,
		 *  register a new blend mode using <code>BlendMode.register</code>. */
		public constructor(name:string, sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor);
		
		/** Inherits the blend mode from this display object's parent. */
		public static AUTO:string;

		/** Deactivates blending, i.e. disabling any transparency. */
		public static NONE:string;
		
		/** The display object appears in front of the background. */
		public static NORMAL:string;
		
		/** Adds the values of the colors of the display object to the colors of its background. */
		public static ADD:string;
		
		/** Multiplies the values of the display object colors with the the background color. */
		public static MULTIPLY:string;
		
		/** Multiplies the complement (inverse) of the display object color with the complement of 
		 * the background color, resulting in a bleaching effect. */
		public static SCREEN:string;
		
		/** Erases the background when drawn on a RenderTexture. */
		public static ERASE:string;

		/** When used on a RenderTexture, the drawn object will act as a mask for the current
		 * content, i.e. the source alpha overwrites the destination alpha. */
		public static MASK:string;

		/** Draws under/below existing objects; useful especially on RenderTextures. */
		public static BELOW:string;

		// static access methods
		
		/** Returns the blend mode with the given name.
		 *  Throws an ArgumentError if the mode does not exist. */
		public static get(modeName:string):BlendMode;

		/** Returns allready registered blend mode by
		* given blend mode factors. Returns null if not exist.*/
		public static getByFactors(srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):Null<BlendMode>;
		
		/** Registers a blending mode under a certain name. */
		public static register(name:string, srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):BlendMode;
		
		// instance methods / properties

		/** Sets the appropriate blend factors for source and destination on the current context. */
		public activate():void;

		/** Returns the name of the blend mode. */
		public toString():string;

		/** The source blend factor of this blend mode. */
		public readonly sourceFactor:string;
		protected get_sourceFactor():string;

		/** The destination blend factor of this blend mode. */
		public readonly destinationFactor:string;
		protected get_destinationFactor():string;

		/** Returns the name of the blend mode. */
		public readonly name:string;
		protected get_name():string;
	}
}

export default starling.display.BlendMode;
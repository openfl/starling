import Starling from "./../../starling/core/Starling";
import Color from "./../../starling/utils/Color";
import ArgumentError from "openfl/errors/ArgumentError";
import Execute from "./../../starling/utils/Execute";
import Error from "openfl/errors/Error";

declare namespace starling.utils
{
	/** A utility class containing methods related to Stage3D and rendering in general. */
	export class RenderUtil
	{
		/** Clears the render context with a certain color and alpha value. */
		public static clear(rgb?:number, alpha?:number,
										depth?:number, stencil?:number):void;
	
		/** Returns the flags that are required for AGAL texture lookup,
		 *  including the '&lt;' and '&gt;' delimiters. */
		public static getTextureLookupFlags(format:string, mipMapping:boolean,
														repeat?:boolean,
														smoothing?:string):string;
	
		/** Returns a bit field uniquely describing texture format and premultiplied alpha,
		 *  so that each required AGAL variant will get its unique ID. This method is most
		 *  useful when overriding the <code>programVariantName</code> method of custom
		 *  effects.
		 *
		 *  @return a bit field using the 3 least significant bits.
		 */
		public static getTextureVariantBits(texture:Texture):number;
	
		/** Calls <code>setSamplerStateAt</code> at the current context,
		 *  converting the given parameters to their low level counterparts. */
		public static setSamplerStateAt(sampler:number, mipMapping:boolean,
													smoothing?:string,
													repeat?:boolean):void;
	
		/** Creates an AGAL source string with a <code>tex</code> operation, including an options
		 *  list with the appropriate format flag.
		 *
		 *  <p>Note that values for <code>repeat/clamp</code>, <code>filter</code> and
		 *  <code>mip-filter</code> are not included in the options list, since it's preferred
		 *  to set those values at runtime via <code>setSamplerStateAt</code>.</p>
		 *
		 *  <p>Starling expects every color to have its alpha value premultiplied into
		 *  the RGB channels. Thus, if this method encounters a non-PMA texture, it will
		 *  (per default) convert the color in the result register to PMA mode, resulting
		 *  in an additional <code>mul</code>-operation.</p>
		 *
		 *  @param resultReg  the register to write the result into.
		 *  @param uvReg      the register containing the texture coordinates.
		 *  @param sampler    the texture sampler to use.
		 *  @param texture    the texture that's active in the given texture sampler.
		 *  @param convertToPmaIfRequired  indicates if a non-PMA color should be converted to PMA.
		 *  @param tempReg    if 'resultReg' is the output register and PMA conversion is done,
		 *                    a temporary register is needed.
		 *
		 *  @return the AGAL source code, line break(s) included.
		 */
		public static createAGALTexOperation(
				resultReg:string, uvReg:string, sampler:number, texture:Texture,
				convertToPmaIfRequired?:boolean, tempReg?:string):string;
	
		/** Requests a context3D object from the given Stage3D object.
			*
			* @param stage3D    The stage3D object the context needs to be requested from.
			* @param renderMode The 'Context3DRenderMode' to use when requesting the context.
			* @param profile    If you know exactly which 'Context3DProfile' you want to use, simply
			*                   pass a String with that profile.
			*
			*                   <p>If you are unsure which profiles are supported on the current
			*                   device, you can also pass an Array of profiles; they will be
			*                   tried one after the other (starting at index 0), until a working
			*                   profile is found. If none of the given profiles is supported,
			*                   the Stage3D object will dispatch an ERROR event.</p>
			*
			*                   <p>You can also pass the String 'auto' to use the best available
			*                   profile automatically. This will try all known Stage3D profiles,
			*                   beginning with the most powerful.</p>
			*/
		public static requestContext3D(stage3D:Stage3D, renderMode:string, profile:any):void;
	}
}

export default starling.utils.RenderUtil;
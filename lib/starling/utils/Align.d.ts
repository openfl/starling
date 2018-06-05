
import AbstractClassError from "./../../starling/errors/AbstractClassError";

declare namespace starling.utils
{
	/** A class that provides constant values for horizontal and vertical alignment of objects. */
	export class Align
	{
		/** Horizontal left alignment. */
		public static LEFT:string;
		
		/** Horizontal right alignment. */
		public static RIGHT:string;
	
		/** Vertical top alignment. */
		public static TOP:string;
	
		/** Vertical bottom alignment. */
		public static BOTTOM:string;
	
		/** Centered alignment. */
		public static CENTER:string;
		
		/** Indicates whether the given alignment string is valid. */
		public static isValid(align:string):boolean;
	
		/** Indicates if the given string is a valid horizontal alignment. */
		public static isValidHorizontal(align:string):boolean;
	
		/** Indicates if the given string is a valid vertical alignment. */
		public static isValidVertical(align:string):boolean;
	}
}

export default starling.utils.Align;
import Image from "./../../starling/display/Image";

declare namespace starling.text
{
	/** A BitmapChar contains the information about one char of a bitmap font.  
	 *  <em>You don't have to use this class directly in most cases. 
	 *  The TextField class contains methods that handle bitmap fonts for you.</em>    
	 */ 
	export class BitmapChar
	{
		/** Creates a char with a texture and its properties. */
		public constructor(id:number, texture:Texture, 
								   xOffset:number, yOffset:number, xAdvance:number);
		
		/** Adds kerning information relative to a specific other character ID. */
		public addKerning(charID:number, amount:number):void;
		
		/** Retrieve kerning information relative to the given character ID. */
		public getKerning(charID:number):number;
		
		/** Creates an image of the char. */
		public createImage():Image;
		
		/** The unicode ID of the char. */
		public readonly charID:number;
		protected get_charID():number;
		
		/** The number of points to move the char in x direction on character arrangement. */
		public readonly xOffset:number;
		protected get_xOffset():number;
		
		/** The number of points to move the char in y direction on character arrangement. */
		public readonly yOffset:number;
		protected get_yOffset():number;
		
		/** The number of points the cursor has to be moved to the right for the next char. */
		public readonly xAdvance:number;
		protected get_xAdvance():number;
		
		/** The texture of the character. */
		public readonly texture:Texture;
		protected get_texture():Texture;
		
		/** The width of the character in points. */
		public readonly width:number;
		protected get_width():number;
		
		/** The height of the character in points. */
		public readonly height:number;
		protected get_height():number;
	}
}

export default starling.text.BitmapChar;
import ITextCompositor from "./../../starling/text/ITextCompositor";
import Rectangle from "openfl/geom/Rectangle";
import Texture from "./../../starling/textures/Texture";
import BitmapChar from "./../../starling/text/BitmapChar";
import Vector from "openfl/Vector";
import Sprite from "./../../starling/display/Sprite";
import CharLocation from "./../../starling/text/CharLocation";
import ArrayUtil from "./../../starling/utils/ArrayUtil";
import TextOptions from "./../../starling/text/TextOptions";
import MiniBitmapFont from "./../../starling/text/MiniBitmapFont";
import ArgumentError from "openfl/errors/ArgumentError";
import Image from "./../../starling/display/Image";

declare namespace starling.text
{
	/** The BitmapFont class parses bitmap font files and arranges the glyphs
	 *  in the form of a text.
	 *
	 *  The class parses the XML format as it is used in the 
	 *  <a href="http://www.angelcode.com/products/bmfont/">AngelCode Bitmap Font Generator</a> or
	 *  the <a href="http://glyphdesigner.71squared.com/">Glyph Designer</a>. 
	 *  This is what the file format looks like:
	 *
	 *  <pre> 
	 *  &lt;font&gt;
	 *    &lt;info face="BranchingMouse" size="40" /&gt;
	 *    &lt;common lineHeight="40" /&gt;
	 *    &lt;pages&gt;  &lt;!-- currently, only one page is supported --&gt;
	 *      &lt;page id="0" file="texture.png" /&gt;
	 *    &lt;/pages&gt;
	 *    &lt;chars&gt;
	 *      &lt;char id="32" x="60" y="29" width="1" height="1" xoffset="0" yoffset="27" xadvance="8" /&gt;
	 *      &lt;char id="33" x="155" y="144" width="9" height="21" xoffset="0" yoffset="6" xadvance="9" /&gt;
	 *    &lt;/chars&gt;
	 *    &lt;kernings&gt; &lt;!-- Kerning is optional --&gt;
	 *      &lt;kerning first="83" second="83" amount="-4"/&gt;
	 *    &lt;/kernings&gt;
	 *  &lt;/font&gt;
	 *  </pre>
	 *  
	 *  Pass an instance of this class to the method <code>registerBitmapFont</code> of the
	 *  TextField class. Then, set the <code>fontName</code> property of the text field to the 
	 *  <code>name</code> value of the bitmap font. This will make the text field use the bitmap
	 *  font.  
	 */ 
	export class BitmapFont implements ITextCompositor
	{
		/** Use this constant for the <code>fontSize</code> property of the TextField class to 
		 * render the bitmap font in exactly the size it was created. */ 
		public static NATIVE_SIZE:number;
		
		/** The font name of the embedded minimal bitmap font. Use this e.g. for debug output. */
		public static MINI:string;
		
		/** Creates a bitmap font from the given texture and font data.
		 *  If you don't pass any data, the "mini" font will be created.
		 *
		 * @param texture  The texture containing all the glyphs.
		 * @param fontData Typically an XML file in the standard AngelCode format. override the
		 *                 the 'parseFontData' method to add support for additional formats.
		 */
		public constructor(texture?:Texture, fontData?:any);
		
		/** Disposes the texture of the bitmap font! */
		public dispose():void;
		
		/** Returns a single bitmap char with a certain character ID. */
		public getChar(charID:number):BitmapChar;
		
		/** Adds a bitmap char with a certain character ID. */
		public addChar(charID:number, bitmapChar:BitmapChar):void;
		
		/** Returns a vector containing all the character IDs that are contained in this font. */
		public getCharIDs(result?:Vector<number>):Vector<number>;
	
		/** Checks whether a provided string can be displayed with the font. */
		public hasChars(text:string):boolean;
	
		/** Creates a sprite that contains a certain text, made up by one image per char. */
		public createSprite(width:number, height:number, text:string,
									 format:TextFormat, options?:TextOptions):Sprite;
		
		/** Draws text into a QuadBatch. */
		public fillMeshBatch(meshBatch:MeshBatch, width:number, height:number, text:string,
									  format:TextFormat, options?:TextOptions):void;
	
		/** @inheritDoc */
		public clearMeshBatch(meshBatch:MeshBatch):void;
		
		/** @inheritDoc */
		public getDefaultMeshStyle(previousStyle:MeshStyle,
											format:TextFormat, options:TextOptions):MeshStyle;
		
		/** Arranges the characters of text inside a rectangle, adhering to the given settings.
		 *  Returns a Vector of BitmapCharLocations.
		 *
		 *  <p>BEWARE: This method uses an object pool for the returned vector and all
		 *  (returned and temporary) BitmapCharLocation instances. Do not save any references and
		 *  always call <code>BitmapCharLocation.rechargePool()</code> when you are done processing.
		 *  </p>
		 */
		public arrangeChars(width:number, height:number, text:string,
									  format:TextFormat, options:TextOptions):Vector<BitmapCharLocation>;
		
		/** The name of the font as it was parsed from the font file. */
		public readonly name:string;
		protected get_name():string;
		
		/** The native size of the font. */
		public readonly size:number;
		protected get_size():number;
			
		/** The type of the bitmap font. @see starling.text.BitmapFontType @default standard */
		public type:string;
		public get_type():string;
		public set_type(value:string):string;
	
		/** If the font uses a distance field texture, this property returns its spread (i.e.
		 *  the width of the blurred edge in points). */
		public distanceFieldSpread:number;
		public get_distanceFieldSpread():number;
		public set_distanceFieldSpread(value:number):number;
		
		/** The height of one line in points. */
		public readonly lineHeight:number;
		protected get_lineHeight():number;
		protected set_lineHeight(value:number):void;
		
		/** The smoothing filter that is used for the texture. */ 
		public smoothing:string;
		protected get_smoothing():string;
		protected set_smoothing(value:string):string;
		
		/** The baseline of the font. This property does not affect text rendering;
		 * it's just an information that may be useful for exact text placement. */
		public baseline:number;
		protected get_baseline():number;
		protected set_baseline(value:number):number;
		
		/** An offset that moves any generated text along the x-axis (in points).
		 * Useful to make up for incorrect font data. @default 0. */ 
		public offsetX:number;
		protected get_offsetX():number;
		protected set_offsetX(value:number):number;
		
		/** An offset that moves any generated text along the y-axis (in points).
		 * Useful to make up for incorrect font data. @default 0. */
		public offsetY:number;
		protected get_offsetY():number;
		protected set_offsetY(value:number):number;
	
		/** The width of a "gutter" around the composed text area, in points.
		 *  This can be used to bring the output more in line with standard TrueType rendering:
		 *  Flash always draws them with 2 pixels of padding. @default 0.0 */
		public padding:number;
		protected get_padding():number;
		protected set_padding(value:number):number;
	
		/** The underlying texture that contains all the chars. */
		protected get_texture():Texture;
	}
}

export default starling.text.BitmapFont;
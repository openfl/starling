import EventDispatcher from "./../../starling/events/EventDispatcher";
import OpenFLTextFormat from "openfl/text/TextFormat";
import Align from "./../../starling/utils/Align";
import ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.text
{
	/** Dispatched when any property of the instance changes. */
	// @:meta(Event(name="change", type="starling.events.Event"))
	
	/** The TextFormat class represents character formatting information. It is used by the
	 *  TextField and BitmapFont classes to characterize the way the glyphs will be rendered.
	 *
	 *  <p>Note that not all properties are used by all font renderers: bitmap fonts ignore
	 *  the "bold", "italic", and "underline" values.</p>
	 */
	export class TextFormat extends EventDispatcher
	{
		/** Creates a new TextFormat instance with the given properties. */
		public constructor(font?:string, size?:number, color?:number,
							horizontalAlign?:string, verticalAlign?:string);
	
		/** Copies all properties from another TextFormat instance. */
		public copyFrom(format:TextFormat):void;
	
		/** Creates a clone of this instance. */
		public clone():TextFormat;
	
		/** Sets the most common properties at once. */
		public setTo(font?:string, size?:number, color?:number,
							  horizontalAlign?:string, verticalAlign?:string):void;
	
		/** Converts the Starling TextFormat instance to a Flash TextFormat. */
		public toNativeFormat(out?:OpenFLTextFormat):OpenFLTextFormat;
	
		/** The name of the font. TrueType fonts will be looked up from embedded fonts and
		 *  system fonts; bitmap fonts must be registered at the TextField class first.
		 *  Beware: If you loaded an embedded font at runtime, you must call
		 *  <code>TextField.updateEmbeddedFonts()</code> for Starling to recognize it.
		 */
		public font:string;
		protected get_font():string;
		protected set_font(value:string):string;
	
		/** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
		 *  the original size. */
		public size:number;
		protected get_size():number;
		protected set_size(value:number):number;
	
		/** The color of the text. Note that bitmap fonts should be exported in plain white so
		 *  that tinting works correctly. If your bitmap font contains colors, set this property
		 *  to <code>Color.WHITE</code> to get the desired result. @default black */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** Indicates whether the text is bold. @default false */
		public bold:boolean;
		protected get_bold():boolean;
		protected set_bold(value:boolean):boolean;
	
		/** Indicates whether the text is italicized. @default false */
		public italic:boolean;
		protected get_italic():boolean;
		protected set_italic(value:boolean):boolean;
	
		/** Indicates whether the text is underlined. @default false */
		public underline:boolean;
		protected get_underline():boolean;
		protected set_underline(value:boolean):boolean;
	
		/** The horizontal alignment of the text. @default center
		 *  @see starling.utils.Align */
		public horizontalAlign:string;
		protected get_horizontalAlign():string;
		protected set_horizontalAlign(value:string):string;
	
		/** The vertical alignment of the text. @default center
		 *  @see starling.utils.Align */
		public verticalAlign:string;
		protected get_verticalAlign():string;
		protected set_verticalAlign(value:string):string;
	
		/** Indicates whether kerning is enabled. Kerning adjusts the pixels between certain
		 *  character pairs to improve readability. @default true */
		public kerning:boolean;
		protected get_kerning():boolean;
		protected set_kerning(value:boolean):boolean;
	
		/** The amount of vertical space (called 'leading') between lines. @default 0 */
		public leading:number;
		protected get_leading():number;
		protected set_leading(value:number):number;
		
		/** A number representing the amount of space that is uniformly distributed between all characters. @default 0 */
		public letterSpacing:number;
		protected get_letterSpacing():number;
		protected set_letterSpacing(value:number):number;
	}
}

export default starling.text.TextFormat;
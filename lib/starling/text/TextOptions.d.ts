import EventDispatcher from "./../../starling/events/EventDispatcher";
import Starling from "./../../starling/core/Starling";
import TextField from "./../../starling/text/TextField";

declare namespace starling.text
{
	/** Dispatched when any property of the instance changes. */
	// @:meta(Event(name="change", type="starling.events.Event"))
	
	/** The TextOptions class contains data that describes how the letters of a text should
	 *  be assembled on text composition.
	 *
	 *  <p>Note that not all properties are supported by all text compositors.</p>
	 */
	export class TextOptions extends EventDispatcher
	{
		/** Creates a new TextOptions instance with the given properties. */
		public constructor(wordWrap?:boolean, autoScale?:boolean);
	
		/** Copies all properties from another TextOptions instance. */
		public copyFrom(options:TextOptions):void;
	
		/** Creates a clone of this instance. */
		public clone():TextOptions;
	
		/** Indicates if the text should be wrapped at word boundaries if it does not fit into
		 *  the TextField otherwise. @default true */
		public wordWrap:boolean;
		protected get_wordWrap():boolean;
		protected set_wordWrap(value:boolean):boolean;
	
		/** Specifies the type of auto-sizing set on the TextField. Custom text compositors may
		 *  take this into account, though the basic implementation (done by the TextField itself)
		 *  is often sufficient: it passes a very big size to the <code>fillMeshBatch</code>
		 *  method and then trims the result to the actually used area. @default none */
		public autoSize:string;
		protected get_autoSize():string;
		protected set_autoSize(value:string):string;
	
		/** Indicates whether the font size is automatically reduced if the complete text does
		 *  not fit into the TextField. @default false */
		public autoScale:boolean;
		protected get_autoScale():boolean;
		protected set_autoScale(value:boolean):boolean;
	
		/** Indicates if text should be interpreted as HTML code. For a description
		 *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
		 *  Beware: Only supported for TrueType fonts. @default false */
		public isHtmlText:boolean;
		protected get_isHtmlText():boolean;
		protected set_isHtmlText(value:boolean):boolean;
	
		// #if flash
		// /** An optional style sheet to be used for HTML text. @default null */
		// public styleSheet:StyleSheet;
		// protected get_styleSheet():StyleSheet;
		// protected set_styleSheet(value:StyleSheet):StyleSheet;
		// #end
	
		/** The scale factor of any textures that are created during text composition.
		 *  @default Starling.contentScaleFactor */
		public textureScale:number;
		protected get_textureScale():number;
		protected set_textureScale(value:number):number;
	
		/** The Context3DTextureFormat of any textures that are created during text composition.
		 *  @default Context3DTextureFormat.BGRA_PACKED */
		public textureFormat:string;
		protected get_textureFormat():string;
		protected set_textureFormat(value:string):string;
	
		/** The padding (in points) that's added to the sides of text that's rendered to a Bitmap.
		 *  If your text is truncated on the sides (which may happen if the font returns incorrect
		 *  bounds), padding can make up for that. Value must be positive. @default 0.0 */
		public padding:number;
		protected get_padding():number;
		protected set_padding(value:number):number;
	}
}

export default starling.text.TextOptions;
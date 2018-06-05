import Rectangle from "openfl/geom/Rectangle";
import DisplayObjectContainer from "./../display/DisplayObjectContainer";
import MeshStyle from "./../styles/MeshStyle";
import TextFormat from "./../text/TextFormat";
import Texture from "./Texture";
import Sprite from "./Sprite";

declare namespace starling.display
{
	/** Dispatched when the user triggers the button. Bubbles. */
	// @:meta(Event(name="triggered", type="starling.events.Event"))
	
	/** A simple button composed of an image and, optionally, text.
	 *  
	 *  <p>You can use different textures for various states of the button. If you're providing
	 *  only an up state, the button is simply scaled a little when it is touched.</p>
	 *
	 *  <p>In addition, you can overlay text on the button. To customize the text, you can use
	 *  properties equivalent to those of the TextField class. Move the text to a certain position
	 *  by updating the <code>textBounds</code> property.</p>
	 *  
	 *  <p>To react on touches on a button, there is special <code>Event.TRIGGERED</code> event.
	 *  Use this event instead of normal touch events. That way, users can cancel button
	 *  activation by moving the mouse/finger away from the button before releasing.</p>
	 */
	export class Button extends DisplayObjectContainer
	{
		/** Creates a button with a set of state-textures and (optionally) some text.
		 * Any state that is left 'null' will display the up-state texture. Beware that all
		 * state textures should have the same dimensions. */
		public constructor(upState:Texture, text?:string, downState?:Texture,
							overState?:Texture, disabledState?:Texture);
		
		// /** @inheritDoc */
		public /*override*/ dispose():void;
		
		/** Readjusts the dimensions of the button according to its current state texture.
		 * Call this method to synchronize button and texture size after assigning a texture
		 * with a different size. Per default, this method also resets the bounds of the
		 * button's text. */
		public readjustSize(resetTextBounds?:boolean):void;
	
		/** The current state of the button. The corresponding strings are found
		 * in the ButtonState class. */
		public state:string;
		protected get_state():string;
		protected set_state(value:string):string;
	
		/** The scale factor of the button on touch. Per default, a button without a down state
		 * texture will be made slightly smaller, while a button with a down state texture
		 * remains unscaled. */
		public scaleWhenDown:number;
		protected get_scaleWhenDown():number;
		protected set_scaleWhenDown(value:number):number;
	
		/** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */
		public scaleWhenOver:number;
		protected get_scaleWhenOver():number;
		protected set_scaleWhenOver(value:number):number;
	
		/** The alpha value of the button on touch. @default 1.0 */
		public alphaWhenDown:number;
		protected get_alphaWhenDown():number;
		protected set_alphaWhenDown(value:number):number;
	
		/** The alpha value of the button when it is disabled. @default 0.5 */
		public alphaWhenDisabled:number;
		protected get_alphaWhenDisabled():number;
		protected set_alphaWhenDisabled(value:number):number;
		
		/** Indicates if the button can be triggered. */
		public enabled:boolean;
		protected get_enabled():boolean;
		protected set_enabled(value:boolean):boolean;
		
		/** The text that is displayed on the button. */
		public text:string;
		protected get_text():string;
		protected set_text(value:string):string;
	
		/** The format of the button's TextField. */
		public textFormat:TextFormat;
		protected get_textFormat():TextFormat;
	
		protected set_textFormat(value:TextFormat):TextFormat;
	
		/** The style that is used to render the button's TextField. */
		public textStyle:MeshStyle;
		protected get_textStyle():MeshStyle;
	
		protected set_textStyle(value:MeshStyle):MeshStyle;
	
		/** The style that is used to render the button.
		 *  Note that a style instance may only be used on one mesh at a time. */
		public style:MeshStyle;
		protected get_style():MeshStyle;
		protected set_style(value:MeshStyle):MeshStyle;
		
		/** The texture that is displayed when the button is not being touched. */
		public upState:Texture;
		protected get_upState():Texture;
		protected set_upState(value:Texture):Texture;
		
		/** The texture that is displayed while the button is touched. */
		public downState:Texture;
		protected get_downState():Texture;
		protected set_downState(value:Texture):Texture;
	
		/** The texture that is displayed while mouse hovers over the button. */
		public overState:Texture;
		protected get_overState():Texture;
		protected set_overState(value:Texture):Texture;
	
		/** The texture that is displayed when the button is disabled. */
		public disabledState:Texture;
		protected get_disabledState():Texture;
		protected set_disabledState(value:Texture):Texture;
		
		/** The bounds of the textfield on the button. Allows moving the text to a custom position. */
		public textBounds:Rectangle;
		protected get_textBounds():Rectangle;
		protected set_textBounds(value:Rectangle):Rectangle;
		
		/** The color of the button's state image. Just like every image object, each pixel's
		 * color is multiplied with this value. @default white */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** The smoothing type used for the button's state image. */
		public textureSmoothing:string;
		protected get_textureSmoothing():string;
		protected set_textureSmoothing(value:string):string;
	
		/** The overlay sprite is displayed on top of the button contents. It scales with the
		 * button when pressed. Use it to add additional objects to the button (e.g. an icon). */
		public readonly overlay:Sprite;
		protected get_overlay():Sprite;
	
		/** Indicates if the mouse cursor should transform into a hand while it's over the button. 
		 * @default true */
		protected /*override*/ get_useHandCursor():boolean;
		protected /*override*/ set_useHandCursor(value:boolean):boolean;
		
		/** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
		 *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
		 *  @default true */
		public pixelSnapping:boolean;
		protected get_pixelSnapping():boolean;
		protected set_pixelSnapping(value:boolean):boolean;
	
		/** @protected */
		/*override*/ protected set_width(value:number):number;
	
		/** @protected */
		/*override*/ protected set_height(value:number):number;
	
		/** The current scaling grid used for the button's state image. Use this property to create
		 *  buttons that resize in a smart way, i.e. with the four corners keeping the same size
		 *  and only stretching the center area.
		 *
		 *  @see Image#scale9Grid
		 *  @default null
		 */
		public scale9Grid:Rectangle;
		protected get_scale9Grid():Rectangle;
		protected set_scale9Grid(value:Rectangle):Rectangle;
	}
}

export default starling.display.Button;
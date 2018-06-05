import Starling from "./../../starling/core/Starling";

declare namespace starling.textures
{
	/** The TextureOptions class specifies options for loading textures with the
	 *  <code>Texture.fromData</code> and <code>Texture.fromTextureBase</code> methods. */
	export class TextureOptions
	{
		/** Creates a new instance with the given options. */
		public constructor(scale?:number, mipMapping?:boolean, 
							format?:string, premultipliedAlpha?:boolean,
							forcePotTexture?:boolean);
		
		/** Creates a clone of the TextureOptions object with the exact same properties. */
		public clone():TextureOptions;
		
		/** Copies all properties from another TextureOptions instance. */
		public copyFrom(other:TextureOptions):void;
	
		/** The scale factor, which influences width and height properties. If you pass '-1',
		 *  the current global content scale factor will be used. @default 1.0 */
		public scale:number;
		protected get_scale():number;
		protected set_scale(value:number):number;
		
		/** The <code>Context3DTextureFormat</code> of the underlying texture data. Only used
		 *  for textures that are created from Bitmaps; the format of ATF files is set when they
		 *  are created. @default BGRA */
		public format:string;
		protected get_format():string;
		protected set_format(value:string):string;
		
		/** Indicates if the texture contains mip maps. @default false */
		public mipMapping:boolean;
		protected get_mipMapping():boolean;
		protected set_mipMapping(value:boolean):boolean;
		
		/** Indicates if the texture will be used as render target. */
		public optimizeForRenderToTexture:boolean;
		protected get_optimizeForRenderToTexture():boolean;
		protected set_optimizeForRenderToTexture(value:boolean):boolean;
	
		/** Indicates if the underlying Stage3D texture should be created as the power-of-two based
		 *  <code>Texture</code> class instead of the more memory efficient <code>RectangleTexture</code>.
		 *  That might be useful when you need to render the texture with wrap mode <code>repeat</code>.
		 *  @default false */
		public forcePotTexture:boolean;
		protected get_forcePotTexture():boolean;
		protected set_forcePotTexture(value:boolean):boolean;
	
		/** If this value is set, the texture will be loaded asynchronously (if possible).
		 *  The texture can only be used when the callback has been executed.
		 *  
		 *  <p>This is the expected definition: 
		 *  <code>function(texture:Texture):void;</code></p>
		 *
		 *  @default null
		 */
		public onReady:(Texture)=>void;
		protected get_onReady():(Texture)=>void;
		protected set_onReady(value:(Texture)=>void):(Texture)=>void;
	
		/** Indicates if the alpha values are premultiplied into the RGB values. This is typically
		 *  true for textures created from BitmapData and false for textures created from ATF data.
		 *  This property will only be read by the <code>Texture.fromTextureBase</code> factory
		 *  method. @default true */
		public premultipliedAlpha:boolean;
		protected get_premultipliedAlpha():boolean;
		protected set_premultipliedAlpha(value:boolean):boolean;
	}
}

export default starling.textures.TextureOptions;
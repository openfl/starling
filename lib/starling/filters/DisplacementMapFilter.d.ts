import FragmentFilter from "./../../starling/filters/FragmentFilter";
import DisplacementMapEffect from "./../../starling/filters/DisplacementMapEffect";
import Rectangle from "openfl/geom/Rectangle";
import FilterEffect from "./../rendering/FilterEffect";
import Texture from "./../textures/Texture";
import Painter from "./../rendering/Painter";
import IFilterHelper from "./IFilterHelper";
import VertexDataFormat from "./../rendering/VertexDataFormat";

declare namespace starling.filters
{
	/** The DisplacementMapFilter class uses the pixel values from the specified texture (called
	 *  the map texture) to perform a displacement of an object. You can use this filter
	 *  to apply a warped or mottled effect to any object that inherits from the DisplayObject
	 *  class.
	 *
	 *  <p>The filter uses the following formula:</p>
	 *  <listing>dstPixel[x, y] = srcPixel[x + ((componentX(x, y) - 128) &#42; scaleX) / 256,
	 *                      y + ((componentY(x, y) - 128) &#42; scaleY) / 256]
	 *  </listing>
	 *
	 *  <p>Where <code>componentX(x, y)</code> gets the componentX property color value from the
	 *  map texture at <code>(x - mapX, y - mapY)</code>.</p>
	 *
	 *  <strong>Clamping to the Edges</strong>
	 *
	 *  <p>Per default, the filter allows the object to grow beyond its actual bounds to make
	 *  room for the displacement (depending on <code>scaleX/Y</code>). If you want to clamp the
	 *  displacement to the actual object bounds, set all margins to zero via a call to
	 *  <code>filter.padding.setTo()</code>. This works only with rectangular, stage-aligned
	 *  objects, though.</p>
	 */
	export class DisplacementMapFilter extends FragmentFilter
	{
		/** Creates a new displacement map filter that uses the provided map texture. */
		public constructor(mapTexture:Texture,
							componentX?:number, componentY?:number,
							scaleX?:number, scaleY?:number);
	
		/** @protected */
		/*override*/ public process(painter:Painter, pool:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		// properties
	
		/** Describes which color channel to use in the map image to displace the x result.
		 *  Possible values are constants from the BitmapDataChannel class. */
		public componentX:number;
		protected get_componentX():number;
		protected set_componentX(value:number):number;
	
		/** Describes which color channel to use in the map image to displace the y result.
		 *  Possible values are constants from the BitmapDataChannel class. */
		public componentY:number;
		protected get_componentY():number;
		protected set_componentY(value:number):number;
	
		/** The multiplier used to scale the x displacement result from the map calculation. */
		public scaleX:number;
		protected get_scaleX():number;
		protected set_scaleX(value:number):number;
	
		/** The multiplier used to scale the y displacement result from the map calculation. */
		public scaleY:number;
		protected get_scaleY():number;
		protected set_scaleY(value:number):number;
	
		/** The horizontal offset of the map texture relative to the origin. @default 0 */
		public mapX:number;
		protected get_mapX():number;
		protected set_mapX(value:number):number;
	
		/** The vertical offset of the map texture relative to the origin. @default 0 */
		public mapY:number;
		protected get_mapY():number;
		protected set_mapY(value:number):number;
	
		/** The texture that will be used to calculate displacement. */
		public mapTexture:Texture;
		protected get_mapTexture():Texture;
		protected set_mapTexture(value:Texture):Texture;
	
		/** Indicates if pixels at the edge of the map texture will be repeated.
		 *  Note that this only works if the map texture is a power-of-two texture!
		 */
		public mapRepeat:boolean;
		protected get_mapRepeat():boolean;
		protected set_mapRepeat(value:boolean):boolean;
	
		public readonly dispEffect:DisplacementMapEffect;
		protected get_dispEffect():DisplacementMapEffect;
	}
	
	export class DisplacementMapEffect extends FilterEffect
	{
		public static VERTEX_FORMAT:VertexDataFormat;
	
		public constructor();
	
		// properties
	
		public componentX:number;
		protected get_componentX():number;
		protected set_componentX(value:number):number;
	
		public componentY:number;
		protected get_componentY():number;
		protected set_componentY(value:number):number;
	
		public scaleX:number;
		protected get_scaleX():number;
		protected set_scaleX(value:number):number;
	
		public scaleY:number;
		protected get_scaleY():number;
		protected set_scaleY(value:number):number;
	
		public mapTexture:Texture;
		protected get_mapTexture():Texture;
		protected set_mapTexture(value:Texture):Texture;
	
		public mapRepeat:boolean;
		protected get_mapRepeat():boolean;
		protected set_mapRepeat(value:boolean):boolean;
	}
}

export default starling.filters.DisplacementMapFilter;
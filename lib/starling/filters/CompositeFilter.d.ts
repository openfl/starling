import FragmentFilter from "./../../starling/filters/FragmentFilter";
import CompositeEffect from "./../../starling/filters/CompositeEffect";
import Point from "openfl/geom/Point";
import FilterEffect from "./../rendering/FilterEffect";
import Texture from "./../textures/Texture";
import VertexDataFormat from "./../rendering/VertexDataFormat";
import Painter from "./../rendering/Painter";
import IFilterHelper from "./IFilterHelper";

declare namespace starling.filters
{
	/** The CompositeFilter class allows to combine several layers of textures into one texture.
	 *  It's mainly used as a building block for more complex filters; e.g. the DropShadowFilter
	 *  uses this class to draw the shadow (the result of a BlurFilter) behind an object.
	 */
	export class CompositeFilter extends FragmentFilter
	{
		/** Creates a new instance. */
		public constructor();
	
		/** Combines up to four input textures into one new texture,
		 *  adhering to the properties of each layer. */
		/*override*/ public process(painter:Painter, helper:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		/** Returns the position (in points) at which a certain layer will be drawn. */
		public getOffsetAt(layerID:number, out?:Point):Point;
	
		/** Indicates the position (in points) at which a certain layer will be drawn. */
		public setOffsetAt(layerID:number, x:number, y:number):void;
	
		/** Returns the RGB color with which a layer is tinted when it is being drawn.
		 *  @default 0xffffff */
		public getColorAt(layerID:number):number;
	
		/** Adjusts the RGB color with which a layer is tinted when it is being drawn.
		 *  If <code>replace</code> is enabled, the pixels are not tinted, but instead
		 *  the RGB channels will replace the texture's color entirely.
		 */
		public setColorAt(layerID:number, color:number, replace?:boolean):void;
	
		/** Indicates the alpha value with which the layer is drawn.
		 *  @default 1.0 */
		public getAlphaAt(layerID:number):number;
	
		/** Adjusts the alpha value with which the layer is drawn. */
		public setAlphaAt(layerID:number, alpha:number):void;
	
		public readonly compositeEffect:CompositeEffect;
		protected get_compositeEffect():CompositeEffect;
	}
	
	export class CompositeEffect extends FilterEffect
	{
		public static VERTEX_FORMAT:VertexDataFormat;
	
		public constructor(numLayers?:number);
	
		public getLayerAt(layerID:number):CompositeLayer;
		
		// properties
	
		public readonly numLayers:number;
		protected get_numLayers():number;
	
		/*override*/ protected set_texture(value:Texture):Texture;
	}
	
	export class CompositeLayer
	{
		public texture:Texture;
		public x:number;
		public y:number;
		public color:number;
		public alpha:number;
		public replaceColor:boolean;
	
		public constructor();
	}
}

export default starling.filters.CompositeFilter;
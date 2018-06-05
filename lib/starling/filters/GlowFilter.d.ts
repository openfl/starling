import FragmentFilter from "./../../starling/filters/FragmentFilter";
import BlurFilter from "./../../starling/filters/BlurFilter";
import CompositeFilter from "./../../starling/filters/CompositeFilter";
import FilterEffect from "./../rendering/FilterEffect";

declare namespace starling.filters
{
	/** The GlowFilter class lets you apply a glow effect to display objects.
	 *  It is similar to the drop shadow filter with the distance and angle properties set to 0.
	 *
	 *  <p>This filter can also be used to create outlines around objects. The trick is to
	 *  assign an alpha value that's (much) greater than <code>1.0</code>, and full resolution.
	 *  For example, the following code will yield a nice black outline:</p>
	 *
	 *  <listing>object.filter = new GlowFilter(0x0, 30, 1, 1.0);</listing>
	 */
	export class GlowFilter extends FragmentFilter
	{
		/** Initializes a new GlowFilter instance with the specified parameters.
		 *
		 * @param color      the color of the glow
		 * @param alpha      the alpha value of the glow. Values between 0 and 1 modify the
		 *                   opacity; values > 1 will make it stronger, i.e. produce a harder edge.
		 * @param blur       the amount of blur used to create the glow. Note that high
		 *                   values will cause the number of render passes to grow.
		 * @param quality 	 the quality of the glow's blur, '1' being the best (range 0.1 - 1.0)
		 */
		public constructor(color?:number, alpha?:number, blur?:number,
							quality?:number);
	
		/** @inheritDoc */
		/*override*/ public dispose():void;
	
		/** @protected */
		/*override*/ public process(painter:Painter, helper:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		/** The color of the glow. @default 0xffff00 */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** The alpha value of the glow. Values between 0 and 1 modify the opacity;
		 *  values > 1 will make it stronger, i.e. produce a harder edge. @default 1.0 */
		public alpha:number;
		protected get_alpha():number;
		protected set_alpha(value:number):number;
	
		/** The amount of blur with which the glow is created.
		 *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
		 *  @default 1.0 */
		public blur:number;
		protected get_blur():number;
		protected set_blur(value:number):number;
		
		/** The quality used for blurring the glow.
		 *  Forwarded to the internally used <em>BlurFilter</em>. */
		public quality:number;
		protected get_quality():number;
		protected set_quality(value:number):number;
	}
}

export default starling.filters.GlowFilter;
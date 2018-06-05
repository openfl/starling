import FragmentFilter from "./../../starling/filters/FragmentFilter";
import CompositeFilter from "./../../starling/filters/CompositeFilter";
import BlurFilter from "./../../starling/filters/BlurFilter";
import FilterEffect from "./../rendering/FilterEffect";

declare namespace starling.filters
{
	/** The DropShadowFilter class lets you add a drop shadow to display objects.
	 *  To create the shadow, the class internally uses the BlurFilter.
	 */
	export class DropShadowFilter extends FragmentFilter
	{
		/** Creates a new DropShadowFilter instance with the specified parameters.
		 *
		 * @param distance   the offset distance of the shadow, in points.
		 * @param angle      the angle with which the shadow is offset, in radians.
		 * @param color      the color of the shadow.
		 * @param alpha      the alpha value of the shadow. Values between 0 and 1 modify the
		 *                   opacity; values > 1 will make it stronger, i.e. produce a harder edge.
		 * @param blur       the amount of blur with which the shadow is created. Note that high
		 *                   values will cause the number of render passes to grow.
		 * @param quality 	 the quality of the shadow blur, '1' being the best (range 0.1 - 1.0)
		 */
		public constructor(distance:number=4.0, angle?:number,
							color?:number, alpha?:number, blur?:number,
							quality?:number);
	
		/** @inheritDoc */
		/*override*/ public dispose():void;
	
		/** @protected */
		/*override*/ public process(painter:Painter, helper:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		/** The color of the shadow. @default 0x0 */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** The alpha value of the shadow. Values between 0 and 1 modify the opacity;
		 *  values > 1 will make it stronger, i.e. produce a harder edge. @default 0.5 */
		public alpha:number;
		protected get_alpha():number;
		protected set_alpha(value:number):number;
	
		/** The offset distance for the shadow, in points. @default 4.0 */
		public distance:number;
		protected get_distance():number;
		protected set_distance(value:number):number;
	
		/** The angle with which the shadow is offset, in radians. @default Math.PI / 4 */
		public angle:number;
		protected get_angle():number;
		protected set_angle(value:number):number;
	
		/** The amount of blur with which the shadow is created.
		 *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
		 *  @default 1.0 */
		public blur:number;
		protected get_blur():number;
		protected set_blur(value:number):number;
	
		/** The quality used for blurring the shadow.
		 *  Forwarded to the internally used <em>BlurFilter</em>. */
		public quality:number;
		protected get_quality():number;
		protected set_quality(value:number):number;
	}
}

export default starling.filters.DropShadowFilter;
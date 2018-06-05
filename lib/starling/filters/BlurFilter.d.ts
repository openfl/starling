import FragmentFilter from "./../../starling/filters/FragmentFilter";
import BlurEffect from "./../../starling/filters/BlurEffect";
import Starling from "./../../starling/core/Starling";
import Texture from "./../textures/Texture";
import FilterEffect from "./../rendering/FilterEffect";
import Painter from "./../rendering/Painter";
import IFilterHelper from "./IFilterHelper";

declare namespace starling.filters
{
	/** The BlurFilter applies a Gaussian blur to an object. The strength of the blur can be
	 *  set for x- and y-axis separately. */
	export class BlurFilter extends FragmentFilter
	{
		/** Create a new BlurFilter. For each blur direction, the number of required passes is
		 *
		 *  <p>The blur is rendered for each direction (x and y) separately; the number of
		 *  draw calls add up. The blur value itself is internally multiplied with the current
		 *  <code>contentScaleFactor</code> in order to guarantee a consistent look on HiDPI
		 *  displays (dubbed 'totalBlur' below).</p>
		 *
		 *  <p>The number of draw calls per blur value is the following:</p>
		 *  <ul><li>totalBlur &lt;= 1: 1 draw call</li>
		 *      <li>totalBlur &lt;= 2: 2 draw calls</li>
		 *      <li>totalBlur &lt;= 4: 3 draw calls</li>
		 *      <li>totalBlur &lt;= 8: 4 draw calls</li>
		 *      <li>... etc.</li>
		 *  </ul>
		 */
		public constructor(blurX?:number, blurY?:number, resolution?:number);
	
		/** @protected */
		/*override*/ public process(painter:Painter, helper:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		/** The blur values scaled by the current contentScaleFactor. */
		protected readonly totalBlurX:number;
		protected get_totalBlurX():number;
		protected readonly totalBlurY:number;
		protected get_totalBlurY():number;
	
		/** The blur factor in x-direction.
		 *  The number of required passes will be <code>Math.ceil(value)</code>. */
		public blurX:number;
		protected get_blurX():number;
		protected set_blurX(value:number):number;
	
		/** The blur factor in y-direction.
		 *  The number of required passes will be <code>Math.ceil(value)</code>. */
		public blurY:number;
		protected get_blurY():number;
		protected set_blurY(value:number):number;
	
		/** The quality of the blur effect. Low values will look as if the target was drawn
		 *  multiple times in close proximity (range: 0.1 - 1).
		 *
		 *  <p>Typically, it's better to reduce the filter resolution instead; however, if that
		 *  is not an option (e.g. when using the BlurFilter as part of a composite filter),
		 *  this property may provide an alternative.</p>
		 *
		 *  @default 1.0
		 */
		public quality:number;
		public get_quality():number;
		public set_quality(value:number):number;
	}
	
	export class BlurEffect extends FilterEffect
	{
		public static HORIZONTAL:string;
		public static VERTICAL:string;
	
		/** Creates a new BlurEffect. */
		public constructor();
	
		public direction:string;
		protected get_direction():string;
		protected set_direction(value:string):string;
	
		public strength:number;
		protected get_strength():number;
		protected set_strength(value:number):number;
	
		public quality:number;
		protected get_quality():number;
		protected set_quality(value:number):number;
	}
}

export default starling.filters.BlurFilter;
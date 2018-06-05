import MeshStyle from "./../../starling/styles/MeshStyle";
import DistanceFieldEffect from "./../../starling/styles/DistanceFieldEffect";
import Color from "./../../starling/utils/Color";
import MathUtil from "./../../starling/utils/MathUtil";

declare namespace starling.styles
{
	/** Provides support for signed distance fields to Starling meshes.
	 *
	 *  <p>Signed distance field rendering allows bitmap fonts and other single colored shapes to
	 *  be drawn without jagged edges, even at high magnifications. The technique was introduced in
	 *  the SIGGRAPH paper <a href="http://tinyurl.com/AlphaTestedMagnification">Improved
	 *  Alpha-Tested Magnification for Vector Textures and Special Effects</a> by Valve Software.
	 *  </p>
	 *
	 *  <p>While bitmap fonts are a great solution to render text in a GPU-friendly way, they
	 *  don't scale well. For best results, one has to embed the font in all the sizes used within
	 *  the app. The distance field style solves this issue: instead of providing a standard
	 *  black and white image of the font, it uses a <em>signed distance field texture</em> as
	 *  its input (a texture that encodes, for each pixel, the distance to the closest edge of a
	 *  vector shape). With this data, the shape can be rendered smoothly at almost any scale.</p>
	 *
	 *  <p>Here are some tools that support creation of such distance field textures:</p>
	 *
	 *  <ul>
	 *    <li>Field Agent - a Ruby script that uses ImageMagick to create single-channel distance
	 *        field textures. Part of the Starling download ('util' directory).</li>
	 *    <li><a href="https://github.com/Chlumsky/msdfgen">msdfgen</a> - an excellent and fast
	 *        open source command line tool that creates multi- and single-channel distance field
	 *        textures.</li>
	 *  </ul>
	 *
	 *  <p>The former tools convert arbitrary SVG or PNG images to distance field textures.
	 *  To create distance field <em>fonts</em>, have a look at the following alternatives:</p>
	 *
	 *  <ul>
	 *    <li><a href="https://github.com/soimy/msdf-bmfont-xml/">msdf-bmfont-xml</a> - a command
	 *        line tool powered by msdf and thus producing excellent multi-channel output.</li>
	 *    <li><a href="http://kvazars.com/littera/">Littera</a> - a free online bitmap font
	 *        generator.</li>
	 *    <li><a href="http://github.com/libgdx/libgdx/wiki/Hiero">Hiero</a> - a cross platform
	 *        tool.</li>
	 *    <li><a href="http://www.angelcode.com/products/bmfont/">BMFont</a> - Windows-only, from
	 *        AngelCode.</li>
	 *  </ul>
	 *
	 *  <strong>Single-Channel vs. Multi-Channel</strong>
	 *
	 *  <p>The original approach for distance field textures uses just a single channel (encoding
	 *  the distance of each pixel to the shape that's being represented). By utilizing
	 *  all three color channels, however, the results can be greatly enhanced - a technique
	 *  developed by Viktor Chlumský.</p>
	 *
	 *  <p>Starling supports such multi-channel DF textures, as well. When using an appropriate
	 *  texture, don't forget to enable the style's <code>multiChannel</code> property.</p>
	 *
	 *  <strong>Special effects</strong>
	 *
	 *  <p>Another advantage of this rendering technique: it supports very efficient rendering of
	 *  some popular filter effects, in just one pass, directly on the GPU. You can add an
	 *  <em>outline</em> around the shape, let it <em>glow</em> in an arbitrary color, or add
	 *  a <em>drop shadow</em>.</p>
	 *
	 *  <p>The type of effect currently used is called the 'mode'.
	 *  Meshes with the same mode will be batched together on rendering.</p>
	 */
	export class DistanceFieldStyle extends MeshStyle
	{
		/** The vertex format expected by this style. */
		public static VERTEX_FORMAT:VertexDataFormat;
	
		/** Basic distance field rendering, without additional effects. */
		public static MODE_BASIC:string;
	
		/** Adds an outline around the edge of the shape. */
		public static MODE_OUTLINE:string;
	
		/** Adds a smooth glow effect around the shape. */
		public static MODE_GLOW:string;
	
		/** Adds a drop shadow behind the shape. */
		public static MODE_SHADOW:string;
	
		/** Creates a new distance field style.
		 *
		 *  @param softness   adds a soft transition between the inside and the outside.
		 *                    This should typically be 1.0 divided by the spread (in points)
		 *                    used when creating the distance field texture.
		 *  @param threshold  the value separating the inside from the outside of the shape.
		 *                    Range: 0 - 1.
		 */
		public constructor(softness?:number, threshold?:number);
	
		/** @protected */
		/*override*/ public copyFrom(meshStyle:MeshStyle):void;
	
		/** @protected */
		/*override*/ public createEffect():MeshEffect;
	
		/** @protected */
		/*override*/ public batchVertexData(targetStyle:MeshStyle, targetVertexID?:number,
												 matrix?:Matrix, vertexID?:number,
												 numVertices?:number):void;
	
		/** @protected */
		/*override*/ public updateEffect(effect:MeshEffect, state:RenderState):void;
	
		/** @protected */
		/*override*/ public canBatchWith(meshStyle:MeshStyle):boolean;
	
		// simplified setup
	
		/** Restores basic render mode, i.e. smooth rendering of the shape. */
		public setupBasic():void;
	
		/** Sets up outline rendering mode. The 'width' determines the threshold where the
		 *  outline ends; 'width + threshold' must not exceed '1.0'.
		 */
		public setupOutline(width?:number, color?:number, alpha?:number):void;
	
		/** Sets up glow rendering mode. The 'blur' determines the threshold where the
		 *  blur ends; 'blur + threshold' must not exceed '1.0'.
		 */
		public setupGlow(blur?:number, color?:number, alpha?:number):void;
	
		/** Sets up shadow rendering mode. The 'blur' determines the threshold where the drop
		 *  shadow ends; 'offsetX' and 'offsetY' are expected in points.
		 *
		 *  <p>Beware that the style can only act within the limits of the mesh's vertices.
		 *  This means that not all combinations of blur and offset are possible; too high values
		 *  will cause the shadow to be cut off on the sides. Reduce either blur or offset to
		 *  compensate.</p>
		 */
		public setupDropShadow(blur?:number, offsetX?:number, offsetY?:number,
										color?:number, alpha?:number):void;
	
		// properties
	
		/** The current render mode. It's recommended to use one of the 'setup...'-methods to
		 *  change the mode, as those provide useful standard settings, as well. @default basic */
		public mode:string;
		protected get_mode():string;
		protected set_mode(value:string):string;
	
		/** Indicates if the distance field texture utilizes multiple channels. This improves
			*  render quality, but requires specially created DF textures. @default false */
		public multiChannel:boolean;
		protected get_multiChannel():boolean;
		protected set_multiChannel(value:boolean):boolean;
	
		/** The threshold that will separate the inside from the outside of the shape. On the
		 *  distance field texture, '0' means completely outside, '1' completely inside; the
		 *  actual edge runs along '0.5'. @default 0.5 */
		public threshold:number;
		protected get_threshold():number;
		protected set_threshold(value:number):number;
	
		/** Indicates how soft the transition between inside and outside should be rendered.
		 *  A value of '0' will lead to a hard, jagged edge; '1' will be just as blurry as the
		 *  actual distance field texture. The recommend value should be <code>1.0 / spread</code>
		 *  (you determine the spread when creating the distance field texture). @default 0.125 */
		public softness:number;
		protected get_softness():number;
		protected set_softness(value:number):number;
	
		/** The alpha value with which the inner area (what's rendered in 'basic' mode) is drawn.
		 *  @default 1.0 */
		public alpha:number;
		protected get_alpha():number;
		protected set_alpha(value:number):number;
	
		/** The threshold that determines where the outer area (outline, glow, or drop shadow)
		 *  ends. Ignored in 'basic' mode. */
		public outerThreshold:number;
		protected get_outerThreshold():number;
		protected set_outerThreshold(value:number):number;
	
		/** The alpha value on the inner side of the outer area's gradient.
		 *  Used for outline, glow, and drop shadow modes. */
		public outerAlphaStart:number;
		protected get_outerAlphaStart():number;
		protected set_outerAlphaStart(value:number):number;
	
		/** The alpha value on the outer side of the outer area's gradient.
		 *  Used for outline, glow, and drop shadow modes. */
		public outerAlphaEnd:number;
		protected get_outerAlphaEnd():number;
		protected set_outerAlphaEnd(value:number):number;
	
		/** The color with which the outer area (outline, glow, or drop shadow) will be filled.
		 *  Ignored in 'basic' mode. */
		public outerColor:number;
		protected get_outerColor():number;
		protected set_outerColor(value:number):number;
	
		/** The x-offset of the shadow in points. Note that certain combinations of offset and
		 *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
		 *  counteract. */
		public shadowOffsetX:number;
		protected get_shadowOffsetX():number;
		protected set_shadowOffsetX(value:number):number;
	
		/** The y-offset of the shadow in points. Note that certain combinations of offset and
		 *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
		 *  counteract. */
		public shadowOffsetY:number;
		protected get_shadowOffsetY():number;
		protected set_shadowOffsetY(value:number):number;
	}
	
	export class DistanceFieldEffect extends MeshEffect
	{
		public static VERTEX_FORMAT:VertexDataFormat;
		public static MAX_OUTER_OFFSET:number;
		public static MAX_SCALE:number;
	
		public constructor();
	
		public scale:number;
		protected get_scale():number;
		protected set_scale(value:number):number;
	
		public mode:string;
		protected get_mode():string;
		protected set_mode(value:string):string;
	
		public multiChannel:boolean;
		protected get_multiChannel():boolean;
		protected set_multiChannel(value:boolean):boolean;
	
	}
}

export default starling.styles.DistanceFieldStyle;
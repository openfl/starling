import EventDispatcher from "./../../starling/events/EventDispatcher";
import Starling from "./../../starling/core/Starling";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import FilterHelper from "./../../starling/filters/FilterHelper";
import FilterQuad from "./../../starling/filters/FilterQuad";
import Pool from "./../../starling/utils/Pool";
import Stage from "./../../starling/display/Stage";
import RectangleUtil from "./../../starling/utils/RectangleUtil";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import FilterEffect from "./../../starling/rendering/FilterEffect";
import VertexData from "./../../starling/rendering/VertexData";
import IndexData from "./../../starling/rendering/IndexData";
import Padding from "./../../starling/utils/Padding";
import ArgumentError from "openfl/errors/ArgumentError";
import Matrix3D from "openfl/geom/Matrix3D";
import FilterEffect from "./../rendering/FilterEffect";
import Mesh from "./../display/Mesh";
import Texture from "./../textures/Texture";

declare namespace starling.filters
{
	/** Dispatched when the settings change in a way that requires a redraw. */
	// @:meta(Event(name="change", type="starling.events.Event"))
	
	/** Dispatched every frame on filters assigned to display objects connected to the stage. */
	// @:meta(Event(name="enterFrame", type="starling.events.EnterFrameEvent"))
	
	/** The FragmentFilter class is the base class for all filter effects in Starling.
	 *  All filters must extend this class. You can attach them to any display object through the
	 *  <code>filter</code> property.
	 *
	 *  <p>A fragment filter works in the following way:</p>
	 *  <ol>
	 *    <li>The object to be filtered is rendered into a texture.</li>
	 *    <li>That texture is passed to the <code>process</code> method.</li>
	 *    <li>This method processes the texture using a <code>FilterEffect</code> subclass
	 *        that processes the input via fragment and vertex shaders to achieve a certain
	 *        effect.</li>
	 *    <li>If the filter requires several passes, the process method may execute the
	 *        effect several times, or even make use of other filters in the process.</li>
	 *    <li>In the end, a quad with the output texture is added to the batch renderer.
	 *        In the next frame, if the object hasn't changed, the filter is drawn directly
	 *        from the render cache.</li>
	 *    <li>Alternatively, the last pass may be drawn directly to the back buffer. That saves
	 *        one draw call, but means that the object may not be drawn from the render cache in
	 *        the next frame. Starling makes an educated guess if that makes sense, but you can
	 *        also force it to do so via the <code>alwaysDrawToBackBuffer</code> property.</li>
	 *  </ol>
	 *
	 *  <p>All of this is set up by the basic FragmentFilter class. Concrete subclasses
	 *  just need to override the protected method <code>createEffect</code> and (optionally)
	 *  <code>process</code>. Multi-pass filters must also override <code>numPasses</code>.</p>
	 *
	 *  <p>Typically, any properties on the filter are just forwarded to an effect instance,
	 *  which is then used automatically by <code>process</code> to render the filter pass.
	 *  For a simple example on how to write a single-pass filter, look at the implementation of
	 *  the <code>ColorMatrixFilter</code>; for a composite filter (i.e. a filter that combines
	 *  several others), look at the <code>GlowFilter</code>.
	 *  </p>
	 *
	 *  <p>Beware that a filter instance may only be used on one object at a time!</p>
	 *
	 *  <p><strong>Animated filters</strong></p>
	 *
	 *  <p>The <code>process</code> method of a filter is only called when it's necessary, i.e.
	 *  when the filter properties or the target display object changes. This means that you cannot
	 *  rely on the method to be called on a regular basis, as needed when creating an animated
	 *  filter class. Instead, you can do so by listening for an <code>ENTER_FRAME</code>-event.
	 *  It is dispatched on the filter once every frame, as long as the filter is assigned to
	 *  a display object that is connected to the stage.</p>
	 *
	 *  <p><strong>Caching</strong></p>
	 *
	 *  <p>Per default, whenever the target display object is changed in any way (i.e. the render
	 *  cache fails), the filter is reprocessed. However, you can manually cache the filter output
	 *  via the method of the same name: this will let the filter redraw the current output texture,
	 *  even if the target object changes later on. That's especially useful if you add a filter
	 *  to an object that changes only rarely, e.g. a TextField or an Image. Keep in mind, though,
	 *  that you have to call <code>cache()</code> again in order for any changes to show up.</p>
	 *
	 *  @see starling.rendering.FilterEffect
	 */
	export class FragmentFilter extends EventDispatcher
	{
		/** Creates a new instance. The base class' implementation just draws the unmodified
		 *  input texture. */
		public constructor();
	
		/** Disposes all resources that have been created by the filter. */
		public dispose():void;
	
		/** Renders the filtered target object. Most users will never have to call this manually;
		 *  it's executed automatically in the rendering process of the filtered display object.
		 */
		public render(painter:Painter):void;
	
		/** Does the actual filter processing. This method will be called with up to four input
		 *  textures and must return a new texture (acquired from the <code>helper</code>) that
		 *  contains the filtered output. To to do this, it configures the FilterEffect
		 *  (provided via <code>createEffect</code>) and calls its <code>render</code> method.
		 *
		 *  <p>In a standard filter, only <code>input0</code> will contain a texture; that's the
		 *  object the filter was applied to, rendered into an appropriately sized texture.
		 *  However, filters may also accept multiple textures; that's useful when you need to
		 *  combine the output of several filters into one. For example, the DropShadowFilter
		 *  uses a BlurFilter to create the shadow and then feeds both input and shadow texture
		 *  into a CompositeFilter.</p>
		 *
		 *  <p>Never create or dispose any textures manually within this method; instead, get
		 *  new textures from the provided helper object, and pass them to the helper when you do
		 *  not need them any longer. Ownership of both input textures and returned texture
		 *  lies at the caller; only temporary textures should be put into the helper.</p>
		 */
		public process(painter:Painter, helper:IFilterHelper,
								input0?:Texture, input1?:Texture,
								input2?:Texture, input3?:Texture):Texture;
	
		/** Caches the filter output into a texture.
		 *
		 *  <p>An uncached filter is rendered every frame (except if it can be rendered from the
		 *  global render cache, which happens if the target object does not change its appearance
		 *  or location relative to the stage). A cached filter is only rendered once; the output
		 *  stays unchanged until you call <code>cache</code> again or change the filter settings.
		 *  </p>
		 *
		 *  <p>Beware: you cannot cache filters on 3D objects; if the object the filter is attached
		 *  to is a Sprite3D or has a Sprite3D as (grand-) parent, the request will be silently
		 *  ignored. However, you <em>can</em> cache a 2D object that has 3D children!</p>
		 */
		public cache():void;
	
		/** Clears the cached output of the filter. After calling this method, the filter will be
		 *  processed once per frame again. */
		public clearCache():void;
	
		// enter frame event
	
		/** @protected */
		/*override*/ public addEventListener(type:string, listener:Function):void;
	
		/** @protected */
		/*override*/ public removeEventListener(type:string, listener:Function):void;
	
		// properties
	
		/** Padding can extend the size of the filter texture in all directions.
		 *  That's useful when the filter "grows" the bounds of the object in any direction. */
		public padding:Padding;
		protected get_padding():Padding;
	
		protected set_padding(value:Padding):Padding;
	
		/** Indicates if the filter is cached (via the <code>cache</code> method). */
		public readonly isCached:boolean;
		protected get_isCached():boolean;
	
		/** The resolution of the filter texture. "1" means stage resolution, "0.5" half the stage
		 *  resolution. A lower resolution saves memory and execution time, but results in a lower
		 *  output quality. Values greater than 1 are allowed; such values might make sense for a
		 *  cached filter when it is scaled up. @default 1
		 */
		public resolution:number;
		protected get_resolution():number;
		protected set_resolution(value:number):number;
	
		/** Indicates if the filter requires all passes to be processed with the exact same
		 *  resolution.
		 *
		 *  <p>Some filters must use the same resolution for input and output; e.g. the blur filter
		 *  is very sensitive to changes of pixel / texel sizes. When the filter is used as part
		 *  of a filter chain, or if its last pass is drawn directly to the back buffer, such a
		 *  filter produces artifacts. In that case, the filter author must set this property
		 *  to <code>true</code>.</p>
		 *
		 *  @default false
		 */
		protected maintainResolutionAcrossPasses:boolean;
		protected get_maintainResolutionAcrossPasses():boolean;
		protected set_maintainResolutionAcrossPasses(value:boolean):boolean;
	
		/** The anti-aliasing level. This is only used for rendering the target object
		 *  into a texture, not for the filter passes. 0 - none, 4 - maximum. @default 0 */
		public antiAliasing:number;
		protected get_antiAliasing():number;
		protected set_antiAliasing(value:number):number;
	
		/** The smoothing mode of the filter texture. @default bilinear */
		public textureSmoothing:string;
		protected get_textureSmoothing():string;
		protected set_textureSmoothing(value:string):string;
	
		/** The format of the filter texture. @default BGRA */
		public textureFormat:string;
		protected get_textureFormat():string;
		protected set_textureFormat(value:string):string;
	
		/** Indicates if the last filter pass is always drawn directly to the back buffer.
		 *
		 *  <p>Per default, the filter tries to automatically render in a smart way: objects that
		 *  are currently moving are rendered to the back buffer, objects that are static are
		 *  rendered into a texture first, which allows the filter to be drawn directly from the
		 *  render cache in the next frame (in case the object remains static).</p>
		 *
		 *  <p>However, this fails when filters are added to an object that does not support the
		 *  render cache, or to a container with such a child (e.g. a Sprite3D object or a masked
		 *  display object). In such a case, enable this property for maximum performance.</p>
		 *
		 *  @default false
		 */
		public alwaysDrawToBackBuffer:boolean;
		protected get_alwaysDrawToBackBuffer():boolean;
		protected set_alwaysDrawToBackBuffer(value:boolean):boolean;
	}
	
	export class FilterQuad extends Mesh
	{
		public constructor(smoothing:string);
	
		/*override*/ public dispose():void;
	
		public disposeTexture():void;
	
		public moveVertices(sourceSpace:DisplayObject, targetSpace:DisplayObject):void;
	
		public setBounds(bounds:Rectangle):void;
	}
}

export default starling.filters.FragmentFilter;
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters;

import haxe.Constraints.Function;

import openfl.display3D.Context3DTextureFormat;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Mesh;
import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.rendering.FilterEffect;
import starling.rendering.IndexData;
import starling.rendering.Painter;
import starling.rendering.VertexData;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MatrixUtil;
import starling.utils.Padding;
import starling.utils.Pool;
import starling.utils.RectangleUtil;

/** Dispatched when the settings change in a way that requires a redraw. */
@:meta(Event(name="change", type="starling.events.Event"))

/** Dispatched every frame on filters assigned to display objects connected to the stage. */
@:meta(Event(name="enterFrame", type="starling.events.EnterFrameEvent"))

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

@:jsRequire("starling/filters/FragmentFilter", "default")

extern class FragmentFilter extends EventDispatcher
{
    /** Creates a new instance. The base class' implementation just draws the unmodified
     *  input texture. */
    public function new();

    /** Disposes all resources that have been created by the filter. */
    public function dispose():Void;

    /** Renders the filtered target object. Most users will never have to call this manually;
     *  it's executed automatically in the rendering process of the filtered display object.
     */
    public function render(painter:Painter):Void;

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
    public function process(painter:Painter, helper:IFilterHelper,
                            input0:Texture=null, input1:Texture=null,
                            input2:Texture=null, input3:Texture=null):Texture;

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
    public function cache():Void;

    /** Clears the cached output of the filter. After calling this method, the filter will be
     *  processed once per frame again. */
    public function clearCache():Void;

    // enter frame event

    /** @private */
    override public function addEventListener(type:String, listener:Function):Void;

    /** @private */
    override public function removeEventListener(type:String, listener:Function):Void;

    // properties

    /** Padding can extend the size of the filter texture in all directions.
     *  That's useful when the filter "grows" the bounds of the object in any direction. */
    public var padding(get, set):Padding;
    private function get_padding():Padding;

    private function set_padding(value:Padding):Padding;

    /** Indicates if the filter is cached (via the <code>cache</code> method). */
    public var isCached(get, never):Bool;
    private function get_isCached():Bool;

    /** The resolution of the filter texture. "1" means stage resolution, "0.5" half the stage
     *  resolution. A lower resolution saves memory and execution time, but results in a lower
     *  output quality. Values greater than 1 are allowed; such values might make sense for a
     *  cached filter when it is scaled up. @default 1
     */
    public var resolution(get, set):Float;
    private function get_resolution():Float;
    private function set_resolution(value:Float):Float;

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
    private var maintainResolutionAcrossPasses(get, set):Bool;
    private function get_maintainResolutionAcrossPasses():Bool;
    private function set_maintainResolutionAcrossPasses(value:Bool):Bool;

    /** The anti-aliasing level. This is only used for rendering the target object
     *  into a texture, not for the filter passes. 0 - none, 4 - maximum. @default 0 */
    public var antiAliasing(get, set):Int;
    private function get_antiAliasing():Int;
    private function set_antiAliasing(value:Int):Int;

    /** The smoothing mode of the filter texture. @default bilinear */
    public var textureSmoothing(get, set):String;
    private function get_textureSmoothing():String;
    private function set_textureSmoothing(value:String):String;

    /** The format of the filter texture. @default BGRA */
    public var textureFormat(get, set):String;
    private function get_textureFormat():String;
    private function set_textureFormat(value:String):String;

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
    public var alwaysDrawToBackBuffer(get, set):Bool;
    private function get_alwaysDrawToBackBuffer():Bool;
    private function set_alwaysDrawToBackBuffer(value:Bool):Bool;
}

extern class FilterQuad extends Mesh
{
    public function new(smoothing:String);

    override public function dispose():Void;

    public function disposeTexture():Void;

    public function moveVertices(sourceSpace:DisplayObject, targetSpace:DisplayObject):Void;

    public function setBounds(bounds:Rectangle):Void;
}
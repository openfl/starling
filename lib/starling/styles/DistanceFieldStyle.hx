// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.styles;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.geom.Matrix;
import openfl.Vector;

import starling.core.Starling;
import starling.display.Mesh;
import starling.rendering.FilterEffect;
import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.RenderState;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.utils.Color;
import starling.utils.MathUtil;
import starling.utils.StringUtil;

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

@:jsRequire("starling/styles/DistanceFieldStyle", "default")

extern class DistanceFieldStyle extends MeshStyle
{
    /** The vertex format expected by this style. */
    public static var VERTEX_FORMAT:VertexDataFormat;

    /** Basic distance field rendering, without additional effects. */
    public static var MODE_BASIC:String;

    /** Adds an outline around the edge of the shape. */
    public static var MODE_OUTLINE:String;

    /** Adds a smooth glow effect around the shape. */
    public static var MODE_GLOW:String;

    /** Adds a drop shadow behind the shape. */
    public static var MODE_SHADOW:String;

    /** Creates a new distance field style.
     *
     *  @param softness   adds a soft transition between the inside and the outside.
     *                    This should typically be 1.0 divided by the spread (in points)
     *                    used when creating the distance field texture.
     *  @param threshold  the value separating the inside from the outside of the shape.
     *                    Range: 0 - 1.
     */
    public function new(softness:Float=0.125, threshold:Float=0.5);

    /** @private */
    override public function copyFrom(meshStyle:MeshStyle):Void;

    /** @private */
    override public function createEffect():MeshEffect;

    /** @private */
    override public function batchVertexData(targetStyle:MeshStyle, targetVertexID:Int = 0,
                                             matrix:Matrix = null, vertexID:Int = 0,
                                             numVertices:Int = -1):Void;

    /** @private */
    override public function updateEffect(effect:MeshEffect, state:RenderState):Void;

    /** @private */
    override public function canBatchWith(meshStyle:MeshStyle):Bool;

    // simplified setup

    /** Restores basic render mode, i.e. smooth rendering of the shape. */
    public function setupBasic():Void;

    /** Sets up outline rendering mode. The 'width' determines the threshold where the
     *  outline ends; 'width + threshold' must not exceed '1.0'.
     */
    public function setupOutline(width:Float=0.25, color:UInt=0x0, alpha:Float=1.0):Void;

    /** Sets up glow rendering mode. The 'blur' determines the threshold where the
     *  blur ends; 'blur + threshold' must not exceed '1.0'.
     */
    public function setupGlow(blur:Float=0.2, color:UInt=0xffff00, alpha:Float=0.5):Void;

    /** Sets up shadow rendering mode. The 'blur' determines the threshold where the drop
     *  shadow ends; 'offsetX' and 'offsetY' are expected in points.
     *
     *  <p>Beware that the style can only act within the limits of the mesh's vertices.
     *  This means that not all combinations of blur and offset are possible; too high values
     *  will cause the shadow to be cut off on the sides. Reduce either blur or offset to
     *  compensate.</p>
     */
    public function setupDropShadow(blur:Float=0.2, offsetX:Float=2, offsetY:Float=2,
                                    color:UInt=0x0, alpha:Float=0.5):Void;

    // properties

    /** The current render mode. It's recommended to use one of the 'setup...'-methods to
     *  change the mode, as those provide useful standard settings, as well. @default basic */
    public var mode(get, set):String;
    private function get_mode():String;
    private function set_mode(value:String):String;

    /** Indicates if the distance field texture utilizes multiple channels. This improves
        *  render quality, but requires specially created DF textures. @default false */
    public var multiChannel(get, set):Bool;
    private function get_multiChannel():Bool;
    private function set_multiChannel(value:Bool):Bool;

    /** The threshold that will separate the inside from the outside of the shape. On the
     *  distance field texture, '0' means completely outside, '1' completely inside; the
     *  actual edge runs along '0.5'. @default 0.5 */
    public var threshold(get, set):Float;
    private function get_threshold():Float;
    private function set_threshold(value:Float):Float;

    /** Indicates how soft the transition between inside and outside should be rendered.
     *  A value of '0' will lead to a hard, jagged edge; '1' will be just as blurry as the
     *  actual distance field texture. The recommend value should be <code>1.0 / spread</code>
     *  (you determine the spread when creating the distance field texture). @default 0.125 */
    public var softness(get, set):Float;
    private function get_softness():Float;
    private function set_softness(value:Float):Float;

    /** The alpha value with which the inner area (what's rendered in 'basic' mode) is drawn.
     *  @default 1.0 */
    public var alpha(get, set):Float;
    private function get_alpha():Float;
    private function set_alpha(value:Float):Float;

    /** The threshold that determines where the outer area (outline, glow, or drop shadow)
     *  ends. Ignored in 'basic' mode. */
    public var outerThreshold(get, set):Float;
    private function get_outerThreshold():Float;
    private function set_outerThreshold(value:Float):Float;

    /** The alpha value on the inner side of the outer area's gradient.
     *  Used for outline, glow, and drop shadow modes. */
    public var outerAlphaStart(get, set):Float;
    private function get_outerAlphaStart():Float;
    private function set_outerAlphaStart(value:Float):Float;

    /** The alpha value on the outer side of the outer area's gradient.
     *  Used for outline, glow, and drop shadow modes. */
    public var outerAlphaEnd(get, set):Float;
    private function get_outerAlphaEnd():Float;
    private function set_outerAlphaEnd(value:Float):Float;

    /** The color with which the outer area (outline, glow, or drop shadow) will be filled.
     *  Ignored in 'basic' mode. */
    public var outerColor(get, set):UInt;
    private function get_outerColor():UInt;
    private function set_outerColor(value:UInt):UInt;

    /** The x-offset of the shadow in points. Note that certain combinations of offset and
     *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
     *  counteract. */
    public var shadowOffsetX(get, set):Float;
    private function get_shadowOffsetX():Float;
    private function set_shadowOffsetX(value:Float):Float;

    /** The y-offset of the shadow in points. Note that certain combinations of offset and
     *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
     *  counteract. */
    public var shadowOffsetY(get, set):Float;
    private function get_shadowOffsetY():Float;
    private function set_shadowOffsetY(value:Float):Float;
}

extern class DistanceFieldEffect extends MeshEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat;
    public static var MAX_OUTER_OFFSET:Int;
    public static var MAX_SCALE:Int;

    public function new();

    public var scale(get, set):Float;
    private function get_scale():Float;
    private function set_scale(value:Float):Float;

    public var mode(get, set):String;
    private function get_mode():String;
    private function set_mode(value:String):String;

    public var multiChannel(get, set):Bool;
    private function get_multiChannel():Bool;
    private function set_multiChannel(value:Bool):Bool;

}

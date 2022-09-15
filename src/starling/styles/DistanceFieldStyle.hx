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
class DistanceFieldStyle extends MeshStyle
{
    /** The vertex format expected by this style. */
    public static var VERTEX_FORMAT:VertexDataFormat =
        MeshStyle.VERTEX_FORMAT.extend(
            "basic:bytes4, extended:bytes4, outerColor:bytes4");

    /** Basic distance field rendering, without additional effects. */
    public static inline var MODE_BASIC:String = "basic";

    /** Adds an outline around the edge of the shape. */
    public static inline var MODE_OUTLINE:String = "outline";

    /** Adds a smooth glow effect around the shape. */
    public static inline var MODE_GLOW:String = "glow";

    /** Adds a drop shadow behind the shape. */
    public static inline var MODE_SHADOW:String = "shadow";

    private var _mode:String;
    private var _multiChannel:Bool;

    // basic
    private var _threshold:Float;
    private var _alpha:Float;
    private var _softness:Float;

    // extended
    private var _outerThreshold:Float;
    private var _outerAlphaEnd:Float;
    private var _shadowOffsetX:Float;
    private var _shadowOffsetY:Float;
    
    // outerColor
    private var _outerColor:UInt;
    private var _outerAlphaStart:Float;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DistanceFieldStyle.prototype, {
            "mode": { get: untyped __js__ ("function () { return this.get_mode (); }"), set: untyped __js__ ("function (v) { return this.set_mode (v); }") },
            "multiChannel": { get: untyped __js__ ("function () { return this.get_multiChannel (); }"), set: untyped __js__ ("function (v) { return this.set_multiChannel (v); }") },
            "threshold": { get: untyped __js__ ("function () { return this.get_threshold (); }"), set: untyped __js__ ("function (v) { return this.set_threshold (v); }") },
            "softness": { get: untyped __js__ ("function () { return this.get_softness (); }"), set: untyped __js__ ("function (v) { return this.set_softness (v); }") },
            "alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
            "outerThreshold": { get: untyped __js__ ("function () { return this.get_outerThreshold (); }"), set: untyped __js__ ("function (v) { return this.set_outerThreshold (v); }") },
            "outerAlphaStart": { get: untyped __js__ ("function () { return this.get_outerAlphaStart (); }"), set: untyped __js__ ("function (v) { return this.set_outerAlphaStart (v); }") },
            "outerAlphaEnd": { get: untyped __js__ ("function () { return this.get_outerAlphaEnd (); }"), set: untyped __js__ ("function (v) { return this.set_outerAlphaEnd (v); }") },
            "outerColor": { get: untyped __js__ ("function () { return this.get_outerColor (); }"), set: untyped __js__ ("function (v) { return this.set_outerColor (v); }") },
            "shadowOffsetX": { get: untyped __js__ ("function () { return this.get_shadowOffsetX (); }"), set: untyped __js__ ("function (v) { return this.set_shadowOffsetX (v); }") },
            "shadowOffsetY": { get: untyped __js__ ("function () { return this.get_shadowOffsetY (); }"), set: untyped __js__ ("function (v) { return this.set_shadowOffsetY (v); }") },
        });
        
    }
    #end

    /** Creates a new distance field style.
     *
     *  @param softness   adds a soft transition between the inside and the outside.
     *                    This should typically be 1.0 divided by the spread (in points)
     *                    used when creating the distance field texture.
     *  @param threshold  the value separating the inside from the outside of the shape.
     *                    Range: 0 - 1.
     */
    public function new(softness:Float=0.125, threshold:Float=0.5)
    {
        super();
        
        _mode = MODE_BASIC;
        _threshold = threshold;
        _softness = softness;
        _alpha = 1.0;

        _outerThreshold = _outerAlphaEnd = 0.0;
        _shadowOffsetX = _shadowOffsetY = 0.0;
        
        _outerColor = 0x0;
        _outerAlphaStart = 0.0;
    }

    /** @private */
    override public function copyFrom(meshStyle:MeshStyle):Void
    {
        var otherStyle:DistanceFieldStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(meshStyle, DistanceFieldStyle) ? cast meshStyle : null;
        if (otherStyle != null)
        {
            _mode = otherStyle._mode;
            _multiChannel = otherStyle._multiChannel;
            _threshold = otherStyle._threshold;
            _softness = otherStyle._softness;
            _alpha = otherStyle._alpha;

            _outerThreshold = otherStyle._outerThreshold;
            _outerAlphaEnd  = otherStyle._outerAlphaEnd;
            _shadowOffsetX  = otherStyle._shadowOffsetX;
            _shadowOffsetY  = otherStyle._shadowOffsetY;

            _outerColor = otherStyle._outerColor;
            _outerAlphaStart = otherStyle._outerAlphaStart;
        }

        super.copyFrom(meshStyle);
    }

    /** @private */
    override public function createEffect():MeshEffect
    {
        return new DistanceFieldEffect();
    }

    /** @private */
    override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    /** @private */
    override private function onTargetAssigned(target:Mesh):Void
    {
        updateVertices();
    }

    private function updateVertices():Void
    {
        if (vertexData == null) return;

        // To save space, all settings are stored in 'bytes4' format; this means we write
        // values in the range 0-255 into the bytes and receive floats in the range 0-1 in the
        // shaders. Since the 'scale' and 'outerOffset' values require a different range,
        // they are encoded with a scale factor and/or offset. The color is stored manually
        // (not via 'setColor') to avoid PMA processing.

        var numVertices:Int = vertexData.numVertices;
        var maxScale:Int = DistanceFieldEffect.MAX_SCALE;
        var maxOuterOffset:Int = DistanceFieldEffect.MAX_OUTER_OFFSET;
        var encodedOuterOffsetX:Float = (_shadowOffsetX + maxOuterOffset) / (2 * maxOuterOffset);
        var encodedOuterOffsetY:Float = (_shadowOffsetY + maxOuterOffset) / (2 * maxOuterOffset);

        var basic:Int = (Std.int(_threshold      * 255)      ) |
                         (Std.int(_alpha          * 255) <<  8) |
                         (Std.int(_softness / 2.0 * 255) << 16) |
                         (Std.int(1.0 / maxScale  * 255) << 24);
        var extended:Int = (Std.int(_outerThreshold     * 255)      ) |
                            (Std.int(_outerAlphaEnd      * 255) <<  8) |
                            (Std.int(encodedOuterOffsetX * 255) << 16) |
                            (Std.int(encodedOuterOffsetY * 255) << 24);
        var outerColor:Int = (Color.getRed(_outerColor)         ) |
                              (Color.getGreen(_outerColor)  <<  8) |
                              (Color.getBlue(_outerColor)   << 16) |
                              (Std.int(_outerAlphaStart * 255) << 24);

        for (i in 0...numVertices)
        {
            vertexData.setUnsignedInt(i, "basic", basic);
            vertexData.setUnsignedInt(i, "extended", extended);
            vertexData.setUnsignedInt(i, "outerColor", outerColor);
        }

        setVertexDataChanged();
    }

    /** @private */
    override public function batchVertexData(targetStyle:MeshStyle, targetVertexID:Int = 0,
                                             matrix:Matrix = null, vertexID:Int = 0,
                                             numVertices:Int = -1):Void
    {
        super.batchVertexData(targetStyle, targetVertexID, matrix, vertexID, numVertices);

        if (matrix != null)
        {
            var scale:Float = Math.sqrt(matrix.a * matrix.a + matrix.c * matrix.c);

            if (!MathUtil.isEquivalent(scale, 1.0, 0.01))
            {
                var targetVertexData:VertexData = cast(targetStyle, DistanceFieldStyle).vertexData;
                var maxScale:Float = DistanceFieldEffect.MAX_SCALE;
                var minScale:Float = maxScale / 255;
                
                if (numVertices < 0)
                    numVertices = vertexData.numVertices - vertexID;

                for (i in 0...numVertices)
                {
                    var srcAttr:UInt = vertexData.getUnsignedInt(vertexID + i, "basic");
                    var srcScale:Float = ((srcAttr >> 24) & 0xff) / 255.0 * maxScale;
                    var tgtScale:Float = MathUtil.clamp(srcScale * scale, minScale, maxScale);
                    var tgtAttr:UInt =
                        (srcAttr & 0x00ffffff) | (Std.int(tgtScale / maxScale * 255) << 24);

                    targetVertexData.setUnsignedInt(targetVertexID + i, "basic", tgtAttr);
                }
            }
        }
    }

    /** @private */
    override public function updateEffect(effect:MeshEffect, state:RenderState):Void
    {
        var dfEffect:DistanceFieldEffect = cast effect;
        dfEffect.mode = _mode;
        dfEffect.multiChannel = _multiChannel;

        if (state.is3D) dfEffect.scale = 1.0;
        else
        {
            // The softness is adapted automatically with the total scale of the object;
            // this only works for 2D objects, though. Since a 'texture scale' does not
            // make much sense for distance field textures, it is eliminated.

            var matrix:Matrix = state.modelviewMatrix;
            var scale:Float = Math.sqrt(matrix.a * matrix.a + matrix.c * matrix.c);
            dfEffect.scale = scale * Starling.current.contentScaleFactor;
        }

        super.updateEffect(effect, state);
    }

    /** @private */
    override public function canBatchWith(meshStyle:MeshStyle):Bool
    {
        var dfStyle:DistanceFieldStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(meshStyle, DistanceFieldStyle) ? cast meshStyle : null;
        if (dfStyle != null && super.canBatchWith(meshStyle))
            return dfStyle._mode == _mode && dfStyle._multiChannel == _multiChannel;
        else
            return false;
    }

    // simplified setup

    /** Restores basic render mode, i.e. smooth rendering of the shape. */
    public function setupBasic():Void
    {
        _mode = MODE_BASIC;

        setRequiresRedraw();
    }

    /** Sets up outline rendering mode. The 'width' determines the threshold where the
     *  outline ends; 'width + threshold' must not exceed '1.0'.
     */
    public function setupOutline(width:Float=0.25, color:UInt=0x0, alpha:Float=1.0):Void
    {
        _mode = MODE_OUTLINE;
        _outerThreshold = MathUtil.clamp(_threshold - width, 0, _threshold);
        _outerColor = color;
        _outerAlphaStart = _outerAlphaEnd = MathUtil.clamp(alpha, 0, 1);
        _shadowOffsetX = _shadowOffsetY = 0.0;

        updateVertices();
    }

    /** Sets up glow rendering mode. The 'blur' determines the threshold where the
     *  blur ends; 'blur + threshold' must not exceed '1.0'.
     */
    public function setupGlow(blur:Float=0.2, color:UInt=0xffff00, alpha:Float=0.5):Void
    {
        _mode = MODE_GLOW;
        _outerThreshold = MathUtil.clamp(_threshold - blur, 0, _threshold);
        _outerColor = color;
        _outerAlphaStart = MathUtil.clamp(alpha, 0, 1);
        _outerAlphaEnd = 0.0;
        _shadowOffsetX = _shadowOffsetY = 0.0;

        updateVertices();
    }

    /** Sets up shadow rendering mode. The 'blur' determines the threshold where the drop
     *  shadow ends; 'offsetX' and 'offsetY' are expected in points.
     *
     *  <p>Beware that the style can only act within the limits of the mesh's vertices.
     *  This means that not all combinations of blur and offset are possible; too high values
     *  will cause the shadow to be cut off on the sides. Reduce either blur or offset to
     *  compensate.</p>
     */
    public function setupDropShadow(blur:Float=0.2, offsetX:Float=2, offsetY:Float=2,
                                    color:UInt=0x0, alpha:Float=0.5):Void
    {
        var maxOffset:Float = DistanceFieldEffect.MAX_OUTER_OFFSET;

        _mode = MODE_SHADOW;
        _outerThreshold = MathUtil.clamp(_threshold - blur, 0, _threshold);
        _outerColor = color;
        _outerAlphaStart = MathUtil.clamp(alpha, 0, 1);
        _outerAlphaEnd = 0.0;
        _shadowOffsetX = MathUtil.clamp(offsetX, -maxOffset, maxOffset);
        _shadowOffsetY = MathUtil.clamp(offsetY, -maxOffset, maxOffset);

        updateVertices();
    }

    // properties

    /** The current render mode. It's recommended to use one of the 'setup...'-methods to
     *  change the mode, as those provide useful standard settings, as well. @default basic */
    public var mode(get, set):String;
    private function get_mode():String { return _mode; }
    private function set_mode(value:String):String
    {
        _mode = value;
        setRequiresRedraw();
        return value;
    }

    /** Indicates if the distance field texture utilizes multiple channels. This improves
        *  render quality, but requires specially created DF textures. @default false */
    public var multiChannel(get, set):Bool;
    private function get_multiChannel():Bool { return _multiChannel; }
    private function set_multiChannel(value:Bool):Bool
    {
        _multiChannel = value;
        setRequiresRedraw();
        return value;
    }

    /** The threshold that will separate the inside from the outside of the shape. On the
     *  distance field texture, '0' means completely outside, '1' completely inside; the
     *  actual edge runs along '0.5'. @default 0.5 */
    public var threshold(get, set):Float;
    private function get_threshold():Float { return _threshold; }
    private function set_threshold(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_threshold != value)
        {
            _threshold = value;
            updateVertices();
        }
        return value;
    }

    /** Indicates how soft the transition between inside and outside should be rendered.
     *  A value of '0' will lead to a hard, jagged edge; '1' will be just as blurry as the
     *  actual distance field texture. The recommend value should be <code>1.0 / spread</code>
     *  (you determine the spread when creating the distance field texture). @default 0.125 */
    public var softness(get, set):Float;
    private function get_softness():Float { return _softness; }
    private function set_softness(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_softness != value)
        {
            _softness = value;
            updateVertices();
        }
        return value;
    }

    /** The alpha value with which the inner area (what's rendered in 'basic' mode) is drawn.
     *  @default 1.0 */
    public var alpha(get, set):Float;
    private function get_alpha():Float { return _alpha; }
    private function set_alpha(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_alpha != value)
        {
            _alpha = value;
            updateVertices();
        }
        return value;
    }

    /** The threshold that determines where the outer area (outline, glow, or drop shadow)
     *  ends. Ignored in 'basic' mode. */
    public var outerThreshold(get, set):Float;
    private function get_outerThreshold():Float { return _outerThreshold; }
    private function set_outerThreshold(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_outerThreshold != value)
        {
            _outerThreshold = value;
            updateVertices();
        }
        return value;
    }

    /** The alpha value on the inner side of the outer area's gradient.
     *  Used for outline, glow, and drop shadow modes. */
    public var outerAlphaStart(get, set):Float;
    private function get_outerAlphaStart():Float { return _outerAlphaStart; }
    private function set_outerAlphaStart(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_outerAlphaStart != value)
        {
            _outerAlphaStart = value;
            updateVertices();
        }
        return value;
    }

    /** The alpha value on the outer side of the outer area's gradient.
     *  Used for outline, glow, and drop shadow modes. */
    public var outerAlphaEnd(get, set):Float;
    private function get_outerAlphaEnd():Float { return _outerAlphaEnd; }
    private function set_outerAlphaEnd(value:Float):Float
    {
        value = MathUtil.clamp(value, 0, 1);

        if (_outerAlphaEnd != value)
        {
            _outerAlphaEnd = value;
            updateVertices();
        }
        return value;
    }

    /** The color with which the outer area (outline, glow, or drop shadow) will be filled.
     *  Ignored in 'basic' mode. */
    public var outerColor(get, set):UInt;
    private function get_outerColor():UInt { return _outerColor; }
    private function set_outerColor(value:UInt):UInt
    {
        if (_outerColor != value)
        {
            _outerColor = value;
            updateVertices();
        }
        return value;
    }

    /** The x-offset of the shadow in points. Note that certain combinations of offset and
     *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
     *  counteract. */
    public var shadowOffsetX(get, set):Float;
    private function get_shadowOffsetX():Float { return _shadowOffsetX; }
    private function set_shadowOffsetX(value:Float):Float
    {
        var max:Float = DistanceFieldEffect.MAX_OUTER_OFFSET;
        value = MathUtil.clamp(value, -max, max);

        if (_shadowOffsetX != value)
        {
            _shadowOffsetX = value;
            updateVertices();
        }
        return value;
    }

    /** The y-offset of the shadow in points. Note that certain combinations of offset and
     *  blur value can lead the shadow to be cut off at the edges. Reduce blur or offset to
     *  counteract. */
    public var shadowOffsetY(get, set):Float;
    private function get_shadowOffsetY():Float { return _shadowOffsetY; }
    private function set_shadowOffsetY(value:Float):Float
    {
        var max:Float = DistanceFieldEffect.MAX_OUTER_OFFSET;
        value = MathUtil.clamp(value, -max, max);

        if (_shadowOffsetY != value)
        {
            _shadowOffsetY = value;
            updateVertices();
        }
        return value;
    }
}

class DistanceFieldEffect extends MeshEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat = DistanceFieldStyle.VERTEX_FORMAT;
    public static inline var MAX_OUTER_OFFSET:Int = 8;
    public static inline var MAX_SCALE:Int = 8;

    private var _mode:String;
    private var _scale:Float;
    private var _multiChannel:Bool;

    private static var sVector:Vector<Float> = new Vector<Float>(4, true);

    public function new()
    {
        super();
        _scale = 1.0;
        _mode = DistanceFieldStyle.MODE_BASIC;
    }

    override private function createProgram():Program
    {
        if (texture != null)
        {
            // va0 - position
            // va1 - tex coords
            // va2 - color
            // va3 - basic settings (threshold, alpha, softness, local scale [encoded])
            // va4 - outer settings (outerThreshold, outerAlphaEnd, outerOffsetX/Y)
            // va5 - outer color (rgb, outerAlphaStart)
            // vc5 - shadow offset multiplier (x, y), max local scale (z), global scale (w)

            var isBasicMode:Bool  = _mode == DistanceFieldStyle.MODE_BASIC;
            var isShadowMode:Bool = _mode == DistanceFieldStyle.MODE_SHADOW;

            /// *** VERTEX SHADER ***

            var vertexShader:Vector<String> = new Vector<String>([
                "m44 op, va0, vc0",       // 4x4 matrix transform to output clip-space
                "mov v0, va1",            // pass texture coordinates to fragment program
                "mul vt4, va3.yyyy, vc4", // multiply inner alpha (va3.y) with state alpha (vc4)
                "mul v1, va2, vt4",       // multiply vertex color (va2) with combined alpha (vt4)
                "mov v3, va3",
                "mov v4, va4",
                "mov v5, va5",

                // multiply outerAlphaStart and outerAlphaEnd with state alpha and vertex alpha
                "mul vt4.w, vc4.w, va2.w", // state alpha (vc4) * vertex alpha (va2.w)
                "mul v4.y, va4.y, vt4.w",  // v4.x = outerAlphaEnd
                "mul v5.w, va5.w, vt4.w",  // v5.w = outerAlphaStart

                // update softness to take current scale into account
                "mul vt0.x, va3.w, vc5.z", // vt0.x = local scale [decoded]
                "mul vt0.x, vt0.x, vc5.w", // vt0.x *= global scale
                "div vt0.x, va3.z, vt0.x", // vt0.x = softness / total scale

                // calculate min-max of threshold
                "mov vt1, vc4",             // initialize vt1 with something (anything)
                "sub vt1.x, va3.x, vt0.x",  // vt1.x = thresholdMin
                "add vt1.y, va3.x, vt0.x"   // vt1.y = thresholdMax
            ]);

            if (!isBasicMode)
            {
                // calculate min-max of outer threshold
                vertexShader.push("sub vt1.z, va4.x, vt0.x");     // vt1.z = outerThresholdMin
                vertexShader.push("add vt1.w, va4.x, vt0.x");     // vt1.w = outerThresholdMax
            }

            vertexShader.push("sat v6, vt1"); // v6.xyzw = thresholdMin/Max, outerThresholdMin/Max

            if (isShadowMode)
            {
                // calculate shadow offset
                vertexShader.push("mul vt0.xy, va4.zw, vc6.zz"); // vt0.x/y = outerOffsetX/Y * 2
                vertexShader.push("sub vt0.xy, vt0.xy, vc6.yy"); // vt0.x/y -= 1   -> range -1, 1
                vertexShader.push("mul vt0.xy, vt0.xy, vc5.xy"); // vt0.x/y = outerOffsetX/Y in point size
                vertexShader.push("sub v7, va1, vt0.xyxy");      // v7.xy = shadow tex coords

                // on shadows, the inner threshold is further inside than on glow & outline
                vertexShader.push("sub vt0.z, va3.x, va4.x");    // get delta between threshold and outer threshold
                vertexShader.push("add v7.z, va3.x, vt0.z");     // v7.z = inner threshold of shadow
            }

            /// *** FRAGMENT SHADER ***

            var fragmentShader:Vector<String> = new Vector<String>([
                // create basic inner area
                FilterEffect.tex("ft0", "v0", 0, texture),     // ft0 = texture color
                _multiChannel ? median("ft0") : "mov ft0, ft0.xxxx",
                "mov ft1, ft0",                   // ft1 = texture color
                step("ft1.w", "v6.x", "v6.y"),    // make soft inner mask
                "mov ft3, ft1",                   // store copy of inner mask in ft3 (for outline)
                "mul ft1, v1, ft1.wwww"           // multiply with color
            ]);

            if (isShadowMode)
            {
                fragmentShader.push(FilterEffect.tex("ft0", "v7", 0, texture)); // sample at shadow tex coords
                fragmentShader.push(_multiChannel ? median("ft0") : "mov ft0, ft0.xxxx");
                fragmentShader.push("mov ft5.x, v7.z"); // ft5.x = inner threshold of shadow
            }
            else if (!isBasicMode)
            {
                fragmentShader.push(
                    "mov ft5.x, v6.x"             // ft5.x = inner threshold of outer area
                );
            }

            if (!isBasicMode)
            {
                // outer area
                fragmentShader.push("mov ft2, ft0");                 // ft2 = texture color
                fragmentShader.push(step("ft2.w", "v6.z", "v6.w"));  // make soft outer mask
                fragmentShader.push("sub ft2.w, ft2.w, ft3.w");      // subtract inner area
                fragmentShader.push("sat ft2.w, ft2.w");             // but stay within 0-1

                // add alpha gradient to outer area
                fragmentShader.push("mov ft4, ft0");                 // ft4 = texture color
                fragmentShader.push(step("ft4.w", "v6.z", "ft5.x")); // make soft mask ranging between thresholds
                fragmentShader.push("sub ft6.w, v5.w, v4.y");        // ft6.w  = alpha range (outerAlphaStart - End)
                fragmentShader.push("mul ft4.w, ft4.w, ft6.w");      // ft4.w *= alpha range
                fragmentShader.push("add ft4.w, ft4.w, v4.y");       // ft4.w += alpha end

                // colorize outer area
                fragmentShader.push("mul ft2.w, ft2.w, ft4.w");      // get final outline alpha at this position
                fragmentShader.push("mul ft2.xyz, v5.xyz, ft2.www"); // multiply with outerColor
            }

            if (isBasicMode) fragmentShader.push("mov oc, ft1");
            else             fragmentShader.push("add oc, ft1, ft2");

            return Program.fromSource(vertexShader.join("\n"), fragmentShader.join("\n"));
        }
        else return super.createProgram();
    }

    private static function step(inOutReg:String, minReg:String, maxReg:String,
                                tmpReg:String="ft6"):String
    {
        var ops:Vector<String> = new Vector<String>([
            StringUtil.format("sub {0}, {1}, {2}", [tmpReg, maxReg, minReg]), // tmpReg = range
            StringUtil.format("rcp {0}, {0}", [tmpReg]),                      // tmpReg = scale
            StringUtil.format("sub {0}, {0}, {1}", [inOutReg, minReg]),       // inOut -= minimum
            StringUtil.format("mul {0}, {0}, {1}", [inOutReg, tmpReg]),       // inOut *= scale
            StringUtil.format("sat {0}, {0}", [inOutReg])                     // clamp to 0-1
        ]);

        return ops.join("\n");
    }

    private static function median(inOutReg:String):String
    {
        return [
            StringUtil.format("max {0}.xyz, {0}.xxy, {0}.yzz", [inOutReg]),
            StringUtil.format("min {0}.x, {0}.x, {0}.y", [inOutReg]),
            StringUtil.format("min {0}, {0}.xxxx, {0}.zzzz", [inOutReg])
        ].join("\n");
    }

    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);

        if (texture != null)
        {
            vertexFormat.setVertexBufferAt(3, vertexBuffer, "basic");
            vertexFormat.setVertexBufferAt(4, vertexBuffer, "extended");
            vertexFormat.setVertexBufferAt(5, vertexBuffer, "outerColor");

            var pixelWidth:Float  = 1.0 / (texture.root.nativeWidth  / texture.scale);
            var pixelHeight:Float = 1.0 / (texture.root.nativeHeight / texture.scale);

            sVector[0] = MAX_OUTER_OFFSET * pixelWidth;
            sVector[1] = MAX_OUTER_OFFSET * pixelHeight;
            sVector[2] = MAX_SCALE;
            sVector[3] = _scale;

            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, sVector);

            sVector[0] = 0.0;
            sVector[1] = 1.0;
            sVector[2] = 2.0;

            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, sVector);
        }
    }

    override private function afterDraw(context:Context3D):Void
    {
        if (texture != null)
        {
            context.setVertexBufferAt(3, null);
            context.setVertexBufferAt(4, null);
            context.setVertexBufferAt(5, null);
        }
        super.afterDraw(context);
    }

    override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    override private function get_programVariantName():UInt
    {
        var modeBits:UInt;

        switch (_mode)
        {
            case DistanceFieldStyle.MODE_SHADOW:  modeBits = 3;
            case DistanceFieldStyle.MODE_GLOW:    modeBits = 2;
            case DistanceFieldStyle.MODE_OUTLINE: modeBits = 1;
            default:                              modeBits = 0;
        }

        if (_multiChannel) modeBits |= (1 << 2);

        return super.programVariantName | (modeBits << 8);
    }

    public var scale(get, set):Float;
    private function get_scale():Float { return _scale; }
    private function set_scale(value:Float):Float { return _scale = value; }

    public var mode(get, set):String;
    private function get_mode():String { return _mode; }
    private function set_mode(value:String):String { return _mode = value; }

    public var multiChannel(get, set):Bool;
    private function get_multiChannel():Bool { return _multiChannel; }
    private function set_multiChannel(value:Bool):Bool { return _multiChannel = value; }

}

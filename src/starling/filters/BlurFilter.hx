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

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.Vector;

import starling.core.Starling;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.textures.Texture;
import starling.utils.MathUtil;

/** The BlurFilter applies a Gaussian blur to an object. The strength of the blur can be
 *  set for x- and y-axis separately. */
class BlurFilter extends FragmentFilter
{
    @:noCompletion private var __blurX:Float;
    @:noCompletion private var __blurY:Float;
    @:noCompletion private var __quality:Float;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (BlurFilter.prototype, {
            "totalBlurX": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_totalBlurX (); }") },
            "totalBlurY": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_totalBlurY (); }") },
            "blurX": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurX (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurX (v); }") },
            "blurY": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurY (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurY (v); }") },
            "quality": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_quality (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_quality (v); }") },
            "direction": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_direction (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_direction (v); }") },
            "strength": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_strength (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_strength (v); }") },
        });
        
    }
    #end

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
    public function new(blurX:Float=1.0, blurY:Float=1.0, resolution:Float=1.0)
    {
        super();
        __blurX = Math.abs(blurX);
        __blurY = Math.abs(blurY);
        __quality = 1.0;
        this.resolution = resolution;
        this.maintainResolutionAcrossPasses = true;
    }

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        var effect:BlurEffect = cast this.effect;

        if (__blurX == 0 && __blurY == 0)
        {
            effect.strength = 0;
            return super.process(painter, helper, input0);
        }

        var inTexture:Texture;
        var outTexture:Texture = input0;
        var strengthX:Float = totalBlurX;
        var strengthY:Float = totalBlurY;

        effect.quality = __quality;
        effect.direction = BlurEffect.HORIZONTAL;

        while (strengthX > 0)
        {
            effect.strength = strengthX;

            inTexture = outTexture;
            outTexture = super.process(painter, helper, inTexture);

            if (inTexture != input0) helper.putTexture(inTexture);
            if (strengthX <= 1) break; else strengthX /= 2;
        }

        effect.direction = BlurEffect.VERTICAL;

        while (strengthY > 0)
        {
            effect.strength = strengthY;

            inTexture = outTexture;
            outTexture = super.process(painter, helper, inTexture);

            if (inTexture != input0) helper.putTexture(inTexture);
            if (strengthY <= 1) break; else strengthY /= 2;
        }

        return outTexture;
    }

    /** @private */
    override private function createEffect():FilterEffect
    {
        return new BlurEffect();
    }

    /** @private */
    override private function set_resolution(value:Float):Float
    {
        super.resolution = value;
        updatePadding();
        return value;
    }

    private function updatePadding():Void
    {
        var paddingX:Float = __blurX != 0 ? (totalBlurX * 3 + 2) / (resolution * __quality) : 0;
        var paddingY:Float = __blurY != 0 ? (totalBlurY * 3 + 2) / (resolution * __quality) : 0;

        padding.setTo(paddingX, paddingX, paddingY, paddingY);
    }

    /** @private */
    override private function get_numPasses():Int
    {
        if (__blurX == 0 && __blurY == 0) return 1;
        else return getNumPasses(totalBlurX) + getNumPasses(totalBlurY);
    }

    private static function getNumPasses(blur:Float):Int
    {
        var numPasses:Int = 1;
        while (blur > 1) { numPasses += 1; blur /= 2; }
        return numPasses;
    }

    /** The blur values scaled by the current contentScaleFactor. */
    private var totalBlurX(get, never):Float;
    private function get_totalBlurX():Float { return __blurX * Starling.current.contentScaleFactor; }
    private var totalBlurY(get, never):Float;
    private function get_totalBlurY():Float { return __blurY * Starling.current.contentScaleFactor; }

    /** The blur factor in x-direction.
     *  The number of required passes will be <code>Math.ceil(value)</code>. */
    public var blurX(get, set):Float;
    private function get_blurX():Float { return __blurX; }
    private function set_blurX(value:Float):Float
    {
        if (__blurX != value)
        {
            __blurX = Math.abs(value);
            updatePadding();
        }
        return value;
    }

    /** The blur factor in y-direction.
     *  The number of required passes will be <code>Math.ceil(value)</code>. */
    public var blurY(get, set):Float;
    private function get_blurY():Float { return __blurY; }
    private function set_blurY(value:Float):Float
    {
        if (__blurY != value)
        {
            __blurY = Math.abs(value);
            updatePadding();
        }
        return value;
    }

    /** The quality of the blur effect. Low values will look as if the target was drawn
     *  multiple times in close proximity (range: 0.1 - 1).
     *
     *  <p>Typically, it's better to reduce the filter resolution instead; however, if that
     *  is not an option (e.g. when using the BlurFilter as part of a composite filter),
     *  this property may provide an alternative.</p>
     *
     *  @default 1.0
     */
    public var quality(get, set):Float;
    public function get_quality():Float { return __quality; }
    public function set_quality(value:Float):Float
    {
        if (__quality != value)
        {
            __quality = MathUtil.clamp(value, 0.1, 1.0);
            updatePadding();
        }
        return value;
    }
}


class BlurEffect extends FilterEffect
{
    public static inline var HORIZONTAL:String = "horizontal";
    public static inline var VERTICAL:String = "vertical";

    private var _strength:Float;
    private var _direction:String;
    private var _quality:Float;

    private static var sTmpWeights:Vector<Float> = new Vector<Float>([0, 0, 0, 0, 0.]);
    private static var sWeights:Vector<Float> = new Vector<Float>([0, 0, 0, 0.]);
    private static var sOffsets:Vector<Float> = new Vector<Float>([0, 0, 0, 0.]);

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (BlurEffect.prototype, {
            "direction": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_direction (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_direction (v); }") },
            "strength": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_strength (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_strength (v); }") },
            "quality": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_quality (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_quality (v); }") },
        });
        
    }
    #end

    /** Creates a new BlurEffect. */
    public function new():Void
    {
        super();
        _strength = 0.0;
        _direction = HORIZONTAL;
       _quality = 1.0;
    }

    override private function createProgram():Program
    {
        if (_strength == 0) return super.createProgram();

        // vc4.xy - offset1
        // vc4.zw - offset2

        var vertexShader:String = [
            "m44 op, va0, vc0      ", // 4x4 matrix transform to output space
            "mov v0, va1           ", // pos:  0 (center)

            "add v1,  va1, vc4.xyww", // pos: +1
            "sub v2,  va1, vc4.xyww", // pos: -1

            "add v3,  va1, vc4.zwxx", // pos: +2
            "sub v4,  va1, vc4.zwxx"  // pos: -2
        ].join("\n");

        // v0-v6 - kernel positions
        // fs0   - input texture
        // fc0   - weight data
        // ft0-4 - pixel color from texture
        // ft5   - output color

        var fragmentShader:String = [
            FilterEffect.tex("ft0", "v0", 0, texture),    // read center pixel
            "mul ft5, ft0, fc0.xxxx       ", // multiply with center weight

            FilterEffect.tex("ft1", "v1", 0, texture),    // read pixel +1
            "mul ft1, ft1, fc0.yyyy       ", // multiply with weight
            "add ft5, ft5, ft1            ", // add to output color

            FilterEffect.tex("ft2", "v2", 0, texture),    // read pixel -1
            "mul ft2, ft2, fc0.yyyy       ", // multiply with weight
            "add ft5, ft5, ft2            ", // add to output color

            FilterEffect.tex("ft3", "v3", 0, texture),    // read pixel +2
            "mul ft3, ft3, fc0.zzzz       ", // multiply with weight
            "add ft5, ft5, ft3            ", // add to output color

            FilterEffect.tex("ft4", "v4", 0, texture),    // read pixel -2
            "mul ft4, ft4, fc0.zzzz       ", // multiply with weight
            "add  oc, ft5, ft4            "  // add to output color
        ].join("\n");

        return Program.fromSource(vertexShader, fragmentShader);
    }

    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);

        if (_strength != 0)
        {
            updateParameters();

            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,   4, sOffsets);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, sWeights);
        }
    }

    private function updateParameters():Void
    {
        var offset1:Float, offset2:Float;
        var pixelSize:Float = 1.0 / (_direction == HORIZONTAL ?
                texture.root.nativeWidth : texture.root.nativeHeight);

        if (_strength <= 1)
        {
            // algorithm described here:
            // http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
            //
            // To support the baseline constrained profile, we can only make 5 texture look-ups
            // in the fragment shader. By making use of linear texture sampling, we can produce
            // similar output to what would be 9 look-ups.

            var sigma:Float = _strength * 2;
            var twoSigmaSq:Float = 2 * sigma * sigma;
            var multiplier:Float = 1.0 / Math.sqrt(twoSigmaSq * Math.PI);

            // get weights on the exact pixels (sTmpWeights) and calculate sums (sWeights)

            for (i in 0...5)
                sTmpWeights[i] = multiplier * Math.exp(-i*i / twoSigmaSq);

            sWeights[0] = sTmpWeights[0];
            sWeights[1] = sTmpWeights[1] + sTmpWeights[2];
            sWeights[2] = sTmpWeights[3] + sTmpWeights[4];

            // normalize weights so that sum equals "1.0"

            var weightSum:Float = sWeights[0] + 2 * sWeights[1] + 2 * sWeights[2];
            var invWeightSum:Float = 1.0 / weightSum;

            sWeights[0] *= invWeightSum;
            sWeights[1] *= invWeightSum;
            sWeights[2] *= invWeightSum;

            // calculate intermediate offsets

            offset1 = (    sTmpWeights[1] + 2 * sTmpWeights[2]) / sWeights[1];
            offset2 = (3 * sTmpWeights[3] + 4 * sTmpWeights[4]) / sWeights[2];
        }
        else
        {
            // All other passes look up 5 texels with a standard gauss distribution and bigger
            // offsets. In itself, this looks as if the object was drawn multiple times; combined
            // with the last pass (strength <= 1), though, the result is a very strong blur.

            sWeights[0] = 0.29412;
            sWeights[1] = 0.23529;
            sWeights[2] = 0.11765;

            offset1 = _strength * 1.3; // the additional '0.3' compensate the difference between
            offset2 = _strength * 2.3; // the two gauss distributions.
        }

        // depending on pass, we move in x- or y-direction

        if (_direction == HORIZONTAL)
        {
            sOffsets[0] = offset1 * pixelSize / _quality; sOffsets[1] = 0;
            sOffsets[2] = offset2 * pixelSize / _quality; sOffsets[3] = 0;
        }
        else
        {
            sOffsets[0] = 0; sOffsets[1] = offset1 * pixelSize / _quality;
            sOffsets[2] = 0; sOffsets[3] = offset2 * pixelSize / _quality;
        }
    }

    override private function get_programVariantName():UInt
    {
        return super.programVariantName | (_strength != 0 ? 1 << 4 : 0);
    }

    public var direction(get, set):String;
    private function get_direction():String { return _direction; }
    private function set_direction(value:String):String { return _direction = value; }

    public var strength(get, set):Float;
    private function get_strength():Float { return _strength; }
    private function set_strength(value:Float):Float { return _strength = value; }

    public var quality(get, set):Float;
    private function get_quality():Float { return _quality; }
    private function set_quality(value:Float):Float { return _quality = value; }
}

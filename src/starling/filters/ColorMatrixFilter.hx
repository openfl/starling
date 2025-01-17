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
import openfl.errors.ArgumentError;
import openfl.Vector;

import starling.rendering.FilterEffect;
import starling.rendering.Program;
import starling.utils.Color;

/** The ColorMatrixFilter class lets you apply a 4x5 matrix transformation to the color
 *  and alpha values of every pixel in the input image to produce a result with a new set
 *  of color and alpha values. This allows saturation changes, hue rotation,
 *  luminance to alpha, and various other effects.
 *
 *  <p>The class contains several convenience methods for frequently used color
 *  adjustments. All those methods change the current matrix, which means you can easily
 *  combine them in one filter:</p>
 *
 *  <listing>
 *  // create an inverted filter with 50% saturation and 180° hue rotation
 *  var filter:ColorMatrixFilter = new ColorMatrixFilter();
 *  filter.invert();
 *  filter.adjustSaturation(-0.5);
 *  filter.adjustHue(1.0);</listing>
 *
 *  <p>If you want to gradually animate one of the predefined color adjustments, either reset
 *  the matrix after each step, or use an identical adjustment value for each step; the
 *  changes will add up.</p>
 */
class ColorMatrixFilter extends FragmentFilter
{
    // Most of the color transformation math was taken from the excellent ColorMatrix class by
    // Mario Klingemann: http://www.quasimondo.com/archives/000565.php -- THANKS!!!

    private static inline var LUMA_R:Float = 0.299;
    private static inline var LUMA_G:Float = 0.587;
    private static inline var LUMA_B:Float = 0.114;

    // helpers
    private static var sMatrix:Vector<Float> = new Vector<Float>();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (ColorMatrixFilter.prototype, {
            "matrix": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }") },
            "colorEffect": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_colorEffect (); }") },
        });
        
    }
    #end

    /** Creates a new ColorMatrixFilter instance with the specified matrix.
     *  @param matrix a vector of 20 items arranged as a 4x5 matrix.
     */
    public function new(matrix:Vector<Float>=null)
    {
        super();
        if (matrix != null) colorEffect.matrix = matrix;
    }

    /** @private */
    override private function createEffect():FilterEffect
    {
        return new ColorMatrixEffect();
    }

    // color manipulation

    /** Inverts the colors of the filtered object. */
    public function invert():Void
    {
        concatValues(-1,  0,  0,  0, 255,
                      0, -1,  0,  0, 255,
                      0,  0, -1,  0, 255,
                      0,  0,  0,  1,   0);
    }

    /** Changes the saturation. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the saturation.
     *  '-1' will produce a grayscale image. */
    public function adjustSaturation(sat:Float):Void
    {
        sat += 1;

        var invSat:Float  = 1 - sat;
        var invLumR:Float = invSat * LUMA_R;
        var invLumG:Float = invSat * LUMA_G;
        var invLumB:Float = invSat * LUMA_B;

        concatValues((invLumR + sat), invLumG,  invLumB, 0, 0,
                      invLumR, (invLumG + sat), invLumB, 0, 0,
                      invLumR, invLumG, (invLumB + sat), 0, 0,
                      0, 0, 0, 1, 0);
    }

    /** Changes the contrast. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the contrast. */
    public function adjustContrast(value:Float):Void
    {
        var s:Float = value + 1;
        var o:Float = 128 * (1 - s);

        concatValues(s, 0, 0, 0, o,
                     0, s, 0, 0, o,
                     0, 0, s, 0, o,
                     0, 0, 0, 1, 0);
    }

    /** Changes the brightness. Typical values are in the range (-1, 1).
     *  Values above zero will make the image brighter, values below zero will make it darker.*/
    public function adjustBrightness(value:Float):Void
    {
        value *= 255;

        concatValues(1, 0, 0, 0, value,
                     0, 1, 0, 0, value,
                     0, 0, 1, 0, value,
                     0, 0, 0, 1, 0);
    }

    /** Changes the hue of the image. Typical values are in the range (-1, 1). */
    public function adjustHue(value:Float):Void
    {
        value *= Math.PI;

        var cos:Float = Math.cos(value);
        var sin:Float = Math.sin(value);

        concatValues(
            ((LUMA_R + (cos * (1 - LUMA_R))) + (sin * -(LUMA_R))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * -(LUMA_G))), ((LUMA_B + (cos * -(LUMA_B))) + (sin * (1 - LUMA_B))), 0, 0,
            ((LUMA_R + (cos * -(LUMA_R))) + (sin * 0.143)), ((LUMA_G + (cos * (1 - LUMA_G))) + (sin * 0.14)), ((LUMA_B + (cos * -(LUMA_B))) + (sin * -0.283)), 0, 0,
            ((LUMA_R + (cos * -(LUMA_R))) + (sin * -((1 - LUMA_R)))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * LUMA_G)), ((LUMA_B + (cos * (1 - LUMA_B))) + (sin * LUMA_B)), 0, 0,
            0, 0, 0, 1, 0);
    }

    /** Tints the image in a certain color, analog to what can be done in Adobe Animate.
     *
     *  @param color   the RGB color with which the image should be tinted.
     *  @param amount  the intensity with which tinting should be applied. Range (0, 1).
     */
    public function tint(color:UInt, amount:Float=1.0):Void
    {
        var r:Float = Color.getRed(color)   / 255.0;
        var g:Float = Color.getGreen(color) / 255.0;
        var b:Float = Color.getBlue(color)  / 255.0;
        var q:Float = 1 - amount;

        var rA:Float = amount * r;
        var gA:Float = amount * g;
        var bA:Float = amount * b;

        concatValues(
            q + rA * LUMA_R, rA * LUMA_G, rA * LUMA_B, 0, 0,
            gA * LUMA_R, q + gA * LUMA_G, gA * LUMA_B, 0, 0,
            bA * LUMA_R, bA * LUMA_G, q + bA * LUMA_B, 0, 0,
            0, 0, 0, 1, 0);
    }

    // matrix manipulation

    /** Changes the filter matrix back to the identity matrix. */
    public function reset():Void
    {
        matrix = null;
    }

    /** Concatenates the current matrix with another one. */
    public function concat(matrix:Vector<Float>):Void
    {
        colorEffect.concat(matrix);
        setRequiresRedraw();
    }

    /** Concatenates the current matrix with another one, passing its contents directly. */
    public function concatValues(m0:Float, m1:Float, m2:Float, m3:Float, m4:Float,
                                 m5:Float, m6:Float, m7:Float, m8:Float, m9:Float,
                                 m10:Float, m11:Float, m12:Float, m13:Float, m14:Float,
                                 m15:Float, m16:Float, m17:Float, m18:Float, m19:Float):Void
    {
        sMatrix.length = 0;
        sMatrix[0] = m0; sMatrix[1] = m1; sMatrix[2] = m2; sMatrix[3] = m3;
        sMatrix[4] = m4; sMatrix[5] = m5; sMatrix[6] = m6; sMatrix[7] = m7;
        sMatrix[8] = m8; sMatrix[9] = m9; sMatrix[10] = m10; sMatrix[11] = m11;
        sMatrix[12] = m12; sMatrix[13] = m13; sMatrix[14] = m14; sMatrix[15] = m15;
        sMatrix[16] = m16; sMatrix[17] = m17; sMatrix[18] = m18; sMatrix[19] = m19;

        concat(sMatrix);
    }

    /** A vector of 20 items arranged as a 4x5 matrix. */
    public var matrix(get, set):Vector<Float>;
    private function get_matrix():Vector<Float> { return colorEffect.matrix; }
    private function set_matrix(value:Vector<Float>):Vector<Float>
    {
        colorEffect.matrix = value;
        setRequiresRedraw();
        return value;
    }

    public var colorEffect(get, never):ColorMatrixEffect;
    private function get_colorEffect():ColorMatrixEffect
    {
        return cast this.effect;
    }
}


class ColorMatrixEffect extends FilterEffect
{
    private var _userMatrix:Vector<Float>;   // offset in range 0-255
    private var _shaderMatrix:Vector<Float>; // offset in range 0-1, changed order

    private static var MIN_COLOR:Vector<Float> = new Vector<Float>([0, 0, 0, 0.0001]);
    private static var IDENTITY:Array<Float> = [1,0,0,0,0,  0,1,0,0,0,  0,0,1,0,0,  0,0,0,1,0];

    // helpers
    private static var sMatrix:Vector<Float> = new Vector<Float>(20, true);

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (ColorMatrixEffect.prototype, {
            "matrix": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }") },
        });
        
    }
    #end

    public function new():Void
    {
        super();

        _userMatrix   = new Vector<Float>();
        _shaderMatrix = new Vector<Float>();

        this.matrix = null;
    }

    override private function createProgram():Program
    {
        var vertexShader:String = FilterEffect.STD_VERTEX_SHADER;
        var fragmentShader:String = [
            FilterEffect.tex("ft0", "v0", 0, texture),      // read texture color
            "max ft0, ft0, fc5              ", // avoid division through zero in next step
            "div ft0.xyz, ft0.xyz, ft0.www  ", // restore original (non-PMA) RGB values
            "m44 ft0, ft0, fc0              ", // multiply color with 4x4 matrix
            "add ft0, ft0, fc4              ", // add offset
            "mul ft0.xyz, ft0.xyz, ft0.www  ", // multiply with alpha again (PMA)
            "mov oc, ft0                    "  // copy to output
        ].join("\n");

        return Program.fromSource(vertexShader, fragmentShader);
    }

    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);

        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _shaderMatrix);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, MIN_COLOR);
    }

    // matrix manipulation

    public function reset():Void
    {
        matrix = null;
    }

    /** Concatenates the current matrix with another one. */
    public function concat(matrix:Vector<Float>):Void
    {
        var i:Int = 0;

        for (y in 0...4)
        {
            for (x in 0...5)
            {
                sMatrix[i+x] = matrix[i    ] * _userMatrix[x     ] +
                               matrix[i + 1] * _userMatrix[x +  5] +
                               matrix[i + 2] * _userMatrix[x + 10] +
                               matrix[i + 3] * _userMatrix[x + 15] +
                               (x == 4 ? matrix[i + 4] : 0);
            }

            i += 5;
        }

        copyMatrix(sMatrix, _userMatrix);
        updateShaderMatrix();
    }

    private function copyMatrix(from:Vector<Float>, to:Vector<Float>):Void
    {
        for (i in 0...20)
            to[i] = from[i];
    }

    private function updateShaderMatrix():Void
    {
        // the shader needs the matrix components in a different order,
        // and it needs the offsets in the range 0-1.

        _shaderMatrix.length = 0;
        _shaderMatrix.push(_userMatrix[0 ]); _shaderMatrix.push(_userMatrix[ 1]); _shaderMatrix.push(_userMatrix[ 2]); _shaderMatrix.push(_userMatrix[ 3]);
        _shaderMatrix.push(_userMatrix[5 ]); _shaderMatrix.push(_userMatrix[ 6]); _shaderMatrix.push(_userMatrix[ 7]); _shaderMatrix.push(_userMatrix[ 8]);
        _shaderMatrix.push(_userMatrix[10]); _shaderMatrix.push(_userMatrix[11]); _shaderMatrix.push(_userMatrix[12]); _shaderMatrix.push(_userMatrix[13]);
        _shaderMatrix.push(_userMatrix[15]); _shaderMatrix.push(_userMatrix[16]); _shaderMatrix.push(_userMatrix[17]); _shaderMatrix.push(_userMatrix[18]);
        _shaderMatrix.push(_userMatrix[ 4] / 255.0); _shaderMatrix.push(_userMatrix[9] / 255.0); _shaderMatrix.push(_userMatrix[14] / 255.0);
        _shaderMatrix.push(_userMatrix[19] / 255.0);
    }

    // properties

    public var matrix(get, set):Vector<Float>;
    private function get_matrix():Vector<Float> { return _userMatrix; }
    private function set_matrix(value:Vector<Float>):Vector<Float>
    {
        if (value != null && value.length != 20)
            throw new ArgumentError("Invalid matrix length: must be 20");

        if (value == null)
        {
            _userMatrix.length = 0;
            for (val in IDENTITY)
            {
                _userMatrix.push(val);
            }
        }
        else
        {
            copyMatrix(value, _userMatrix);
        }

        updateShaderMatrix();
        return value;
    }
}
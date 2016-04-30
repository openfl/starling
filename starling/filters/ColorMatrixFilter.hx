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
import openfl.Vector;
import openfl.errors.ArgumentError;
import starling.rendering.FilterEffect;
import starling.utils.ArrayUtil;
import starling.utils.Color;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;

import starling.rendering.FilterEffect;
import starling.rendering.Program;
import starling.utils.RenderUtil;

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

    inline private static var LUMA_R:Float = 0.299;
    inline private static var LUMA_G:Float = 0.587;
    inline private static var LUMA_B:Float = 0.114;

    // helpers
    private static var sMatrix:Array<Float> = new Array();

    /** Creates a new ColorMatrixFilter instance with the specified matrix.
     *  @param matrix a vector of 20 items arranged as a 4x5 matrix.
     */
    public function new(matrix:Array<Float>=null)
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
        ArrayUtil.clear(sMatrix);
        
        sMatrix.push(m0);
        sMatrix.push(m1);
        sMatrix.push(m2);
        sMatrix.push(m3);
        sMatrix.push(m4);
        sMatrix.push(m5);
        sMatrix.push(m6);
        sMatrix.push(m7);
        sMatrix.push(m8);
        sMatrix.push(m9);
        
        sMatrix.push(m10);
        sMatrix.push(m11);
        sMatrix.push(m12);
        sMatrix.push(m13);
        sMatrix.push(m14);
        sMatrix.push(m15);
        sMatrix.push(m16);
        sMatrix.push(m17);
        sMatrix.push(m18);
        sMatrix.push(m19);

        concat(sMatrix);
    }

    /** A vector of 20 items arranged as a 4x5 matrix. */
    public var matrix(get, set):Vector<Float>;
    @:noCompletion private function get_matrix():Vector<Float> { return colorEffect.matrix; }
    @:noCompletion private function set_matrix(value:Vector<Float>):Vector<Float>
    {
        colorEffect.matrix = value;
        setRequiresRedraw();
        return value;
    }

    private var colorEffect(get, never):ColorMatrixEffect;
    @:noCompletion private function get_colorEffect():ColorMatrixEffect
    {
        return cast(this.effect, ColorMatrixEffect);
    }
}

class ColorMatrixEffect extends FilterEffect
{
    private var _userMatrix:Array<Float>;   // offset in range 0-255
    private var _shaderMatrix:Vector<Float>; // offset in range 0-1, changed order

    private static var MIN_COLOR:Vector<Float> = [0, 0, 0, 0.0001];
    private static var IDENTITY:Array<Float> = [1.0,0,0,0,0,  0,1,0,0,0,  0,0,1,0,0,  0,0,0,1,0];

    // helpers
    private static var sMatrix:Vector<Float> = new Vector<Float>(20);

    public function ColorMatrixEffect():Void
    {
        _userMatrix   = new Array<Float>();
        _shaderMatrix = new Array<Float>();

        this.matrix = null;
    }

    override private function createProgram():Program
    {
        var vertexShader:String = FilterEffect.STD_VERTEX_SHADER;
        var fragmentShader:String = [
            RenderUtil.createAGALTexOperation("ft0", "v0", 0, texture), // read texture color
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
    public function concat(matrix:Array<Float>):Void
    {
        var i:Int = 0;

        for (y in 0 ... 4)
        {
            for (x in 0 ... 5)
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

    private function copyMatrix(from:Array<Float>, to:Array<Float>):Void
    {
        for (i in 0 ... 20)
            to[i] = from[i];
    }

    private function updateShaderMatrix():Void
    {
        // the shader needs the matrix components in a different order,
        // and it needs the offsets in the range 0-1.

        ArrayUtil.clear(_shaderMatrix);
        
        _shaderMatrix.push(_userMatrix[ 0]);
        _shaderMatrix.push(_userMatrix[ 1]);
        _shaderMatrix.push(_userMatrix[ 2]);
        _shaderMatrix.push(_userMatrix[ 3]);
        
        _shaderMatrix.push(_userMatrix[ 5]);
        _shaderMatrix.push(_userMatrix[ 6]);
        _shaderMatrix.push(_userMatrix[ 7]);
        _shaderMatrix.push(_userMatrix[ 8]);
        
        _shaderMatrix.push(_userMatrix[10]);
        _shaderMatrix.push(_userMatrix[11]);
        _shaderMatrix.push(_userMatrix[12]);
        _shaderMatrix.push(_userMatrix[13]);
        
        _shaderMatrix.push(_userMatrix[15]);
        _shaderMatrix.push(_userMatrix[16]);
        _shaderMatrix.push(_userMatrix[17]);
        _shaderMatrix.push(_userMatrix[18]);
        
        _shaderMatrix.push(_userMatrix[ 4] / 255.0);
        _shaderMatrix.push(_userMatrix[ 9] / 255.0);
        _shaderMatrix.push(_userMatrix[14] / 255.0);
        _shaderMatrix.push(_userMatrix[19] / 255.0);
        
        #if 0
        _shaderMatrix.push(
            _userMatrix[0 ], _userMatrix[ 1], _userMatrix[ 2], _userMatrix[ 3],
            _userMatrix[5 ], _userMatrix[ 6], _userMatrix[ 7], _userMatrix[ 8],
            _userMatrix[10], _userMatrix[11], _userMatrix[12], _userMatrix[13],
            _userMatrix[15], _userMatrix[16], _userMatrix[17], _userMatrix[18],
            _userMatrix[ 4] / 255.0, _userMatrix[9] / 255.0,  _userMatrix[14] / 255.0,
            _userMatrix[19] / 255.0
        );
        #end
    }

    // properties

    public var matrix(get, set):Array<Float>;
    @:noCompletion private function get_matrix():Array<Float> { return _userMatrix; }
    @:noCompletion private function set_matrix(value:Array<Float>):Array<Float>
    {
        if (value != null && value.length != 20)
            throw new ArgumentError("Invalid matrix length: must be 20");

        if (value == null)
        {
            ArrayUtil.clear(_userMatrix);
            for (i in 0 ... 20)
                _userMatrix[i] = IDENTITY[i];
        }
        else
        {
            copyMatrix(value, _userMatrix);
        }

        updateShaderMatrix();
        return value;
    }
}
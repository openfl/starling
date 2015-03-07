// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

// Most of the color transformation math was taken from the excellent ColorMatrix class by
// Mario Klingemann: http://www.quasimondo.com/archives/000565.php -- THANKS!!!

package starling.filters
{
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;

import starling.core.Starling;
import starling.textures.Texture;
import starling.utils.Color;

/** The ColorMatrixFilter class lets you apply a 4x5 matrix transformation on the RGBA color 
 *  and alpha values of every pixel in the input image to produce a result with a new set 
 *  of RGBA color and alpha values. It allows saturation changes, hue rotation, 
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
public class ColorMatrixFilter extends FragmentFilter
{
    private var mShaderProgram:Program3D;
    private var mUserMatrix:Vector.<Float>;   // offset in range 0-255
    private var mShaderMatrix:Vector.<Float>; // offset in range 0-1, changed order
    
    private static const PROGRAM_NAME:String = "CMF";
    private static const MIN_COLOR:Vector.<Float> = new <Float>[0, 0, 0, 0.0001];
    private static const IDENTITY:Array = [1,0,0,0,0,  0,1,0,0,0,  0,0,1,0,0,  0,0,0,1,0];
    private static const LUMA_R:Float = 0.299;
    private static const LUMA_G:Float = 0.587;
    private static const LUMA_B:Float = 0.114;
    
    /** helper objects */
    private static var sTmpMatrix1:Vector.<Float> = new Vector.<Float>(20, true);
    private static var sTmpMatrix2:Vector.<Float> = new <Float>[];
    
    /** Creates a new ColorMatrixFilter instance with the specified matrix. 
     *  @param matrix a vector of 20 items arranged as a 4x5 matrix.
     */
    public function ColorMatrixFilter(matrix:Vector.<Float>=null)
    {
        mUserMatrix   = new <Float>[];
        mShaderMatrix = new <Float>[];
        
        this.matrix = matrix;
    }
    
    /** @private */
    protected override function createPrograms():Void
    {
        var target:Starling = Starling.current;
        
        if (target.hasProgram(PROGRAM_NAME))
        {
            mShaderProgram = target.getProgram(PROGRAM_NAME);
        }
        else
        {
            // fc0-3: matrix
            // fc4:   offset
            // fc5:   minimal allowed color value
            
            var fragmentShader:String =
                "tex ft0, v0,  fs0 <2d, clamp, linear, mipnone>  \n" + // read texture color
                "max ft0, ft0, fc5              \n" + // avoid division through zero in next step
                "div ft0.xyz, ft0.xyz, ft0.www  \n" + // restore original (non-PMA) RGB values
                "m44 ft0, ft0, fc0              \n" + // multiply color with 4x4 matrix
                "add ft0, ft0, fc4              \n" + // add offset
                "mul ft0.xyz, ft0.xyz, ft0.www  \n" + // multiply with alpha again (PMA)
                "mov oc, ft0                    \n";  // copy to output
            
            mShaderProgram = target.registerProgramFromSource(PROGRAM_NAME,
                STD_VERTEX_SHADER, fragmentShader);
        }
    }
    
    /** @private */
    protected override function activate(pass:Int, context:Context3D, texture:Texture):Void
    {
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mShaderMatrix);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, MIN_COLOR);
        context.setProgram(mShaderProgram);
    }
    
    // color manipulation
    
    /** Inverts the colors of the filtered objects. */
    public function invert():ColorMatrixFilter
    {
        return concatValues(-1,  0,  0,  0, 255,
                             0, -1,  0,  0, 255,
                             0,  0, -1,  0, 255,
                             0,  0,  0,  1,   0);
    }
    
    /** Changes the saturation. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the saturation.
     *  '-1' will produce a grayscale image. */ 
    public function adjustSaturation(sat:Float):ColorMatrixFilter
    {
        sat += 1;
        
        var invSat:Float  = 1 - sat;
        var invLumR:Float = invSat * LUMA_R;
        var invLumG:Float = invSat * LUMA_G;
        var invLumB:Float = invSat * LUMA_B;
        
        return concatValues((invLumR + sat), invLumG, invLumB, 0, 0,
                             invLumR, (invLumG + sat), invLumB, 0, 0,
                             invLumR, invLumG, (invLumB + sat), 0, 0,
                             0, 0, 0, 1, 0);
    }
    
    /** Changes the contrast. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the contrast. */
    public function adjustContrast(value:Float):ColorMatrixFilter
    {
        var s:Float = value + 1;
        var o:Float = 128 * (1 - s);
        
        return concatValues(s, 0, 0, 0, o,
                            0, s, 0, 0, o,
                            0, 0, s, 0, o,
                            0, 0, 0, 1, 0);
    }
    
    /** Changes the brightness. Typical values are in the range (-1, 1).
     *  Values above zero will make the image brighter, values below zero will make it darker.*/ 
    public function adjustBrightness(value:Float):ColorMatrixFilter
    {
        value *= 255;
        
        return concatValues(1, 0, 0, 0, value,
                            0, 1, 0, 0, value,
                            0, 0, 1, 0, value,
                            0, 0, 0, 1, 0);
    }
    
    /** Changes the hue of the image. Typical values are in the range (-1, 1). */
    public function adjustHue(value:Float):ColorMatrixFilter
    {
        value *= Math.PI;
        
        var cos:Float = Math.cos(value);
        var sin:Float = Math.sin(value);
        
        return concatValues(
            ((LUMA_R + (cos * (1 - LUMA_R))) + (sin * -(LUMA_R))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * -(LUMA_G))), ((LUMA_B + (cos * -(LUMA_B))) + (sin * (1 - LUMA_B))), 0, 0,
            ((LUMA_R + (cos * -(LUMA_R))) + (sin * 0.143)), ((LUMA_G + (cos * (1 - LUMA_G))) + (sin * 0.14)), ((LUMA_B + (cos * -(LUMA_B))) + (sin * -0.283)), 0, 0,
            ((LUMA_R + (cos * -(LUMA_R))) + (sin * -((1 - LUMA_R)))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * LUMA_G)), ((LUMA_B + (cos * (1 - LUMA_B))) + (sin * LUMA_B)), 0, 0,
            0, 0, 0, 1, 0);
    }
    
    /** Tints the image in a certain color, analog to what can be done in Flash Pro.
     *  @param color the RGB color with which the image should be tinted.
     *  @param amount the intensity with which tinting should be applied. Range (0, 1). */
    public function tint(color:UInt, amount:Float=1.0):ColorMatrixFilter
    {
        var r:Float = Color.getRed(color)   / 255.0;
        var g:Float = Color.getGreen(color) / 255.0;
        var b:Float = Color.getBlue(color)  / 255.0;
        var q:Float = 1 - amount;

        var rA:Float = amount * r;
        var gA:Float = amount * g;
        var bA:Float = amount * b;

        return concatValues(
            q + rA * LUMA_R, rA * LUMA_G, rA * LUMA_B, 0, 0,
            gA * LUMA_R, q + gA * LUMA_G, gA * LUMA_B, 0, 0,
            bA * LUMA_R, bA * LUMA_G, q + bA * LUMA_B, 0, 0,
            0, 0, 0, 1, 0);
    }

    // matrix manipulation
    
    /** Changes the filter matrix back to the identity matrix. */
    public function reset():ColorMatrixFilter
    {
        matrix = null;
        return this;
    }
    
    /** Concatenates the current matrix with another one. */
    public function concat(matrix:Vector.<Float>):ColorMatrixFilter
    {
        var i:Int = 0;

        for (var y:Int=0; y<4; ++y)
        {
            for (var x:Int=0; x<5; ++x)
            {
                sTmpMatrix1[Int(i+x)] = 
                    matrix[i]        * mUserMatrix[x]           +
                    matrix[Int(i+1)] * mUserMatrix[Int(x +  5)] +
                    matrix[Int(i+2)] * mUserMatrix[Int(x + 10)] +
                    matrix[Int(i+3)] * mUserMatrix[Int(x + 15)] +
                    (x == 4 ? matrix[Int(i+4)] : 0);
            }
            
            i+=5;
        }
        
        copyMatrix(sTmpMatrix1, mUserMatrix);
        updateShaderMatrix();
        return this;
    }
    
    /** Concatenates the current matrix with another one, passing its contents directly. */
    private function concatValues(m0:Float, m1:Float, m2:Float, m3:Float, m4:Float, 
                                  m5:Float, m6:Float, m7:Float, m8:Float, m9:Float, 
                                  m10:Float, m11:Float, m12:Float, m13:Float, m14:Float, 
                                  m15:Float, m16:Float, m17:Float, m18:Float, m19:Float
                                  ):ColorMatrixFilter
    {
        sTmpMatrix2.length = 0;
        sTmpMatrix2.push(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, 
            m10, m11, m12, m13, m14, m15, m16, m17, m18, m19);
        
        concat(sTmpMatrix2);
        return this;
    }

    private function copyMatrix(from:Vector.<Float>, to:Vector.<Float>):Void
    {
        for (var i:Int=0; i<20; ++i)
            to[i] = from[i];
    }
    
    private function updateShaderMatrix():Void
    {
        // the shader needs the matrix components in a different order, 
        // and it needs the offsets in the range 0-1.
        
        mShaderMatrix.length = 0;
        mShaderMatrix.push(
            mUserMatrix[0],  mUserMatrix[1],  mUserMatrix[2],  mUserMatrix[3],
            mUserMatrix[5],  mUserMatrix[6],  mUserMatrix[7],  mUserMatrix[8],
            mUserMatrix[10], mUserMatrix[11], mUserMatrix[12], mUserMatrix[13], 
            mUserMatrix[15], mUserMatrix[16], mUserMatrix[17], mUserMatrix[18],
            mUserMatrix[4] / 255.0,  mUserMatrix[9] / 255.0,  mUserMatrix[14] / 255.0,  
            mUserMatrix[19] / 255.0
        );
    }
    
    // properties
    
    /** A vector of 20 items arranged as a 4x5 matrix. */
    public function get matrix():Vector.<Float> { return mUserMatrix; }
    public function set matrix(value:Vector.<Float>):Void
    {
        if (value && value.length != 20) 
            throw new ArgumentError("Invalid matrix length: must be 20");
        
        if (value == null)
        {
            mUserMatrix.length = 0;
            mUserMatrix.push.apply(mUserMatrix, IDENTITY);
        }
        else
        {
            copyMatrix(value, mUserMatrix);
        }
        
        updateShaderMatrix();
    }
}
}
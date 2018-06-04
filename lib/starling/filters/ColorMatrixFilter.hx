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

@:jsRequire("starling/filters/ColorMatrixFilter", "default")

extern class ColorMatrixFilter extends FragmentFilter
{
    /** Creates a new ColorMatrixFilter instance with the specified matrix.
     *  @param matrix a vector of 20 items arranged as a 4x5 matrix.
     */
    public function new(matrix:Vector<Float>=null);

    // color manipulation

    /** Inverts the colors of the filtered object. */
    public function invert():Void;

    /** Changes the saturation. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the saturation.
     *  '-1' will produce a grayscale image. */
    public function adjustSaturation(sat:Float):Void;

    /** Changes the contrast. Typical values are in the range (-1, 1).
     *  Values above zero will raise, values below zero will reduce the contrast. */
    public function adjustContrast(value:Float):Void;

    /** Changes the brightness. Typical values are in the range (-1, 1).
     *  Values above zero will make the image brighter, values below zero will make it darker.*/
    public function adjustBrightness(value:Float):Void;

    /** Changes the hue of the image. Typical values are in the range (-1, 1). */
    public function adjustHue(value:Float):Void;

    /** Tints the image in a certain color, analog to what can be done in Adobe Animate.
     *
     *  @param color   the RGB color with which the image should be tinted.
     *  @param amount  the intensity with which tinting should be applied. Range (0, 1).
     */
    public function tint(color:UInt, amount:Float=1.0):Void;

    // matrix manipulation

    /** Changes the filter matrix back to the identity matrix. */
    public function reset():Void;

    /** Concatenates the current matrix with another one. */
    public function concat(matrix:Vector<Float>):Void;

    /** Concatenates the current matrix with another one, passing its contents directly. */
    public function concatValues(m0:Float, m1:Float, m2:Float, m3:Float, m4:Float,
                                 m5:Float, m6:Float, m7:Float, m8:Float, m9:Float,
                                 m10:Float, m11:Float, m12:Float, m13:Float, m14:Float,
                                 m15:Float, m16:Float, m17:Float, m18:Float, m19:Float):Void;

    /** A vector of 20 items arranged as a 4x5 matrix. */
    public var matrix(get, set):Vector<Float>;
    private function get_matrix():Vector<Float>;
    private function set_matrix(value:Vector<Float>):Vector<Float>;

    public var colorEffect(get, never):ColorMatrixEffect;
    private function get_colorEffect():ColorMatrixEffect;
}


extern class ColorMatrixEffect extends FilterEffect
{
    public function new():Void;

    // matrix manipulation

    public function reset():Void;

    /** Concatenates the current matrix with another one. */
    public function concat(matrix:Vector<Float>):Void;

    // properties

    public var matrix(get, set):Vector<Float>;
    private function get_matrix():Vector<Float>;
    private function set_matrix(value:Vector<Float>):Vector<Float>;
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.display3D.Context3DBlendFactor;
import openfl.errors.ArgumentError;

import starling.core.Starling;

/** A class that provides constant values for visual blend mode effects. 
 *   
 *  <p>A blend mode is always defined by two 'Context3DBlendFactor' values. A blend factor 
 *  represents a particular four-value vector that is multiplied with the source or destination
 *  color in the blending formula. The blending formula is:</p>
 * 
 *  <pre>result = source � sourceFactor + destination � destinationFactor</pre>
 * 
 *  <p>In the formula, the source color is the output color of the pixel shader program. The 
 *  destination color is the color that currently exists in the color buffer, as set by 
 *  previous clear and draw operations.</p>
 *  
 *  <p>Beware that blending factors produce different output depending on the texture type.
 *  Textures may contain 'premultiplied alpha' (pma), which means that their RGB values were 
 *  multiplied with their alpha value (to save processing time). Textures based on 'BitmapData'
 *  objects have premultiplied alpha values, while ATF textures haven't. For this reason, 
 *  a blending mode may have different factors depending on the pma value.</p>
 *  
 *  @see openfl.display3D.Context3DBlendFactor
 */

@:jsRequire("starling/display/BlendMode", "default")

extern class BlendMode
{
    /** Creates a new BlendMode instance. Don't call this method directly; instead,
     *  register a new blend mode using <code>BlendMode.register</code>. */
    public function new(name:String, sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor);
    
    /** Inherits the blend mode from this display object's parent. */
    public static var AUTO:String;

    /** Deactivates blending, i.e. disabling any transparency. */
    public static var NONE:String;
    
    /** The display object appears in front of the background. */
    public static var NORMAL:String;
    
    /** Adds the values of the colors of the display object to the colors of its background. */
    public static var ADD:String;
    
    /** Multiplies the values of the display object colors with the the background color. */
    public static var MULTIPLY:String;
    
    /** Multiplies the complement (inverse) of the display object color with the complement of 
      * the background color, resulting in a bleaching effect. */
    public static var SCREEN:String;
    
    /** Erases the background when drawn on a RenderTexture. */
    public static var ERASE:String;

    /** When used on a RenderTexture, the drawn object will act as a mask for the current
     * content, i.e. the source alpha overwrites the destination alpha. */
    public static var MASK:String;

    /** Draws under/below existing objects; useful especially on RenderTextures. */
    public static var BELOW:String;

    // static access methods
    
    /** Returns the blend mode with the given name.
     *  Throws an ArgumentError if the mode does not exist. */
    public static function get(modeName:String):BlendMode;

    /** Returns allready registered blend mode by
    * given blend mode factors. Returns null if not exist.*/
    public static function getByFactors(srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):Null<BlendMode>;
    
    /** Registers a blending mode under a certain name. */
    public static function register(name:String, srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):BlendMode;
    
    // instance methods / properties

    /** Sets the appropriate blend factors for source and destination on the current context. */
    public function activate():Void;

    /** Returns the name of the blend mode. */
    public function toString():String;

    /** The source blend factor of this blend mode. */
    public var sourceFactor(get, never):String;
    private function get_sourceFactor():String;

    /** The destination blend factor of this blend mode. */
    public var destinationFactor(get, never):String;
    private function get_destinationFactor():String;

    /** Returns the name of the blend mode. */
    public var name(get, never):String;
    private function get_name():String;
}
// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;
import openfl.display3D.Context3DBlendFactor;
import openfl.errors.ArgumentError;

import starling.errors.AbstractClassError;

/** A class that provides constant values for visual blend mode effects. 
 *   
 *  <p>A blend mode is always defined by two 'Context3DBlendFactor' values. A blend factor 
 *  represents a particular four-value vector that is multiplied with the source or destination
 *  color in the blending formula. The blending formula is:</p>
 * 
 *  <pre>result = source × sourceFactor + destination × destinationFactor</pre>
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
 *  @see flash.display3D.Context3DBlendFactor
 */
class BlendMode
{
    private static var sBlendFactors:Array<Map<String, Array<Context3DBlendFactor>>> = [ 
        // no premultiplied alpha
        [ 
            "none"     => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
            "normal"   => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "add"      => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ],
            "multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "screen"   => [ Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE ],
            "erase"    => [ Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "below"    => [ Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ]
        ],
        // premultiplied alpha
        [ 
            "none"     => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ],
            "normal"   => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "add"      => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE ],
            "multiply" => [ Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "screen"   => [ Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR ],
            "erase"    => [ Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ],
            "below"    => [ Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA ]
        ]
    ];
    
    // predifined modes
    
    /** @private */
    public function BlendMode() { throw new AbstractClassError(); }
    
    /** Inherits the blend mode from this display object's parent. */
    inline public static var AUTO:String = "auto";

    /** Deactivates blending, i.e. disabling any transparency. */
    inline public static var NONE:String = "none";
    
    /** The display object appears in front of the background. */
    inline public static var NORMAL:String = "normal";
    
    /** Adds the values of the colors of the display object to the colors of its background. */
    inline public static var ADD:String = "add";
    
    /** Multiplies the values of the display object colors with the the background color. */
    inline public static var MULTIPLY:String = "multiply";
    
    /** Multiplies the complement (inverse) of the display object color with the complement of 
      * the background color, resulting in a bleaching effect. */
    inline public static var SCREEN:String = "screen";
    
    /** Erases the background when drawn on a RenderTexture. */
    inline public static var ERASE:String = "erase";
    
    /** Draws under/below existing objects; useful especially on RenderTextures. */
    inline public static var BELOW:String = "below";
    
    // accessing modes
    
    /** Returns the blend factors that correspond with a certain mode and premultiplied alpha
     *  value. Throws an ArgumentError if the mode does not exist. */
    public static function getBlendFactors(mode:String, premultipliedAlpha:Bool=true):Array<Context3DBlendFactor>
    {
        var modes:Map<String, Array<Context3DBlendFactor>> = sBlendFactors[premultipliedAlpha ? 1 : 0];
        var ret = modes[mode];
        if (ret != null)
            return ret;
        else throw new ArgumentError("Invalid blend mode");
    }
    
    /** Registeres a blending mode under a certain name and for a certain premultiplied alpha
     *  (pma) value. If the mode for the other pma value was not yet registered, the factors are
     *  used for both pma settings. */
    public static function register(name:String, sourceFactor:Context3DBlendFactor, destFactor:Context3DBlendFactor,
                                    premultipliedAlpha:Bool=true):Void
    {
        var modes:Map<String, Array<Context3DBlendFactor>> = sBlendFactors[premultipliedAlpha ? 1 : 0];
        modes[name] = [sourceFactor, destFactor];
        
        var otherModes:Map<String, Array<Context3DBlendFactor>> = sBlendFactors[!premultipliedAlpha ? 1 : 0];
        if (!(otherModes.exists(name))) otherModes[name] = [sourceFactor, destFactor];
    }
}

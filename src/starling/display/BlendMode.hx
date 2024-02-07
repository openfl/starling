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
class BlendMode
{
    @:noCompletion private var __name:String;
    @:noCompletion private var __sourceFactor:Context3DBlendFactor;
    @:noCompletion private var __destinationFactor:Context3DBlendFactor;
    
    private static var sBlendModes:Map<String, BlendMode>;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (BlendMode.prototype, {
            "sourceFactor": { get: untyped __js__ ("function () { return this.get_sourceFactor (); }") },
            "destinationFactor": { get: untyped __js__ ("function () { return this.get_destinationFactor (); }") },
            "name": { get: untyped __js__ ("function () { return this.get_name (); }") },
        });
        
    }
    #end
    
    /** Creates a new BlendMode instance. Don't call this method directly; instead,
     *  register a new blend mode using <code>BlendMode.register</code>. */
    public function new(name:String, sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor)
    {
        __name = name;
        __sourceFactor = sourceFactor;
        __destinationFactor = destinationFactor;
    }
    
    /** Inherits the blend mode from this display object's parent. */
    public static inline var AUTO:String = "auto";

    /** Deactivates blending, i.e. disabling any transparency. */
    public static inline var NONE:String = "none";
    
    /** The display object appears in front of the background. */
    public static inline var NORMAL:String = "normal";
    
    /** Adds the values of the colors of the display object to the colors of its background. */
    public static inline var ADD:String = "add";
    
    /** Multiplies the values of the display object colors with the the background color. */
    public static inline var MULTIPLY:String = "multiply";
    
    /** Multiplies the complement (inverse) of the display object color with the complement of 
      * the background color, resulting in a bleaching effect. */
    public static inline var SCREEN:String = "screen";
    
    /** Erases the background when drawn on a RenderTexture. */
    public static inline var ERASE:String = "erase";

    /** When used on a RenderTexture, the drawn object will act as a mask for the current
     * content, i.e. the source alpha overwrites the destination alpha. */
    public static inline var MASK:String = "mask";

    /** Draws under/below existing objects; useful especially on RenderTextures. */
    public static inline var BELOW:String = "below";

    // static access methods
    
    /** Returns the blend mode with the given name.
     *  Throws an ArgumentError if the mode does not exist. */
    public static function get(modeName:String):BlendMode
    {
        if (sBlendModes == null) registerDefaults();
        if (sBlendModes.exists(modeName)) return sBlendModes[modeName];
        else throw new ArgumentError("Blend mode not found: " + modeName);
    }

    /** Returns allready registered blend mode by
    * given blend mode factors. Returns null if not exist.*/
    public static function getByFactors(srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):Null<BlendMode>
    {
        if (sBlendModes == null) registerDefaults();

        for (registeredBlendMode in sBlendModes)
        {
            if (registeredBlendMode.sourceFactor == srcFactor && registeredBlendMode.destinationFactor == dstFactor)
                return registeredBlendMode;
        }
        
        return null;
    }
    
    /** Registers a blending mode under a certain name. */
    public static function register(name:String, srcFactor:Context3DBlendFactor, dstFactor:Context3DBlendFactor):BlendMode
    {
        if (sBlendModes == null) registerDefaults();
        var blendMode:BlendMode = new BlendMode(name, srcFactor, dstFactor);
        sBlendModes[name] = blendMode;
        return blendMode;
    }
    
    private static function registerDefaults():Void
    {
        if (sBlendModes != null) return;

        sBlendModes = new Map();
        register("none" , Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        register("normal", Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        register("add", Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
        register("multiply", Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        register("screen", Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
        register("erase", Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        register("mask", Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA);
        register("below", Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA);
    }
	
	/** Returns an array with all currently registered blend modes. */
	public static function getAll(out:Array<BlendMode>=null):Array<BlendMode>
	{
		if (out == null) out = [];
		if (sBlendModes == null) registerDefaults();
		for (blendMode in sBlendModes)
		{
			out.insert(0, blendMode);
		}
		return out;
	}

	/** Returns true if a blend mode with the given name is available. */
	public static function isRegistered(modeName:String):Bool
	{
		if (sBlendModes == null) registerDefaults();
		return sBlendModes.exists(modeName);
	}

    // instance methods / properties

    /** Sets the appropriate blend factors for source and destination on the current context. */
    public function activate():Void
    {
        Starling.current.context.setBlendFactors(__sourceFactor, __destinationFactor);
    }

    /** Returns the name of the blend mode. */
    public function toString():String { return __name; }

    /** The source blend factor of this blend mode. */
    public var sourceFactor(get, never):String;
    private function get_sourceFactor():String { return __sourceFactor; }

    /** The destination blend factor of this blend mode. */
    public var destinationFactor(get, never):String;
    private function get_destinationFactor():String { return __destinationFactor; }

    /** Returns the name of the blend mode. */
    public var name(get, never):String;
    private function get_name():String { return __name; }
}
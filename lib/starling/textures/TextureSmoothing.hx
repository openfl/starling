// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

/** A class that provides constant values for the possible smoothing algorithms of a texture. */ 

@:jsRequire("starling/textures/TextureSmoothing", "default")

extern class TextureSmoothing
{
    /** No smoothing, also called "Nearest Neighbor". Pixels will scale up as big rectangles. */
    public static var NONE:String;
    
    /** Bilinear filtering. Creates smooth transitions between pixels. */
    public static var BILINEAR:String;
    
    /** Trilinear filtering. Highest quality by taking the next mip map level into account. */
    public static var TRILINEAR:String;
    
    /** Determines whether a smoothing value is valid. */
    public static function isValid(smoothing:String):Bool
    {
        return smoothing == NONE || smoothing == BILINEAR || smoothing == TRILINEAR;
    }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright 2013 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;
import openfl.display3D.Context3DTextureFormat;
import starling.core.Starling;

/** The TextureOptions class specifies options for loading textures with the 'Texture.fromData'
 *  method. */ 
class TextureOptions
{
    private var mScale:Float;
    private var mFormat:String;
    private var mMipMapping:Bool;
    private var mOptimizeForRenderToTexture:Bool = false;
    private var mOnReady:Void->Void = null;
    private var mRepeat:Bool = false;
    
    public function new(scale:Float=1.0, mipMapping:Bool=false, 
                                   format:String="bgra", repeat:Bool=false)
    {
        mScale = scale;
        mFormat = format;
        mMipMapping = mipMapping;
        mRepeat = repeat;
    }
    
    /** Creates a clone of the TextureOptions object with the exact same properties. */
    public function clone():TextureOptions
    {
        var clone:TextureOptions = new TextureOptions(mScale, mMipMapping, mFormat, mRepeat);
        clone.mOptimizeForRenderToTexture = mOptimizeForRenderToTexture;
        clone.mOnReady = mOnReady;
        return clone;
    }

    /** The scale factor, which influences width and height properties. If you pass '-1',
     *  the current global content scale factor will be used. */
    public var scale(get, set):Float;
    public function get_scale():Float { return mScale; }
    public function set_scale(value:Float):Float
    {
        mScale = value > 0 ? value : Starling.current.contentScaleFactor;
        return mScale;
    }
    
    /** The <code>Context3DTextureFormat</code> of the underlying texture data. */
    public var format(get, set):String;
    public function get_format():String { return mFormat; }
    public function set_format(value:String):String { return mFormat = value; }
    
    /** Indicates if the texture contains mip maps. */ 
    public var mipMapping(get, set):Bool;
    public function get_mipMapping():Bool { return mMipMapping; }
    public function set_mipMapping(value:Bool):Bool { return mMipMapping = value; }
    
    /** Indicates if the texture will be used as render target. */
    public var optimizeForRenderToTexture(get, set):Bool;
    public function get_optimizeForRenderToTexture():Bool { return mOptimizeForRenderToTexture; }
    public function set_optimizeForRenderToTexture(value:Bool):Bool { return mOptimizeForRenderToTexture = value; }
 
    /** Indicates if the texture should repeat like a wallpaper or stretch the outermost pixels.
     *  Note: this only works in textures with sidelengths that are powers of two and 
     *  that are not loaded from a texture atlas (i.e. no subtextures). @default false */
    public var repeat(get, set):Bool;
    public function get_repeat():Bool { return mRepeat; }
    public function set_repeat(value:Bool):Bool { return mRepeat = value; }

    /** A callback that is used only for ATF textures; if it is set, the ATF data will be
     *  decoded asynchronously. The texture can only be used when the callback has been
     *  executed. This property is ignored for all other texture types (they are ready
     *  immediately when the 'Texture.from...' method returns, anyway).
     *  
     *  <p>This is the expected function definition: 
     *  <code>function(texture:Texture):Void;</code></p> 
     */
    public var onReady(get, set):Void->Void;
    public function get_onReady():Void->Void { return mOnReady; }
    public function set_onReady(value:Void->Void):Void->Void { return mOnReady = value; }
}
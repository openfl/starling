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
import openfl.display3D.Context3DTextureFormat;
import starling.core.Starling;

/** The TextureOptions class specifies options for loading textures with the 'Texture.fromData'
 *  method. */ 
class TextureOptions
{
    private var mScale:Float;
    private var mFormat:Context3DTextureFormat;
    private var mMipMapping:Bool;
    private var mOptimizeForRenderToTexture:Bool = false;
    private var mOnReady:Void->Void = null;
    private var mRepeat:Bool = false;
    
    public function new(scale:Float=1.0, mipMapping:Bool=false, 
                                   format:Context3DTextureFormat=null, repeat:Bool=false)
    {
        if (format == null) format = Context3DTextureFormat.BGRA;
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
    private function get_scale():Float { return mScale; }
    private function set_scale(value:Float):Float
    {
        mScale = value > 0 ? value : Starling.current.contentScaleFactor;
        return mScale;
    }
    
    /** The <code>Context3DTextureFormat</code> of the underlying texture data. Only used
     *  for textures that are created from Bitmaps; the format of ATF files is set when they
     *  are created. */
    public var format(get, set):Context3DTextureFormat;
    private function get_format():Context3DTextureFormat { return mFormat; }
    private function set_format(value:Context3DTextureFormat):Context3DTextureFormat { return mFormat = value; }
    
    /** Indicates if the texture contains mip maps. */ 
    public var mipMapping(get, set):Bool;
    private function get_mipMapping():Bool { return mMipMapping; }
    private function set_mipMapping(value:Bool):Bool { return mMipMapping = value; }
    
    /** Indicates if the texture will be used as render target. */
    public var optimizeForRenderToTexture(get, set):Bool;
    private function get_optimizeForRenderToTexture():Bool { return mOptimizeForRenderToTexture; }
    private function set_optimizeForRenderToTexture(value:Bool):Bool { return mOptimizeForRenderToTexture = value; }
 
    /** Indicates if the texture should repeat like a wallpaper or stretch the outermost pixels.
     *  Note: this only works in textures with sidelengths that are powers of two and 
     *  that are not loaded from a texture atlas (i.e. no subtextures). @default false */
    public var repeat(get, set):Bool;
    private function get_repeat():Bool { return mRepeat; }
    private function set_repeat(value:Bool):Bool { return mRepeat = value; }

    /** A callback that is used only for ATF textures; if it is set, the ATF data will be
     *  decoded asynchronously. The texture can only be used when the callback has been
     *  executed. This property is ignored for all other texture types (they are ready
     *  immediately when the 'Texture.from...' method returns, anyway).
     *  
     *  <p>This is the expected function definition: 
     *  <code>function(texture:Texture):void;</code></p> 
     */
    public var onReady(get, set):Void->Void;
    private function get_onReady():Void->Void { return mOnReady; }
    private function set_onReady(value:Void->Void):Void->Void { return mOnReady = value; }
}
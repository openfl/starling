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

/** The TextureOptions class specifies options for loading textures with the
 *  <code>Texture.fromData</code> and <code>Texture.fromTextureBase</code> methods. */
class TextureOptions
{
    private var _scale:Float;
    private var _format:Context3DTextureFormat;
    private var _mipMapping:Bool;
    private var _optimizeForRenderToTexture:Bool = false;
    private var _premultipliedAlpha:Bool;
    private var _onReady:Dynamic = null;

    /** Creates a new instance with the given options. */
    public function new(scale:Float=1.0, mipMapping:Bool=false, 
                                   format:Context3DTextureFormat=null, premultipliedAlpha:Bool=true)
    {
        if (format == null) format = Context3DTextureFormat.BGRA;
        
        _scale = scale;
        _format = format;
        _mipMapping = mipMapping;
        _premultipliedAlpha = premultipliedAlpha;
    }
    
    /** Creates a clone of the TextureOptions object with the exact same properties. */
    public function clone():TextureOptions
    {
        var clone:TextureOptions = new TextureOptions(_scale, _mipMapping, _format);
        clone._optimizeForRenderToTexture = _optimizeForRenderToTexture;
        clone._onReady = _onReady;
        return clone;
    }

    /** The scale factor, which influences width and height properties. If you pass '-1',
     *  the current global content scale factor will be used. @default 1.0 */
    public var scale(get, set):Float;
    private function get_scale():Float { return _scale; }
    private function set_scale(value:Float):Float
    {
        return _scale = value > 0 ? value : Starling.current.contentScaleFactor;
    }
    
    /** The <code>Context3DTextureFormat</code> of the underlying texture data. Only used
     *  for textures that are created from Bitmaps; the format of ATF files is set when they
     *  are created. @default BGRA */
    public var format(get, set):Context3DTextureFormat;
    private function get_format():Context3DTextureFormat { return _format; }
    private function set_format(value:Context3DTextureFormat):Context3DTextureFormat { return _format = value; }
    
    /** Indicates if the texture contains mip maps. @default false */
    public var mipMapping(get, set):Bool;
    private function get_mipMapping():Bool { return _mipMapping; }
    private function set_mipMapping(value:Bool):Bool { return _mipMapping = value; }
    
    /** Indicates if the texture will be used as render target. */
    public var optimizeForRenderToTexture(get, set):Bool;
    private function get_optimizeForRenderToTexture():Bool { return _optimizeForRenderToTexture; }
    private function set_optimizeForRenderToTexture(value:Bool):Bool { return _optimizeForRenderToTexture = value; }
 
    /** A callback that is used only for ATF textures; if it is set, the ATF data will be
     *  decoded asynchronously. The texture can only be used when the callback has been
     *  executed. This property is ignored for all other texture types (they are ready
     *  immediately when the 'Texture.from...' method returns, anyway), and it's only used
     *  by the <code>Texture.fromData</code> factory method.
     *  
     *  <p>This is the expected function definition: 
     *  <code>function(texture:Texture):void;</code></p>
     *
     *  @default null
     */
    public var onReady(get, set):Void->Void;
    private function get_onReady():Void->Void { return _onReady; }
    private function set_onReady(value:Void->Void):Void->Void { return _onReady = value; }
    
    /** Indicates if the alpha values are premultiplied into the RGB values. This is typically
     *  true for textures created from BitmapData and false for textures created from ATF data.
     *  This property will only be read by the <code>Texture.fromTextureBase</code> factory
     *  method. @default true */
    public var premultipliedAlpha(get, set):Bool;
    @:noCompletion private function get_premultipliedAlpha():Bool { return _premultipliedAlpha; }
    @:noCompletion private function set_premultipliedAlpha(value:Bool):Bool { return _premultipliedAlpha = value; }
}
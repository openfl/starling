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

import starling.core.Starling;

/** The TextureOptions class specifies options for loading textures with the
 *  <code>Texture.fromData</code> and <code>Texture.fromTextureBase</code> methods. */
class TextureOptions
{
    private var _scale:Float;
    private var _format:String;
    private var _mipMapping:Bool;
    private var _optimizeForRenderToTexture:Bool = false;
    private var _premultipliedAlpha:Bool;
    private var _forcePotTexture:Bool;
    private var _onReady:Texture->Void = null;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (TextureOptions.prototype, {
            "scale": { get: untyped __js__ ("function () { return this.get_scale (); }"), set: untyped __js__ ("function (v) { return this.set_scale (v); }") },
            "format": { get: untyped __js__ ("function () { return this.get_format (); }"), set: untyped __js__ ("function (v) { return this.set_format (v); }") },
            "mipMapping": { get: untyped __js__ ("function () { return this.get_mipMapping (); }"), set: untyped __js__ ("function (v) { return this.set_mipMapping (v); }") },
            "optimizeForRenderToTexture": { get: untyped __js__ ("function () { return this.get_optimizeForRenderToTexture (); }"), set: untyped __js__ ("function (v) { return this.set_optimizeForRenderToTexture (v); }") },
            "forcePotTexture": { get: untyped __js__ ("function () { return this.get_forcePotTexture (); }"), set: untyped __js__ ("function (v) { return this.set_forcePotTexture (v); }") },
            "onReady": { get: untyped __js__ ("function () { return this.get_onReady (); }"), set: untyped __js__ ("function (v) { return this.set_onReady (v); }") },
            "premultipliedAlpha": { get: untyped __js__ ("function () { return this.get_premultipliedAlpha (); }"), set: untyped __js__ ("function (v) { return this.set_premultipliedAlpha (v); }") },
        });
        
    }
    #end

    /** Creates a new instance with the given options. */
    public function new(scale:Float=1.0, mipMapping:Bool=false, 
                        format:String="bgra", premultipliedAlpha:Bool=true,
                        forcePotTexture:Bool=false)
    {
        _scale = scale;
        _format = format;
        _mipMapping = mipMapping;
        _forcePotTexture = forcePotTexture;
        _premultipliedAlpha = premultipliedAlpha;
    }
    
    /** Creates a clone of the TextureOptions object with the exact same properties. */
    public function clone():TextureOptions
    {
		var clone:TextureOptions = new TextureOptions();
		clone.copyFrom(this);
		return clone;
    }
	
	/** Copies all properties from another TextureOptions instance. */
	public function copyFrom(other:TextureOptions):Void
	{
		_scale = other._scale;
		_mipMapping = other._mipMapping;
		_format = other._format;
		_optimizeForRenderToTexture = other._optimizeForRenderToTexture;
		_premultipliedAlpha = other._premultipliedAlpha;
		_forcePotTexture = other._forcePotTexture;
		_onReady = other._onReady;
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
    public var format(get, set):String;
    private function get_format():String { return _format; }
    private function set_format(value:String):String { return _format = value; }
    
    /** Indicates if the texture contains mip maps. @default false */
    public var mipMapping(get, set):Bool;
    private function get_mipMapping():Bool { return _mipMapping; }
    private function set_mipMapping(value:Bool):Bool { return _mipMapping = value; }
    
    /** Indicates if the texture will be used as render target. */
    public var optimizeForRenderToTexture(get, set):Bool;
    private function get_optimizeForRenderToTexture():Bool { return _optimizeForRenderToTexture; }
    private function set_optimizeForRenderToTexture(value:Bool):Bool { return _optimizeForRenderToTexture = value; }

    /** Indicates if the underlying Stage3D texture should be created as the power-of-two based
     *  <code>Texture</code> class instead of the more memory efficient <code>RectangleTexture</code>.
     *  That might be useful when you need to render the texture with wrap mode <code>repeat</code>.
     *  @default false */
    public var forcePotTexture(get, set):Bool;
    private function get_forcePotTexture():Bool { return _forcePotTexture; }
    private function set_forcePotTexture(value:Bool):Bool { return _forcePotTexture = value; }

    /** If this value is set, the texture will be loaded asynchronously (if possible).
     *  The texture can only be used when the callback has been executed.
     *  
     *  <p>This is the expected function definition: 
     *  <code>function(texture:Texture):void;</code></p>
     *
     *  @default null
     */
    public var onReady(get, set):Texture->Void;
    private function get_onReady():Texture->Void { return _onReady; }
    private function set_onReady(value:Texture->Void):Texture->Void { return _onReady = value; }

    /** Indicates if the alpha values are premultiplied into the RGB values. This is typically
     *  true for textures created from BitmapData and false for textures created from ATF data.
     *  This property will only be read by the <code>Texture.fromTextureBase</code> factory
     *  method. @default true */
    public var premultipliedAlpha(get, set):Bool;
    private function get_premultipliedAlpha():Bool { return _premultipliedAlpha; }
    private function set_premultipliedAlpha(value:Bool):Bool { return _premultipliedAlpha = value; }
}
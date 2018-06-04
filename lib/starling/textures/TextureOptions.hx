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

@:jsRequire("starling/textures/TextureOptions", "default")

extern class TextureOptions
{
    /** Creates a new instance with the given options. */
    public function new(scale:Float=1.0, mipMapping:Bool=false, 
                        format:String="bgra", premultipliedAlpha:Bool=true,
                        forcePotTexture:Bool=false);
    
    /** Creates a clone of the TextureOptions object with the exact same properties. */
    public function clone():TextureOptions;
    
    /** Copies all properties from another TextureOptions instance. */
    public function copyFrom(other:TextureOptions):Void;

    /** The scale factor, which influences width and height properties. If you pass '-1',
     *  the current global content scale factor will be used. @default 1.0 */
    public var scale(get, set):Float;
    private function get_scale():Float;
    private function set_scale(value:Float):Float;
    
    /** The <code>Context3DTextureFormat</code> of the underlying texture data. Only used
     *  for textures that are created from Bitmaps; the format of ATF files is set when they
     *  are created. @default BGRA */
    public var format(get, set):String;
    private function get_format():String;
    private function set_format(value:String):String;
    
    /** Indicates if the texture contains mip maps. @default false */
    public var mipMapping(get, set):Bool;
    private function get_mipMapping():Bool;
    private function set_mipMapping(value:Bool):Bool;
    
    /** Indicates if the texture will be used as render target. */
    public var optimizeForRenderToTexture(get, set):Bool;
    private function get_optimizeForRenderToTexture():Bool;
    private function set_optimizeForRenderToTexture(value:Bool):Bool;

    /** Indicates if the underlying Stage3D texture should be created as the power-of-two based
     *  <code>Texture</code> class instead of the more memory efficient <code>RectangleTexture</code>.
     *  That might be useful when you need to render the texture with wrap mode <code>repeat</code>.
     *  @default false */
    public var forcePotTexture(get, set):Bool;
    private function get_forcePotTexture():Bool;
    private function set_forcePotTexture(value:Bool):Bool;

    /** If this value is set, the texture will be loaded asynchronously (if possible).
     *  The texture can only be used when the callback has been executed.
     *  
     *  <p>This is the expected function definition: 
     *  <code>function(texture:Texture):void;</code></p>
     *
     *  @default null
     */
    public var onReady(get, set):Texture->Void;
    private function get_onReady():Texture->Void;
    private function set_onReady(value:Texture->Void):Texture->Void;

    /** Indicates if the alpha values are premultiplied into the RGB values. This is typically
     *  true for textures created from BitmapData and false for textures created from ATF data.
     *  This property will only be read by the <code>Texture.fromTextureBase</code> factory
     *  method. @default true */
    public var premultipliedAlpha(get, set):Bool;
    private function get_premultipliedAlpha():Bool;
    private function set_premultipliedAlpha(value:Bool):Bool;
}
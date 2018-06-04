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

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;
#if flash
import flash.media.Camera;
#end
import openfl.net.NetStream;
import openfl.system.Capabilities;
import openfl.utils.ByteArray;

import starling.core.Starling;
import starling.errors.AbstractClassError;
import starling.errors.AbstractMethodError;
import starling.errors.NotSupportedError;
import starling.events.Event;
import starling.rendering.Painter;
import starling.utils.Color;

/** A ConcreteTexture wraps a Stage3D texture object, storing the properties of the texture
*  and providing utility methods for data upload, etc.
*
*  <p>This class cannot be instantiated directly; create instances using
*  <code>Texture.fromTextureBase</code> instead. However, that's only necessary when
*  you need to wrap a <code>TextureBase</code> object in a Starling texture;
*  the preferred way of creating textures is to use one of the other
*  <code>Texture.from...</code> factory methods in the <code>Texture</code> class.</p>
*
*  @see Texture
*/

@:jsRequire("starling/textures/ConcreteTexture", "default")

extern class ConcreteTexture extends Texture
{
    /** Disposes the TextureBase object. */
    public override function dispose():Void;

    // texture data upload

    /** Uploads a bitmap to the texture. The existing contents will be replaced.
    *  If the size of the bitmap does not match the size of the texture, the bitmap will be
    *  cropped or filled up with transparent pixels.
    *
    *  <p>Pass a callback function to attempt asynchronous texture upload.
    *  If the current platform or runtime version does not support asynchronous texture loading,
    *  the callback will still be executed.</p>
    *
    *  <p>This is the expected function definition:
    *  <code>function(texture:ConcreteTexture):Void;</code>
    */
    public function uploadBitmap(bitmap:Bitmap, async:ConcreteTexture->Void=null):Void;

    /** Uploads bitmap data to the texture. The existing contents will be replaced.
    *  If the size of the bitmap does not match the size of the texture, the bitmap will be
    *  cropped or filled up with transparent pixels.
    *
    *  <p>Pass a callback function to attempt asynchronous texture upload.
    *  If the current platform or runtime version does not support asynchronous texture loading,
    *  the callback will still be executed.</p>
    *
    *  <p>This is the expected function definition:
    *  <code>function(texture:ConcreteTexture):Void;</code>
    */
    public function uploadBitmapData(data:BitmapData, async:ConcreteTexture->Void=null):Void;

    /** Uploads ATF data from a ByteArray to the texture. Note that the size of the
    *  ATF-encoded data must be exactly the same as the original texture size.
    *  
    *  <p>The 'async' parameter is a callback function.
    *  If it's <code>null</code>, the texture will be decoded synchronously and will be visible right away.
    *  If it's a function, the data will be decoded asynchronously. The texture will remain unchanged until the
    *  upload is complete, at which time the callback function will be executed. This is the
    *  expected function definition: <code>function(texture:ConcreteTexture):Void;</code></p>
    */
    public function uploadAtfData(data:ByteArray, offset:Int=0, async:ConcreteTexture->Void=null):Void;

    /** Specifies a video stream to be rendered within the texture. */
    public function attachNetStream(netStream:NetStream, onComplete:ConcreteTexture->Void=null):Void;

    #if flash
    /** Specifies a video stream from a camera to be rendered within the texture. */
    public function attachCamera(camera:Camera, onComplete:ConcreteTexture->Void=null):Void;
    #end

    /** Clears the texture with a certain color and alpha value. The previous contents of the
    *  texture is wiped out. */
    public function clear(color:UInt=0x0, alpha:Float=0.0):Void;

    // properties

    /** Indicates if the base texture was optimized for being used in a render texture. */
    public var optimizedForRenderTexture(get, never):Bool;
    private function get_optimizedForRenderTexture():Bool;

    /** Indicates if the base texture is a standard power-of-two dimensioned texture of type
    *  <code>flash.display3D.textures.Texture</code>. */
    public var isPotTexture(get, never):Bool;
    private function get_isPotTexture():Bool;

    /** The function that you provide here will be called after a context loss.
    *  On execution, a new base texture will already have been created; however,
    *  it will be empty. Call one of the "upload..." methods from within the callback
    *  to restore the actual texture data.
    *
    *  <listing>
    *  var texture:Texture = Texture.fromBitmap(new EmbeddedBitmap());
    *  texture.root.onRestore = function():void
    *  {
    *      texture.root.uploadFromBitmap(new EmbeddedBitmap());
    *  };</listing>
    */
    public var onRestore(get, set):ConcreteTexture->Void;
    private function get_onRestore():ConcreteTexture->Void;
    private function set_onRestore(value:ConcreteTexture->Void):ConcreteTexture->Void;
}
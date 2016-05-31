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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.textures.TextureBase;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
#if flash
import flash.media.Camera;
#end
import flash.net.NetStream;
import flash.utils.ByteArray;
#if 0
import flash.utils.getQualifiedClassName;
#end
import haxe.Constraints.Function;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.Error;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.errors.MissingContextError;
import starling.errors.NotSupportedError;
import starling.events.Event;
import starling.utils.Color;
import starling.utils.SafeCast.safe_cast;
//import starling.utils.execute;

//use namespace starling_internal;

/** A ConcreteTexture wraps a Stage3D texture object, storing the properties of the texture. */
class ConcreteTexture extends Texture
{
    inline private static var TEXTURE_READY:String = "textureReady"; // defined here for backwards compatibility
    
    private var mBase:TextureBase;
    private var mFormat:Context3DTextureFormat;
    private var mWidth:Int;
    private var mHeight:Int;
    private var mMipMapping:Bool;
    private var mPremultipliedAlpha:Bool;
    private var mOptimizedForRenderTexture:Bool;
    private var mScale:Float;
    private var mRepeat:Bool;
    private var mOnRestore:Function;
    private var mDataUploaded:Bool;
    private var mTextureReadyCallback:Function;
    
    /** helper object */
    private static var sOrigin:Point = new Point();
    
    /** Creates a ConcreteTexture object from a TextureBase, storing information about size,
     *  mip-mapping, and if the channels contain premultiplied alpha values. */
    public function new(base:TextureBase, format:Context3DTextureFormat, width:Int, height:Int, 
                                    mipMapping:Bool, premultipliedAlpha:Bool,
                                    optimizedForRenderTexture:Bool=false,
                                    scale:Float=1, repeat:Bool=false)
    {
        super();
        mScale = scale <= 0 ? 1.0 : scale;
        mBase = base;
        mFormat = format;
        mWidth = width;
        mHeight = height;
        mMipMapping = mipMapping;
        mPremultipliedAlpha = premultipliedAlpha;
        mOptimizedForRenderTexture = optimizedForRenderTexture;
        mRepeat = repeat;
        mOnRestore = null;
        mDataUploaded = false;
        mTextureReadyCallback = null;
    }
    
    /** Disposes the TextureBase object. */
    public override function dispose():Void
    {
        if (mBase != null)
        {
            mBase.removeEventListener(TEXTURE_READY, onTextureReady);
            mBase.dispose();
        }

        this.onRestore = null; // removes event listener
        super.dispose();
    }
    
    // texture data upload
    
    /** Uploads a bitmap to the texture. The existing contents will be replaced.
     *  If the size of the bitmap does not match the size of the texture, the bitmap will be
     *  cropped or filled up with transparent pixels */
    public function uploadBitmap(bitmap:Bitmap):Void
    {
        uploadBitmapData(bitmap.bitmapData);
    }
    
    /** Uploads bitmap data to the texture. The existing contents will be replaced.
     *  If the size of the bitmap does not match the size of the texture, the bitmap will be
     *  cropped or filled up with transparent pixels */
    public function uploadBitmapData(data:BitmapData):Void
    {
        var potData:BitmapData = null;
        
        if (data.width != mWidth || data.height != mHeight)
        {
            potData = new BitmapData(mWidth, mHeight, true, 0);
            potData.copyPixels(data, data.rect, sOrigin);
            data = potData;
        }
        
        if (Std.is(mBase, openfl.display3D.textures.Texture))
        {
            var potTexture:openfl.display3D.textures.Texture = 
                cast mBase;
            
            potTexture.uploadFromBitmapData(data);
            
            if (mMipMapping && data.width > 1 && data.height > 1)
            {
                var currentWidth:Int  = data.width  >> 1;
                var currentHeight:Int = data.height >> 1;
                var level:Int = 1;
                var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0);
                var transform:Matrix = new Matrix(.5, 0, 0, .5);
                var bounds:Rectangle = new Rectangle();
                
                while (currentWidth >= 1 || currentHeight >= 1)
                {
                    bounds.width = currentWidth; bounds.height = currentHeight;
                    canvas.fillRect(bounds, 0);
                    canvas.draw(data, transform, null, null, null, true);
                    potTexture.uploadFromBitmapData(canvas, level++);
                    transform.scale(0.5, 0.5);
                    currentWidth  = currentWidth  >> 1;
                    currentHeight = currentHeight >> 1;
                }
                
                canvas.dispose();
            }
        }
        else if (Std.is(mBase, openfl.display3D.textures.RectangleTexture))
        {
            var baseTexrue:openfl.display3D.textures.RectangleTexture = cast mBase;
            baseTexrue.uploadFromBitmapData(data);
        }
        
        if (potData != null) potData.dispose();
        mDataUploaded = true;
    }
    
    /** Uploads ATF data from a ByteArray to the texture. Note that the size of the
     *  ATF-encoded data must be exactly the same as the original texture size.
     *  
     *  <p>The 'async' parameter may be either a boolean value or a callback function.
     *  If it's <code>false</code> or <code>null</code>, the texture will be decoded
     *  synchronously and will be visible right away. If it's <code>true</code> or a function,
     *  the data will be decoded asynchronously. The texture will remain unchanged until the
     *  upload is complete, at which time the callback function will be executed. This is the
     *  expected function definition: <code>function(texture:Texture):void;</code></p>
     */
    public function uploadAtfData(data:ByteArray, offset:Int=0, async:Dynamic=null):Void
    {
        var isAsync:Bool = Reflect.isFunction(async) || async == true;
        var potTexture:flash.display3D.textures.Texture = 
              safe_cast(mBase, flash.display3D.textures.Texture);
        
        if (potTexture == null)
            throw new Error("This texture type does not support ATF data");
        
        if (Reflect.isFunction(async))
        {
            mTextureReadyCallback = async;
            mBase.addEventListener(TEXTURE_READY, onTextureReady);
        }
        
        potTexture.uploadCompressedTextureFromByteArray(data, offset, isAsync);
        mDataUploaded = true;
    }

    public function attachNetStream(netStream:NetStream, onComplete:Function=null):Void
    {
        attachVideo("NetStream", netStream, onComplete);
    }

    #if flash
    public function attachCamera(camera:Camera, onComplete:Function=null):Void
    {
        attachVideo("Camera", camera, onComplete);
    }
    #end

    private function attachVideo(type:String, attachment:Dynamic, onComplete:Function=null):Void
    {
        var className:String = Type.getClassName(Type.getClass(mBase));

        if (className == "flash.display3D.textures.VideoTexture")
        {
            mDataUploaded = true;
            mTextureReadyCallback = onComplete;
            Reflect.callMethod(mBase, Reflect.getProperty(mBase, "attach" + type), attachment);
            mBase.addEventListener(TEXTURE_READY, onTextureReady);
        }
        else throw new Error("This texture type does not support " + type + " data");
    }

    private function onTextureReady(event:Dynamic):Void
    {
        mBase.removeEventListener(TEXTURE_READY, onTextureReady);
        #if 0
        execute(mTextureReadyCallback, this);
        #else
        mTextureReadyCallback(this);
        #end
        mTextureReadyCallback = null;
    }
    
    // texture backup (context loss)
    
    private function onContextCreated():Void
    {
        // recreate the underlying texture & restore contents
        createBase();
        if (mOnRestore != null) mOnRestore();
        
        // if no texture has been uploaded above, we init the texture with transparent pixels.
        if (!mDataUploaded) clear();
    }
    
    /** Recreates the underlying Stage3D texture object with the same dimensions and attributes
     *  as the one that was passed to the constructor. You have to upload new data before the
     *  texture becomes usable again. Beware: this method does <strong>not</strong> dispose
     *  the current base. */
    private function createBase():Void
    {
        var context:Context3D = Starling.current.context;
        var className:String = Type.getClassName(Type.getClass(mBase));
        
        if (className == "flash.display3D.textures.Texture")
            mBase = context.createTexture(mWidth, mHeight, mFormat, 
                                          mOptimizedForRenderTexture);
        else if (className == "flash.display3D.textures.RectangleTexture")
            mBase = Reflect.callMethod(context, Reflect.getProperty(context, "createRectangleTexture"), [mWidth, mHeight, mFormat,
                                                      mOptimizedForRenderTexture]);
        else if (className == "flash.display3D.textures.VideoTexture")
            mBase = Reflect.callMethod(context, Reflect.getProperty(context, "createVideoTexture"), []);
        else
            throw new NotSupportedError("Texture type not supported: " + className);

        mDataUploaded = false;
    }
    
    /** Clears the texture with a certain color and alpha value. The previous contents of the
     *  texture is wiped out. Beware: this method resets the render target to the back buffer; 
     *  don't call it from within a render method. */ 
    public function clear(color:UInt=0x0, alpha:Float=0.0):Void
    {
        var context:Context3D = Starling.current.context;
        if (context == null) throw new MissingContextError();
        
        if (mPremultipliedAlpha && alpha < 1.0)
            color = Color.rgb(Std.int(Color.getRed(color)   * alpha),
                              Std.int(Color.getGreen(color) * alpha),
                              Std.int(Color.getBlue(color)  * alpha));
        
        context.setRenderToTexture(mBase);
        
        // we wrap the clear call in a try/catch block as a workaround for a problem of
        // FP 11.8 plugin/projector: calling clear on a compressed texture doesn't work there
        // (while it *does* work on iOS + Android).
        
        try { RenderSupport._clear(color, alpha); }
        catch (e:Error) {}
        
        context.setRenderToBackBuffer();
        mDataUploaded = true;
    }
    
    // properties
    
    /** Indicates if the base texture was optimized for being used in a render texture. */
    public var optimizedForRenderTexture(get, never):Bool;
    private function get_optimizedForRenderTexture():Bool { return mOptimizedForRenderTexture; }
    
    /** If Starling's "handleLostContext" setting is enabled, the function that you provide
     *  here will be called after a context loss. On execution, a new base texture will
     *  already have been created; however, it will be empty. Call one of the "upload..."
     *  methods from within the callbacks to restore the actual texture data. */
    public var onRestore(get, set):Function;
    private function get_onRestore():Function { return mOnRestore; }
    private function set_onRestore(value:Function):Function
    {
        Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        
        if (Starling.handleLostContext && value != null)
        {
            mOnRestore = value;
            Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        }
        else mOnRestore = null;
        return mOnRestore;
    }
    
    /** @inheritDoc */
    public override function get_base():TextureBase { return mBase; }
    
    /** @inheritDoc */
    public override function get_root():ConcreteTexture { return this; }
    
    /** @inheritDoc */
    public override function get_format():Context3DTextureFormat { return mFormat; }
    
    /** @inheritDoc */
    public override function get_width():Float  { return mWidth / mScale;  }
    
    /** @inheritDoc */
    public override function get_height():Float { return mHeight / mScale; }
    
    /** @inheritDoc */
    public override function get_nativeWidth():Float { return mWidth; }
    
    /** @inheritDoc */
    public override function get_nativeHeight():Float { return mHeight; }
    
    /** The scale factor, which influences width and height properties. */
    public override function get_scale():Float { return mScale; }
    
    /** @inheritDoc */
    public override function get_mipMapping():Bool { return mMipMapping; }
    
    /** @inheritDoc */
    public override function get_premultipliedAlpha():Bool { return mPremultipliedAlpha; }
    
    /** @inheritDoc */
    public override function get_repeat():Bool { return mRepeat; }
}
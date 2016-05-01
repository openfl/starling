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
import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.TextureBase;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import openfl.errors.ArgumentError;

import starling.core.Starling;
import starling.utils.MathUtil;
#if 0
import starling.utils.execute;
#end

/** @private
 *
 *  A concrete texture that wraps a <code>Texture</code> base.
 *  For internal use only. */
class ConcretePotTexture extends ConcreteTexture
{
    private var _textureReadyCallback:Dynamic;

    private static var sMatrix:Matrix = new Matrix();
    private static var sRectangle:Rectangle = new Rectangle();
    private static var sOrigin:Point = new Point();

    /** Creates a new instance with the given parameters. */
    public function new(base:flash.display3D.textures.Texture, format:Context3DTextureFormat,
                                       width:Int, height:Int, mipMapping:Bool,
                                       premultipliedAlpha:Bool,
                                       optimizedForRenderTexture:Bool=false, scale:Float=1)
    {
        super(base, format, width, height, mipMapping, premultipliedAlpha,
              optimizedForRenderTexture, scale);

        if (width != MathUtil.getNextPowerOfTwo(width))
            throw new ArgumentError("width must be a power of two");

        if (height != MathUtil.getNextPowerOfTwo(height))
            throw new ArgumentError("height must be a power of two");
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        #if flash
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        #end
        super.dispose();
    }

    /** @inheritDoc */
    override private function createBase():TextureBase
    {
        return Starling.sContext.createTexture(
                Std.int(nativeWidth), Std.int(nativeHeight), format, optimizedForRenderTexture);
    }

    /** @inheritDoc */
    override public function uploadBitmapData(data:BitmapData):Void
    {
        potBase.uploadFromBitmapData(data);

        var buffer:BitmapData = null;

        if (data.width != nativeWidth || data.height != nativeHeight)
        {
            buffer = new BitmapData(Std.int(nativeWidth), Std.int(nativeHeight), true, 0);
            buffer.copyPixels(data, data.rect, sOrigin);
            data = buffer;
        }

        if (mipMapping && data.width > 1 && data.height > 1)
        {
            var currentWidth:Int  = data.width  >> 1;
            var currentHeight:Int = data.height >> 1;
            var level:Int = 1;
            var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0);
            var bounds:Rectangle = sRectangle;
            var matrix:Matrix = sMatrix;
            matrix.setTo(0.5, 0.0, 0.0, 0.5, 0.0, 0.0);

            while (currentWidth >= 1 || currentHeight >= 1)
            {
                bounds.setTo(0, 0, currentWidth, currentHeight);
                canvas.fillRect(bounds, 0);
                canvas.draw(data, matrix, null, null, null, true);
                potBase.uploadFromBitmapData(canvas, level++);
                matrix.scale(0.5, 0.5);
                currentWidth  = currentWidth  >> 1;
                currentHeight = currentHeight >> 1;
            }

            canvas.dispose();
        }

        if (buffer != null) buffer.dispose();

        setDataUploaded();
    }

    /** @inheritDoc */
    @:noCompletion override private function get_isPotTexture():Bool { return true; }

    /** @inheritDoc */
    override public function uploadAtfData(data:ByteArray, offset:Int = 0, async:Dynamic = null):Void
    {
        #if 0
        var isAsync:Bool = async is Function || async === true;
        #else
        var isAsync:Bool = Reflect.isFunction(async);
        #end

        #if 0
        if (async is Function)
        #else
        if (isAsync)
        #end
        {
            _textureReadyCallback = async;
            #if flash
            base.addEventListener(Event.TEXTURE_READY, onTextureReady);
            #end
        }

        potBase.uploadCompressedTextureFromByteArray(data, offset, isAsync);
        setDataUploaded();
    }

    private function onTextureReady(event:Event):Void
    {
        #if flash
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        #end
        #if 0
        execute(_textureReadyCallback, this);
        #else
        _textureReadyCallback(this);
        #end
        _textureReadyCallback = null;
    }

    private var potBase(get, never):flash.display3D.textures.Texture;
    @:noCompletion private function get_potBase():flash.display3D.textures.Texture
    {
        return cast base;
    }
}

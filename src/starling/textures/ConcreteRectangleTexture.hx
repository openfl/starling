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

import haxe.Timer;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;

import starling.core.Starling;

/** @private
 *
 *  A concrete texture that wraps a <code>RectangleTexture</code> base.
 *  For internal use only. */
@:allow(starling) class ConcreteRectangleTexture extends ConcreteTexture
{
    private var _textureReadyCallback:ConcreteTexture->Void;

    private static var sAsyncUploadEnabled:Bool = false;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (ConcreteRectangleTexture.prototype, {
            "rectBase": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_rectBase (); }") },
        });
        
    }
    #end

    /** Creates a new instance with the given parameters. */
    private function new(base:RectangleTexture, format:String,
                         width:Int, height:Int, premultipliedAlpha:Bool,
                         optimizedForRenderTexture:Bool=false,
                         scale:Float=1)
    {
        super(base, format, width, height, false, premultipliedAlpha,
              optimizedForRenderTexture, scale);
    }

    /** @inheritDoc */
    override public function uploadBitmapData(data:BitmapData, async:ConcreteTexture->Void=null):Void
    {
        if (async != null)
            _textureReadyCallback = async;

        upload(data, async != null);
        setDataUploaded();
    }

    /** @inheritDoc */
    override private function createBase():TextureBase
    {
        return Starling.current.context.createRectangleTexture(
                Std.int(nativeWidth), Std.int(nativeHeight), format, optimizedForRenderTexture);
    }

    public var rectBase(get, never):RectangleTexture;
    private function get_rectBase():RectangleTexture
    {
        return cast base;
    }

    // async upload

    private function upload(source:BitmapData, isAsync:Bool):Void
    {
        if (isAsync)
        {
            uploadAsync(source);
            base.addEventListener(Event.TEXTURE_READY, onTextureReady);
            base.addEventListener(ErrorEvent.ERROR, onTextureReady);
        }
        else
        {
            rectBase.uploadFromBitmapData(source);
        }
    }

    private function uploadAsync(source:BitmapData):Void
    {
        if (sAsyncUploadEnabled)
        {
            var method = Reflect.field(base, "uploadFromBitmapDataAsync");
            try { Reflect.callMethod(base, method, [source]); }
            catch (error:Error)
            {
                if (error.errorID == 3708 || error.errorID == 1069)
                    sAsyncUploadEnabled = false; // feature or method not available
                else
                    throw error;
            }
        }

        if (!sAsyncUploadEnabled)
        {
            Timer.delay(function() {
                base.dispatchEvent(new Event(Event.TEXTURE_READY));
            }, 1);
            rectBase.uploadFromBitmapData(source);
        }
    }

    private function onTextureReady(event:Event):Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        base.removeEventListener(ErrorEvent.ERROR, onTextureReady);

        if (_textureReadyCallback != null)
            _textureReadyCallback(this);
        _textureReadyCallback = null;
    }

    /** @private */
    @:allow(starling) private static var asyncUploadEnabled(get, set):Bool;
    private static function get_asyncUploadEnabled():Bool { return sAsyncUploadEnabled; }
    private static function set_asyncUploadEnabled(value:Bool):Bool { return sAsyncUploadEnabled = value; }
}
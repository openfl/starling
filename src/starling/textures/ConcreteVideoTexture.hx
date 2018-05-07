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
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.VideoTexture;
import openfl.events.Event;

import starling.core.Starling;

/** @private
 *
 *  A concrete texture that wraps a <code>VideoTexture</code> base.
 *  For internal use only. */
@:allow(starling) class ConcreteVideoTexture extends ConcreteTexture
{
    private var _textureReadyCallback:ConcreteTexture->Void;
    private var _disposed:Bool;

    /** Creates a new instance with the given parameters.
     *  <code>base</code> must be of type <code>flash.display3D.textures.VideoTexture</code>.
     */
    private function new(base:VideoTexture, scale:Float=1)
    {
        super(base, Context3DTextureFormat.BGRA, base.videoWidth, base.videoHeight, false,
              false, false, scale);
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);

        // It shouldn't be necessary to manually release the attachments.
        // The following is a workaround for bugs #4198120 and #4198123 in the Adobe Bugbase.

        if (!_disposed)
        {
            #if (flash && !display)
            videoBase.attachCamera(null);
            #end
            videoBase.attachNetStream(null);
            _disposed = true;
        }

        super.dispose();
    }

    /** @inheritDoc */
    override private function createBase():TextureBase
    {
        return Starling.current.context.createVideoTexture();
    }

    /** @private */
    override private function attachVideo(type:String, attachment:Dynamic,
                                           onComplete:ConcreteTexture->Void=null):Void
    {
        _textureReadyCallback = onComplete;
        var method = Reflect.field(base, "attach" + type);
        Reflect.callMethod(base, method, [attachment]);
        base.addEventListener(Event.TEXTURE_READY, onTextureReady);

        setDataUploaded();
    }

    private function onTextureReady(event:Event):Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        if (_textureReadyCallback != null)
            _textureReadyCallback(this);
        _textureReadyCallback = null;
    }

    /** The actual width of the video in pixels. */
    override private function get_nativeWidth():Float
    {
        return videoBase.videoWidth;
    }

    /** The actual height of the video in pixels. */
    override private function get_nativeHeight():Float
    {
        return videoBase.videoHeight;
    }

    /** @inheritDoc */
    override private function get_width():Float
    {
        return nativeWidth / scale;
    }

    /** @inheritDoc */
    override private function get_height():Float
    {
        return nativeHeight / scale;
    }

    private var videoBase(get, never):VideoTexture;
    private function get_videoBase():VideoTexture
    {
        return cast base;
    }
}
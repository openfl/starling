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
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.TextureBase;
import flash.display3D.textures.VideoTexture;
import flash.events.Event;

import starling.core.Starling;
#if 0
import starling.utils.execute;
#end

/** @private
 *
 *  A concrete texture that wraps a <code>VideoTexture</code> base.
 *  For internal use only. */
class ConcreteVideoTexture extends ConcreteTexture
{
    private var _textureReadyCallback:Dynamic;

    /** Creates a new instance with the given parameters.
     *  <code>base</code> must be of type <code>flash.display3D.textures.VideoTexture</code>.
     */
    public function new(base:VideoTexture, scale:Float=1)
    {
        super(base, Context3DTextureFormat.BGRA, base.videoWidth, base.videoHeight, false,
              false, false, scale);
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        super.dispose();
    }

    /** @inheritDoc */
    override private function createBase():TextureBase
    {
        return Starling.sContext.createVideoTexture();
    }

    /** @private */
    override public function attachVideo(type:String, attachment:Dynamic,
                                           onComplete:Dynamic=null):Void
    {
        _textureReadyCallback = onComplete;
        Reflect.setProperty(base, "attach" + type, attachment);
        base.addEventListener(Event.TEXTURE_READY, onTextureReady);

        setDataUploaded();
    }

    private function onTextureReady(event:Event):Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        #if 0
        execute(_textureReadyCallback, this);
        #else
        _textureReadyCallback(this);
        #end
        _textureReadyCallback = null;
    }

    /** The actual width of the video in pixels. */
    override public function get_nativeWidth():Float
    {
        return videoBase.videoWidth;
    }

    /** The actual height of the video in pixels. */
    override public function get_nativeHeight():Float
    {
        return videoBase.videoHeight;
    }

    /** @inheritDoc */
    override public function get_width():Float
    {
        return nativeWidth / scale;
    }

    /** @inheritDoc */
    override public function get_height():Float
    {
        return nativeHeight / scale;
    }

    private var videoBase(get, never):VideoTexture;
    @:noCompletion private function get_videoBase():VideoTexture
    {
        return cast base;
    }
}

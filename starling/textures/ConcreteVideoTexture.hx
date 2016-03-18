// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures
{
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.TextureBase;
import flash.display3D.textures.VideoTexture;
import flash.events.Event;

import starling.core.Starling;
import starling.utils.execute;

/** @private
 *
 *  A concrete texture that wraps a <code>VideoTexture</code> base.
 *  For internal use only. */
internal class ConcreteVideoTexture extends ConcreteTexture
{
    private var _textureReadyCallback:Function;

    /** Creates a new instance with the given parameters.
     *  <code>base</code> must be of type <code>flash.display3D.textures.VideoTexture</code>.
     */
    public function ConcreteVideoTexture(base:VideoTexture, scale:Float=1)
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
    override protected function createBase():TextureBase
    {
        return Starling.context.createVideoTexture();
    }

    /** @private */
    override internal function attachVideo(type:String, attachment:Object,
                                           onComplete:Function=null):Void
    {
        _textureReadyCallback = onComplete;
        base["attach" + type](attachment);
        base.addEventListener(Event.TEXTURE_READY, onTextureReady);

        setDataUploaded();
    }

    private function onTextureReady(event:Event):Void
    {
        base.removeEventListener(Event.TEXTURE_READY, onTextureReady);
        execute(_textureReadyCallback, this);
        _textureReadyCallback = null;
    }

    /** The actual width of the video in pixels. */
    override public function get nativeWidth():Float
    {
        return videoBase.videoWidth;
    }

    /** The actual height of the video in pixels. */
    override public function get nativeHeight():Float
    {
        return videoBase.videoHeight;
    }

    /** @inheritDoc */
    override public function get width():Float
    {
        return nativeWidth / scale;
    }

    /** @inheritDoc */
    override public function get height():Float
    {
        return nativeHeight / scale;
    }

    private function get videoBase():VideoTexture
    {
        return base as VideoTexture;
    }
}
}

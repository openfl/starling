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
import flash.display3D.textures.RectangleTexture;
import flash.display3D.textures.TextureBase;

import starling.core.Starling;

/** @private
 *
 *  A concrete texture that wraps a <code>RectangleTexture</code> base.
 *  For internal use only. */
class ConcreteRectangleTexture extends ConcreteTexture
{
    /** Creates a new instance with the given parameters. */
    public function new(base:RectangleTexture, format:Context3DTextureFormat,
                                             width:Int, height:Int, premultipliedAlpha:Bool,
                                             optimizedForRenderTexture:Bool=false,
                                             scale:Float=1)
    {
        super(base, format, width, height, false, premultipliedAlpha,
              optimizedForRenderTexture, scale);
    }

    /** @inheritDoc */
    override public function uploadBitmapData(data:BitmapData):Void
    {
        rectangleBase.uploadFromBitmapData(data);
        setDataUploaded();
    }

    /** @inheritDoc */
    override private function createBase():TextureBase
    {
        return Starling.sContext.createRectangleTexture(
                Std.int(nativeWidth), Std.int(nativeHeight), format, optimizedForRenderTexture);
    }

    private var rectangleBase(get, never):RectangleTexture;
    @:noCompletion private function get_rectangleBase():RectangleTexture
    {
        return cast base;
    }
}

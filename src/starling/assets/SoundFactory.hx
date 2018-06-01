// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.assets;

import flash.media.Sound;
import openfl.errors.Error;
import openfl.utils.ByteArray;

/** This AssetFactory creates sound assets. */
class SoundFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new()
    {
        super();
        addMimeTypes(["audio/mp3", "audio/mpeg3", "audio/mpeg", "audio/ogg"]);
        addExtensions(["mp3", "mpeg", "ogg", "wav"]);
    }

    /** @inheritDoc */
    override public function canHandle(reference:AssetReference):Bool
    {
        return Std.is(reference.data, Sound) || super.canHandle(reference);
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        var sound:Sound = null;
        
        try
        {
            if(Std.is(reference.data, Sound))
                sound = cast(reference.data, Sound);
            else
            {
                var bytes:ByteArray = Std.is(reference.data, #if commonjs ByteArray #else ByteArrayData #end) ? cast reference.data : null;

                if (bytes != null)
                {
                    sound = new Sound();
                    sound.loadCompressedDataFromByteArray(bytes, bytes.length);
                }
            }
            
            onComplete(reference.name, sound);
        
        }
        catch (e:Error)
        {
            onError("Could not load sound data: " + e.message);
            return;
        }
    }
}
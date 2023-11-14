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

import openfl.media.Sound;
import openfl.errors.Error;
import openfl.utils.ByteArray;

import starling.utils.ByteArrayUtil;

/** This AssetFactory creates sound assets. */
class SoundFactory extends AssetFactory
{
    private static var MAGIC_NUMBERS_A:Array<Int> = [0xFF, 0xFB];
    private static var MAGIC_NUMBERS_B:Array<Int> = [0x49, 0x44, 0x33];

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
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, Sound) || super.canHandle(reference))
            return true;
        else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, #if commonjs ByteArray #else ByteArrayData #end))
        {
            var byteData:ByteArray = cast reference.data;
            return ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_A) ||
                    ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_B);
        }
        else return false;
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        var sound:Sound = null;
        
        try
        {
            if(#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, Sound))
                sound = cast(reference.data, Sound);
            else
            {
                var bytes:ByteArray = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, #if commonjs ByteArray #else ByteArrayData #end) ? cast reference.data : null;

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
        catch (e:Dynamic)
        {
            onError("Could not load sound data: " + Std.string(e));
            return;
        }
    }
}
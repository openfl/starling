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

import openfl.utils.ByteArray;
import haxe.Json;
import openfl.errors.Error;

import starling.utils.ByteArrayUtil;

/** This AssetFactory creates objects from JSON data. */
class JsonFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new()
    {
        super();
        addExtensions(["json"]);
        addMimeTypes(["application/json", "text/json"]);
    }

    /** @inheritDoc */
    override public function canHandle(reference:AssetReference):Bool
    {
        return super.canHandle(reference) || (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, #if commonjs ByteArray #else ByteArrayData #end) &&
            ByteArrayUtil.startsWithString(cast reference.data, "{"));
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        try
        {
            var bytes:ByteArray = cast reference.data;
            var object:Dynamic = Json.parse(bytes.readUTFBytes(bytes.length));
            onComplete(reference.name, object);
        }
        catch (e:Error)
        {
            onError("Could not parse JSON: " + e.message);
        }
        catch (e:Dynamic)
        {
            onError("Could not parse JSON: " + Std.string(e));
        }
    }
}

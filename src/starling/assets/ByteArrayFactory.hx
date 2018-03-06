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

/** This AssetFactory forwards ByteArrays to the AssetManager. It's the fallback when
 *  no other factory can handle an asset reference (default priority: -100). */
class ByteArrayFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new()
    {
        // not used, actually - this factory is used as a fallback with low priority
        super();
        addExtensions(["bin"]);
        addMimeTypes(["application/octet-stream"]);
    }

    /** @inheritDoc */
    override public function canHandle(reference:AssetReference):Bool
    {
        return Std.is(reference.data, #if commonjs ByteArray #else ByteArrayData #end);
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        onComplete(reference.name, cast(reference.data, ByteArray));
    }
}
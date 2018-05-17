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

@:jsRequire("starling/assets/JsonFactory", "default")

extern class JsonFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new();
}

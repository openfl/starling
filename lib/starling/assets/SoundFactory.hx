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
import flash.utils.ByteArray;
import openfl.errors.Error;

/** This AssetFactory creates sound assets. */

@:jsRequire("starling/assets/SoundFactory", "default")

extern class SoundFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new();
}
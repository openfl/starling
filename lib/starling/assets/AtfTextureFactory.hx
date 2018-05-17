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

import starling.textures.AtfData;
import starling.textures.Texture;

/** This AssetFactory creates texture assets from ATF files. */

@:jsRequire("starling/assets/AtfTextureFactory", "default")

extern class AtfTextureFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new();
}
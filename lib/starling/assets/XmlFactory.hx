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
import openfl.errors.Error;

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.ByteArrayUtil;

/** This AssetFactory creates XML assets, texture atlases and bitmap fonts. */

@:jsRequire("starling/assets/XmlFactory", "default")

extern class XmlFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new();
}
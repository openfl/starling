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
import openfl.media.Video;
import openfl.utils.ByteArray;

import starling.errors.AbstractClassError;
import starling.text.BitmapFont;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/** An enumeration class containing all the asset types supported by the AssetManager. */

@:jsRequire("starling/assets/AssetType", "default")

extern class AssetType
{
    public static var TEXTURE:String;
    public static var TEXTURE_ATLAS:String;
    public static var SOUND:String;
    public static var XML_DOCUMENT:String;
    public static var OBJECT:String;
    public static var BYTE_ARRAY:String;
    public static var BITMAP_FONT:String;
    public static var ASSET_MANAGER:String;

    /** Figures out the asset type string from the type of the given instance. */
    public static function fromAsset(asset:Dynamic):String;
}
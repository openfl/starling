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
class AssetType
{
    /** @private */
    // public function new() { throw new AbstractClassError(); }

    public static var TEXTURE:String = "texture";
    public static var TEXTURE_ATLAS:String = "textureAtlas";
    public static var SOUND:String = "sound";
    public static var XML_DOCUMENT:String = "xml";
    public static var OBJECT:String = "object";
    public static var BYTE_ARRAY:String = "byteArray";
    public static var BITMAP_FONT:String = "bitmapFont";
    public static var ASSET_MANAGER:String = "assetManager";

    /** Figures out the asset type string from the type of the given instance. */
    public static function fromAsset(asset:Dynamic):String
    {
        if (Std.is(asset, Texture)) return TEXTURE;
        else if (Std.is(asset, TextureAtlas)) return TEXTURE_ATLAS;
        else if (Std.is(asset, Sound)) return SOUND;
        else if (Std.is(asset, Xml)) return XML_DOCUMENT;
        else if (Std.is(asset, #if commonjs ByteArray #else ByteArrayData #end)) return BYTE_ARRAY;
        else if (Std.is(asset, BitmapFont)) return BITMAP_FONT;
        else if (Std.is(asset, AssetManager)) return ASSET_MANAGER;
        else return OBJECT;
    }
}
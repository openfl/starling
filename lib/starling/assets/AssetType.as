// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.assets {

	import openfl.media.Sound;
	import openfl.media.Video;
	import openfl.utils.ByteArray;

	import starling.errors.AbstractClassError;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * @externs
	 * An enumeration class containing all the asset types supported by the AssetManager.
	 */
	public class AssetType
	{
		public static const TEXTURE:String = "texture";
		public static const TEXTURE_ATLAS:String = "textureAtlas";
		public static const SOUND:String = "sound";
		public static const XML_DOCUMENT:String = "xml";
		public static const OBJECT:String = "object";
		public static const BYTE_ARRAY:String = "byteArray";
		public static const BITMAP_FONT:String = "bitmapFont";
		public static const ASSET_MANAGER:String = "assetManager";

		/** Figures out the asset type string from the type of the given instance. */
		public static function fromAsset(asset:Object):String { return null; }
	}
	
}
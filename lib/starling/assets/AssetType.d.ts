// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

declare namespace starling.assets
{
	/** An enumeration class containing all the asset types supported by the AssetManager. */
	export class AssetType
	{
		public static TEXTURE:string;
		public static TEXTURE_ATLAS:string;
		public static SOUND:string;
		public static XML_DOCUMENT:string;
		public static OBJECT:string;
		public static BYTE_ARRAY:string;
		public static BITMAP_FONT:string;
		public static ASSET_MANAGER:string;

		/** Figures out the asset type string from the type of the given instance. */
		public static fromAsset(asset:any):string;
	}
}

export default starling.assets.AssetType;
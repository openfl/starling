// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import TextureOptions from "./../textures/TextureOptions";

declare namespace starling.assets
{
	/** The description of an asset to be created by an AssetFactory. */
	export class AssetReference
	{
		/** Creates a new instance with the given data, which is typically some kind of file
		 *  reference / URL or an instance of an asset class. If 'data' contains an URL, an
		 *  equivalent value will be assigned to the 'url' property. */
		public constructor(data:any);

		/** The name with which the asset should be added to the AssetManager. */
		public name:string;
		protected get_name():string;
		protected set_name(value:string):string;

		/** The url from which the asset needs to be / has been loaded. */
		public url:string;
		protected get_url():string;
		protected set_url(value:string):string;

		/** The raw data of the asset. This property often contains an URL; when it's passed
		 *  to an AssetFactory, loading has already completed, and the property contains a
		 *  ByteArray with the loaded data. */
		public data:any;
		protected get_data():any;
		protected set_data(value:any):any;

		/** The mime type of the asset, if loaded from a server. */
		public mimeType:string;
		protected get_mimeType():string;
		protected set_mimeType(value:string):string;

		/** The file extension of the asset, if the filename or URL contains one. */
		public extension:string;
		protected get_extension():string;
		protected set_extension(value:string):string;

		/** The TextureOptions describing how to create a texture, if the asset references one. */
		public textureOptions:TextureOptions;
		protected get_textureOptions():TextureOptions;
		protected set_textureOptions(value:TextureOptions):TextureOptions;
	}
}

export default starling.assets.AssetReference;
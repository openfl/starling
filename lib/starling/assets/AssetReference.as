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

	import starling.textures.TextureOptions;

	/**
	 * @externs
	 * The description of an asset to be created by an AssetFactory.
	 */
	public class AssetReference
	{
		/** Creates a new instance with the given data, which is typically some kind of file
		 *  reference / URL or an instance of an asset class. If 'data' contains an URL, an
		 *  equivalent value will be assigned to the 'url' property. */
		public function AssetReference(data:Object){}

		/** The name with which the asset should be added to the AssetManager. */
		public var name:String;
		protected function get_name():String { return null; }
		protected function set_name(value:String):String { return null; }

		/** The url from which the asset needs to be / has been loaded. */
		public var url:String;
		protected function get_url():String { return null; }
		protected function set_url(value:String):String { return null; }

		/** The raw data of the asset. This property often contains an URL; when it's passed
		 *  to an AssetFactory, loading has already completed, and the property contains a
		 *  ByteArray with the loaded data. */
		public var data:Object;
		protected function get_data():Object { return null; }
		protected function set_data(value:Object):Object { return null; }

		/** The mime type of the asset, if loaded from a server. */
		public var mimeType:String;
		protected function get_mimeType():String { return null; }
		protected function set_mimeType(value:String):String { return null; }

		/** The file extension of the asset, if the filename or URL contains one. */
		public var extension:String;
		protected function get_extension():String { return null; }
		protected function set_extension(value:String):String { return null; }

		/** The TextureOptions describing how to create a texture, if the asset references one. */
		public var textureOptions:TextureOptions;
		protected function get_textureOptions():TextureOptions { return null; }
		protected function set_textureOptions(value:TextureOptions):TextureOptions { return null; }
	}
	
}
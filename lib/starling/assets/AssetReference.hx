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

import starling.textures.TextureOptions;

/** The description of an asset to be created by an AssetFactory. */

@:jsRequire("starling/assets/AssetReference", "default")

extern class AssetReference
{
    /** Creates a new instance with the given data, which is typically some kind of file
     *  reference / URL or an instance of an asset class. If 'data' contains an URL, an
     *  equivalent value will be assigned to the 'url' property. */
    public function new(data:Dynamic);

    /** The name with which the asset should be added to the AssetManager. */
    public var name(get, set):String;
    private function get_name():String;
    private function set_name(value:String):String;

    /** The url from which the asset needs to be / has been loaded. */
    public var url(get, set):String;
    private function get_url():String;
    private function set_url(value:String):String;

    /** The raw data of the asset. This property often contains an URL; when it's passed
     *  to an AssetFactory, loading has already completed, and the property contains a
     *  ByteArray with the loaded data. */
    public var data(get, set):Dynamic;
    private function get_data():Dynamic;
    private function set_data(value:Dynamic):Dynamic;

    /** The mime type of the asset, if loaded from a server. */
    public var mimeType(get, set):String;
    private function get_mimeType():String;
    private function set_mimeType(value:String):String;

    /** The file extension of the asset, if the filename or URL contains one. */
    public var extension(get, set):String;
    private function get_extension():String;
    private function set_extension(value:String):String;

    /** The TextureOptions describing how to create a texture, if the asset references one. */
    public var textureOptions(get, set):TextureOptions;
    private function get_textureOptions():TextureOptions;
    private function set_textureOptions(value:TextureOptions):TextureOptions;
}
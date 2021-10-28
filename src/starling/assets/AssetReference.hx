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
class AssetReference
{
    private var _name:String;
    private var _url:String;
    private var _data:Dynamic;
    private var _mimeType:String;
    private var _extension:String;
    private var _textureOptions:TextureOptions;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (AssetReference.prototype, {
            "name": { get: untyped __js__ ("function () { return this.get_name (); }"), set: untyped __js__ ("function (v) { return this.set_name (v); }") },
            "url": { get: untyped __js__ ("function () { return this.get_url (); }"), set: untyped __js__ ("function (v) { return this.set_url (v); }") },
            "data": { get: untyped __js__ ("function () { return this.get_data (); }"), set: untyped __js__ ("function (v) { return this.set_data (v); }") },
            "mimeType": { get: untyped __js__ ("function () { return this.get_mimeType (); }"), set: untyped __js__ ("function (v) { return this.set_mimeType (v); }") },
            "extension": { get: untyped __js__ ("function () { return this.get_extension (); }"), set: untyped __js__ ("function (v) { return this.set_extension (v); }") },
            "textureOptions": { get: untyped __js__ ("function () { return this.get_textureOptions (); }"), set: untyped __js__ ("function (v) { return this.set_textureOptions (v); }") },
            "filename": { get: untyped __js__ ("function () { return this.get_filename (); }") },
        });
        
    }
    #end

    /** Creates a new instance with the given data, which is typically some kind of file
     *  reference / URL or an instance of an asset class. If 'data' contains an URL, an
     *  equivalent value will be assigned to the 'url' property. */
    public function new(data:Dynamic)
    {
        _data = data;
        _textureOptions = new TextureOptions();

        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, String)) _url = cast data;
        else
        {
            var urlProp:Dynamic = Reflect.getProperty(data, "url");
            if(urlProp != null)
                _url = cast urlProp;
        }
    }

    /** The name with which the asset should be added to the AssetManager. */
    public var name(get, set):String;
    private function get_name():String { return _name; }
    private function set_name(value:String):String { return _name = value; }

    /** The url from which the asset needs to be / has been loaded. */
    public var url(get, set):String;
    private function get_url():String { return _url; }
    private function set_url(value:String):String { return _url = value; }

    /** The raw data of the asset. This property often contains an URL; when it's passed
     *  to an AssetFactory, loading has already completed, and the property contains a
     *  ByteArray with the loaded data. */
    public var data(get, set):Dynamic;
    private function get_data():Dynamic { return _data; }
    private function set_data(value:Dynamic):Dynamic { return _data = value; }

    /** The mime type of the asset, if loaded from a server. */
    public var mimeType(get, set):String;
    private function get_mimeType():String { return _mimeType; }
    private function set_mimeType(value:String):String { return _mimeType = value; }

    /** The file extension of the asset, if the filename or URL contains one. */
    public var extension(get, set):String;
    private function get_extension():String { return _extension; }
    private function set_extension(value:String):String { return _extension = value; }

    /** The TextureOptions describing how to create a texture, if the asset references one. */
    public var textureOptions(get, set):TextureOptions;
    private function get_textureOptions():TextureOptions { return _textureOptions; }
    private function set_textureOptions(value:TextureOptions):TextureOptions
    {
        _textureOptions.copyFrom(value);
        return _textureOptions;
    }
}
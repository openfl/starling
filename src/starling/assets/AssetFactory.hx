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
import openfl.Vector;

/** An AssetFactory is responsible for creating a concrete instance of an asset.
 *
 *  <p>The AssetManager contains a list of AssetFactories, registered via 'registerFactory'.
 *  When the asset queue is processed, each factory (sorted by priority) will be asked if it
 *  can handle a certain AssetReference (via the 'canHandle') method. If it can, the 'create'
 *  method will be called, which is responsible for creating at least one asset.</p>
 *
 *  <p>By extending 'AssetFactory' and registering your class at the AssetManager, you can
 *  customize how assets are being created and even add new types of assets.</p>
 */
class AssetFactory
{
    private var _priority:Int;
    private var _mimeTypes:Vector<String>;
    private var _extensions:Vector<String>;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (TextureAtlas.prototype, {
            "priority": { get: untyped __js__ ("function () { return this.get_priority (); }"), set: untyped __js__ ("function (v) { return this.set_priority (v); }") },
        });
        
    }
    #end

    /** Creates a new instance. */
    public function new()
    {
        _mimeTypes = new Vector<String>();
        _extensions = new Vector<String>();
    }

    /** Returns 'true' if this factory can handle the given reference. The default
     *  implementation checks if extension and/or mime type of the reference match those
     *  of the factory. */
    public function canHandle(reference:AssetReference):Bool
    {
        var mimeType:String = reference.mimeType;
        var extension:String = reference.extension;

        var isByteArray:Bool = Std.is(reference.data, #if commonjs ByteArray #else ByteArrayData #end);
        var supportedMimeType:Bool = (mimeType != null && _mimeTypes.indexOf(reference.mimeType.toLowerCase()) != -1);
        var supportedExtension:Bool = (extension != null && _extensions.indexOf(reference.extension.toLowerCase()) != -1);
        
        return isByteArray && (supportedMimeType || supportedExtension);
    }

    /** This method will only be called if 'canHandle' returned 'true' for the given reference.
     *  It's responsible for creating at least one concrete asset and passing it to 'onComplete'.
     *
     *  @param reference   The asset to be created. If a local or remote URL is referenced,
     *                     it will already have been loaded, and 'data' will contain a ByteArray.
     *  @param helper      Contains useful utility methods to be used by the factory. Look
     *                     at the class documentation for more information.
     *  @param onComplete  To be called with the name and asset as parameters when loading
     *                     is successful. <pre>function(name:String, asset:Object):void;</pre>
     *  @param onError     To be called when creation fails for some reason. Do not call
     *                     'onComplete' when that happens. <pre>function(error:String):void</pre>
     */
    public function create(reference:AssetReference, helper:AssetFactoryHelper,
                           onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        // to be implemented by subclasses
    }

    /** Add one or more mime types that identify the supported data types. Used by
     *  'canHandle' to figure out if the factory is suitable for an asset reference. */
    public function addMimeTypes(args:Array<String>):Void
    {
        for (mimeType in args)
        {
            mimeType = mimeType.toLowerCase();

            if (_mimeTypes.indexOf(mimeType) == -1)
                _mimeTypes[_mimeTypes.length] = mimeType;
        }
    }

    /** Add one or more file extensions (without leading dot) that identify the supported data
     *  types. Used by 'canHandle' to figure out if the factory is suitable for an asset
     *  reference. */
    public function addExtensions(args:Array<String>):Void
    {
        for (extension in args)
        {
            extension = extension.toLowerCase();

            if (_extensions.indexOf(extension) == -1)
                _extensions[_extensions.length] = extension;
        }
    }

    /** Returns the mime types this factory supports. */
    public function getMimeTypes(out:Vector<String>=null):Vector<String>
    {
        if(out == null)
            out = new Vector<String>();

        for (i in 0..._mimeTypes.length)
            out[i] = _mimeTypes[i];

        return out;
    }

    /** Returns the file extensions this factory supports. */
    public function getExtensions(out:Vector<String>=null):Vector<String>
    {
        if(out == null)
            out = new Vector<String>();

        for (i in 0..._extensions.length)
            out[i] = _extensions[i];

        return out;
    }

    public var priority(get, set):Int;	//with private + @:allow I get a runtime error in AssetManager.comparePriorities
    private function get_priority():Int { return _priority; }
    private function set_priority(value:Int):Int { return _priority = value; }
}
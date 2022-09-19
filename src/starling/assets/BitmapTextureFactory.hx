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

import haxe.Constraints.Function;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;

import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.textures.TextureOptions;
import starling.utils.ByteArrayUtil;
import starling.utils.Execute;

/** This AssetFactory creates texture assets from bitmaps and image files. */
class BitmapTextureFactory extends AssetFactory
{
    private static var MAGIC_NUMBERS_JPG:Array<Int> = [0xff, 0xd8];
    private static var MAGIC_NUMBERS_PNG:Array<Int> = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    private static var MAGIC_NUMBERS_GIF:Array<Int> = [0x47, 0x49, 0x46, 0x38];
    private static var MAGIC_NUMBERS_WEBP:Array<Int> = [0x52, 0x49, 0x46, 0x46];

    /** Creates a new instance. */
    public function new()
    {
        super();
        addMimeTypes(["image/png", "image/jpg", "image/jpeg", "image/gif" #if html5 , "image/webp" #end ]);
        addExtensions(["png", "jpg", "jpeg", "gif" #if html5 , "webp" #end ]);
    }

    /** @inheritDoc */
    override public function canHandle(reference:AssetReference):Bool
    {
        if (super.canHandle(reference) ||
            #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, Bitmap) || #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, BitmapData))
        {
            return true;
        }
        else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, #if commonjs ByteArray #else ByteArrayData #end))
        {
            var byteData:ByteArray = cast reference.data;
            return ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_PNG) ||
                    ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_JPG) ||
                    ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_GIF)
                    #if html5 || ByteArrayUtil.startsWithBytes(byteData, MAGIC_NUMBERS_WEBP) #end;
        }
        else return false;
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        var texture:Texture = null;
        var url:String = reference.url;
        var data:Dynamic = reference.data;
        var name:String = reference.name;
        var options:TextureOptions = reference.textureOptions;
		var onReady:Function = reference.textureOptions.onReady;
        
        var onBitmapDataCreated:BitmapData->Void = null;
        var createFromBitmapData:BitmapData->Void = null;
        var complete:Texture->Void = null;
        var restoreTexture:ConcreteTexture->Void = null;
        var reload:String->(BitmapData->Void)->Void = null;
        var onReloadError:String->Void = null;
        
        onBitmapDataCreated = function(bitmapData:BitmapData):Void
        {
            helper.executeWhenContextReady(createFromBitmapData, [bitmapData]);
        }
        
        createFromBitmapData = function(bitmapData:BitmapData):Void
        {
            options.onReady = complete;

            try { texture = Texture.fromData(bitmapData, options); }
            catch (e:Dynamic) { onError(e); }

            if (texture != null && url != null) texture.root.onRestore = restoreTexture;
        }

        complete = function(_):Void
        {
			Execute.execute(onReady, [texture]);
            onComplete(name, texture);
        }

        restoreTexture = function(_):Void
        {
            helper.onBeginRestore();

            reload(url, function(bitmapData:BitmapData):Void
            {
                helper.executeWhenContextReady(function():Void
                {
                    try { texture.root.uploadBitmapData(bitmapData); }
                    catch (e:Dynamic) { helper.log("Texture restoration failed: " + e); }

                    helper.onEndRestore();
                });
            });
        }
        
        reload = function(url:String, onComplete:BitmapData->Void):Void
        {
            helper.loadDataFromUrl(url, function(?data:ByteArray, ?mimeType:String, ?name:String, ?extension:String):Void
            {
               createBitmapDataFromByteArray(data, onComplete, onReloadError);
            }, onReloadError);
        }
        
        onReloadError = function(error:String):Void
        {
            helper.log("Texture restoration failed for " + url + ". " + error);
            helper.onEndRestore();
        }
        
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, Bitmap) && cast(data, Bitmap).bitmapData != null)
        {
            onBitmapDataCreated(cast(data, Bitmap).bitmapData);
        }
        else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, BitmapData))
        {
            onBitmapDataCreated(cast data);
        }
        else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, #if commonjs ByteArray #else ByteArrayData #end))
        {
            createBitmapDataFromByteArray(cast data, onBitmapDataCreated, onError);
        }
        
        // prevent closures from keeping references
        reference.data = data = null;
    }

    /** Called by 'create' to convert a ByteArray to a BitmapData.
     *
     *  @param data        A ByteArray that contains image data
     *                     (like the contents of a PNG or JPG file).
     *  @param onComplete  Called with the BitmapData when successful.
     *                     <pre>function(bitmapData:BitmapData):void;</pre>
     *  @param onError     To be called when creation fails for some reason.
     *                     <pre>function(error:String):void</pre>
     */
    private function createBitmapDataFromByteArray(data:ByteArray,
                                                   onComplete:BitmapData->Void, onError:String->Void):Void
    {
        var loader:Loader;
        var loaderInfo:LoaderInfo = null;
        
        var onIoError:IOErrorEvent->Void = null;
        var onLoaderComplete:Dynamic->Void = null;
        var complete:Dynamic->Void = null;
        var cleanup:Void->Void = null;
        
        onIoError = function (event:IOErrorEvent):Void
        {
            cleanup();
            Execute.execute(onError, [event.text]);
        }

        onLoaderComplete = function (event:Dynamic):Void
        {
            complete(cast (event.target.content, Bitmap).bitmapData);
        }

        complete = function (bitmapData:BitmapData):Void
        {
            cleanup();
            Execute.execute(onComplete, [bitmapData]);
        }

        cleanup = function ():Void
        {
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
            loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
        }
        
        loader = new Loader();
        loaderInfo = loader.contentLoaderInfo;
        loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
        loaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
        var loaderContext:LoaderContext = new LoaderContext();
        #if flash
        @:require(flash11) loaderContext.imageDecodingPolicy = flash.system.ImageDecodingPolicy.ON_LOAD;
        #end
        loader.loadBytes(data, loaderContext);
    }
}

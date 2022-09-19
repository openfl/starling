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
import openfl.utils.ByteArray;
import starling.utils.Execute;

import starling.textures.AtfData;
import starling.textures.Texture;

/** This AssetFactory creates texture assets from ATF files. */
class AtfTextureFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new()
    {
        super();
        addExtensions(["atf"]); // not used, actually, since we can parse the ATF header, anyway.
    }

    /** @inheritDoc */
    override public function canHandle(reference:AssetReference):Bool
    {
        return (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, #if commonjs ByteArray #else ByteArrayData #end) && AtfData.isAtfData(cast reference.data));
    }

    /** @inheritDoc */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        var onReloadError:String->Void = null;
        var createTexture:Void->Void = null;
        
        onReloadError = function (error:String):Void
        {
            helper.log("Texture restoration failed for " + reference.url + ". " + error);
            helper.onEndRestore();
        }
        
        createTexture = function ():Void
        {
            var texture:Texture = null;
            
			var onReady:Function = reference.textureOptions.onReady;
            reference.textureOptions.onReady = function(_):Void
            {
				Execute.execute(onReady, [texture]);
                onComplete(reference.name, texture);
            };
            
            var url:String = reference.url;

            try { texture = Texture.fromData(reference.data, reference.textureOptions); }
            catch (e:Dynamic) { onError(e); }

            if (url != null && texture != null)
            {
                texture.root.onRestore = function(_):Void
                {
                    helper.onBeginRestore();
                    helper.loadDataFromUrl(url, function(?data:ByteArray, ?mimeType:String, ?name:String, ?extension:String):Void
                    {
                        helper.executeWhenContextReady(function():Void
                        {
                            try { texture.root.uploadAtfData(data); }
                            catch (e:Dynamic) { helper.log("Texture restoration failed: " + e); }

                            helper.onEndRestore();
                        });
                    }, onReloadError);
                };
            }
        
            reference.data = null; // prevent closures from keeping reference
        }

        helper.executeWhenContextReady(createTexture);
    }
}

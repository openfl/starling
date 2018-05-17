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
import starling.utils.Execute;
import starling.utils.SystemUtil;
import openfl.utils.ByteArray;

/** A helper class that's passed to an AssetFactory's "create" method. */

@:jsRequire("starling/assets/AssetFactoryHelper", "default")

extern class AssetFactoryHelper
{
    /** Forwarded to the AssetManager's method with the same name. */
    public function getNameFromUrl(url:String):String;

    /** Forwarded to the AssetManager's method with the same name. */
    public function getExtensionFromUrl(url:String):String;

    /** Accesses a URL (local or remote) and passes the loaded ByteArray to the
     *  'onComplete' callback - or executes 'onError' when the data can't be loaded.
     *
     *  @param url         Either a String or an URLRequest, or an arbitrary object containing
     *                     an 'url' property.
     *  @param onComplete  function(data:ByteArray, mimeType:String):void;
     *  @param onError     function(error:String):void;
     */
    public function loadDataFromUrl(url:Dynamic, onComplete:ByteArray->?String->Void, onError:String->Void):Void;

    /** Adds a method to be called by the AssetManager when the queue has finished processing.
     *  Useful e.g. if assets depend on other assets (like an atlas XML depending on the atlas
     *  texture).
     *
     *  @param processor  function(manager:AssetManager):void;
     *  @param priority   Processors with a higher priority will be called first.
     *                    The default processor for texture atlases is called with a
     *                    priority of '100', others with '0'.
     */
    public function addPostProcessor(processor:AssetManager->Void, priority:Int=0):Void;

    /** Textures are required to call this method when they begin their restoration process
     *  after a context loss. */
    public function onBeginRestore():Void;

    /** Textures are required to call this method when they have finished their restoration
     *  process after a context loss. */
    public function onEndRestore():Void;

    /** Forwarded to the AssetManager's method with the same name. */
    public function log(message:String):Void;

    /** Adds additional assets to the AssetManager. To be called when the factory
     *  creates more than one asset. */
    public function addComplementaryAsset(name:String, asset:Dynamic, type:String=null):Void;

    /** Delay the execution of 'call' until it's allowed. (On mobile, the context
     *  may not be accessed while the application is in the background.)
     */
    public function executeWhenContextReady(call:Function, ?args:Array<Dynamic>):Void;
}
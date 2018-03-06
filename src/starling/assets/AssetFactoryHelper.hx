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
class AssetFactoryHelper
{
    private var _dataLoader:DataLoader;
    private var _getNameFromUrlFunc:String->String;
    private var _getExtensionFromUrlFunc:String->String;
    private var _addPostProcessorFunc:(AssetManager->Void)->Int->Void;
    private var _addAssetFunc:String->Dynamic->String->Void;
    private var _onRestoreFunc:Bool->Void;
    private var _logFunc:String->Void;

    /** @private */
    @:allow(starling) private function new()
    { }

    /** Forwarded to the AssetManager's method with the same name. */
    public function getNameFromUrl(url:String):String
    {
        if (_getNameFromUrlFunc != null) return _getNameFromUrlFunc(url);
        else return "";
    }

    /** Forwarded to the AssetManager's method with the same name. */
    public function getExtensionFromUrl(url:String):String
    {
        if (_getExtensionFromUrlFunc != null) return _getExtensionFromUrlFunc(url);
        else return "";
    }

    /** Accesses a URL (local or remote) and passes the loaded ByteArray to the
     *  'onComplete' callback - or executes 'onError' when the data can't be loaded.
     *
     *  @param url         Either a String or an URLRequest, or an arbitrary object containing
     *                     an 'url' property.
     *  @param onComplete  function(data:ByteArray, mimeType:String):void;
     *  @param onError     function(error:String):void;
     */
    public function loadDataFromUrl(url:Dynamic, onComplete:ByteArray->?String->Void, onError:String->Void):Void
    {
        if (_dataLoader != null) _dataLoader.load(url, onComplete, onError);
    }

    /** Adds a method to be called by the AssetManager when the queue has finished processing.
     *  Useful e.g. if assets depend on other assets (like an atlas XML depending on the atlas
     *  texture).
     *
     *  @param processor  function(manager:AssetManager):void;
     *  @param priority   Processors with a higher priority will be called first.
     *                    The default processor for texture atlases is called with a
     *                    priority of '100', others with '0'.
     */
    public function addPostProcessor(processor:AssetManager->Void, priority:Int=0):Void
    {
        if (_addPostProcessorFunc != null) _addPostProcessorFunc(processor, priority);
    }

    /** Textures are required to call this method when they begin their restoration process
     *  after a context loss. */
    public function onBeginRestore():Void
    {
        if (_onRestoreFunc != null) _onRestoreFunc(false);
    }

    /** Textures are required to call this method when they have finished their restoration
     *  process after a context loss. */
    public function onEndRestore():Void
    {
        if (_onRestoreFunc != null) _onRestoreFunc(true);
    }

    /** Forwarded to the AssetManager's method with the same name. */
    public function log(message:String):Void
    {
        if (_logFunc != null) _logFunc(message);
    }

    /** Adds additional assets to the AssetManager. To be called when the factory
     *  creates more than one asset. */
    public function addComplementaryAsset(name:String, asset:Dynamic, type:String=null):Void
    {
        if (_addAssetFunc != null) _addAssetFunc(name, asset, type);
    }

    /** Delay the execution of 'call' until it's allowed. (On mobile, the context
     *  may not be accessed while the application is in the background.)
     */
    public function executeWhenContextReady(call:Function, ?args:Array<Dynamic>):Void
    {
        // On mobile, it is not allowed / endorsed to make stage3D calls while the app
        // is in the background. Thus, we pause execution if that's the case.

        if (SystemUtil.isDesktop) 
            Execute.execute(call, args);
        else
            SystemUtil.executeWhenApplicationIsActive(call, args);
    }

    /** @private */
    @:allow(starling) private var getNameFromUrlFunc(never, set):String->String;
    private function set_getNameFromUrlFunc(value:String->String):String->String { return _getNameFromUrlFunc = value; }

    /** @private */
    @:allow(starling) private var getExtensionFromUrlFunc(never, set):String->String;
    private function set_getExtensionFromUrlFunc(value:String->String):String->String { return _getExtensionFromUrlFunc = value; }

    /** @private */
    @:allow(starling) private var dataLoader(never, set):DataLoader;
    private function set_dataLoader(value:DataLoader):DataLoader { return _dataLoader = value; }

    /** @private */
    @:allow(starling) private var logFunc(never, set):String->Void ;
    private function set_logFunc(value:String->Void):String->Void { return _logFunc = value; }

    /** @private */
    @:allow(starling) private var addAssetFunc(never, set):String->Dynamic->String->Void;
    private function set_addAssetFunc(value:String->Dynamic->String->Void):String->Dynamic->String->Void { return _addAssetFunc = value; }

    /** @private */
    @:allow(starling) private var onRestoreFunc(never, set):Bool->Void;
    private function set_onRestoreFunc(value:Bool->Void):Bool->Void { return _onRestoreFunc = value; }

    /** @private */
    @:allow(starling) private var addPostProcessorFunc(never, set):(AssetManager->Void)->Int->Void;
    private function set_addPostProcessorFunc(value:(AssetManager->Void)->Int->Void):(AssetManager->Void)->Int->Void { return _addPostProcessorFunc = value; }
}
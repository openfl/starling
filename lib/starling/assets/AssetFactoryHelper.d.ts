// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import AssetManager from "./AssetManager";
import Execute from "starling/utils/Execute";
import SystemUtil from "starling/utils/SystemUtil";
import ByteArray from "openfl/utils/ByteArray";

declare namespace starling.assets
{
	/** A helper class that's passed to an AssetFactory's "create" method. */
	export class AssetFactoryHelper
	{
		/** Forwarded to the AssetManager's method with the same name. */
		public getNameFromUrl(url:string):string;
	
		/** Forwarded to the AssetManager's method with the same name. */
		public getExtensionFromUrl(url:string):string;
	
		/** Accesses a URL (local or remote) and passes the loaded ByteArray to the
		 *  'onComplete' callback - or executes 'onError' when the data can't be loaded.
		 *
		 *  @param url         a string containing an URL.
		 *  @param onComplete  function(data:ByteArray, mimeType:string):void;
		 *  @param onError     function(error:string):void;
		 */
		public loadDataFromUrl(url:string, onComplete:(data?:ByteArray, mimeType?:string, name?:string, extension?:string)=>void, onError:(string)=>void):void;
	
		/** Adds a method to be called by the AssetManager when the queue has finished processing.
		 *  Useful e.g. if assets depend on other assets (like an atlas XML depending on the atlas
		 *  texture).
		 *
		 *  @param processor  function(manager:AssetManager):void;
		 *  @param priority   Processors with a higher priority will be called first.
		 *                    The default processor for texture atlases is called with a
		 *                    priority of '100', others with '0'.
		 */
		public addPostProcessor(processor:(AssetManager)=>void, priority?:number):void;
	
		/** Textures are required to call this method when they begin their restoration process
		 *  after a context loss. */
		public onBeginRestore():void;
	
		/** Textures are required to call this method when they have finished their restoration
		 *  process after a context loss. */
		public onEndRestore():void;
	
		/** Forwarded to the AssetManager's method with the same name. */
		public log(message:string):void;
	
		/** Adds additional assets to the AssetManager. To be called when the factory
		 *  creates more than one asset. */
		public addComplementaryAsset(name:string, asset:any, type?:string):void;
	
		/** Delay the execution of 'call' until it's allowed. (On mobile, the context
		 *  may not be accessed while the application is in the background.)
		 */
		public executeWhenContextReady(call:Function, args?:Array<any>):void;
	}
}

export default starling.assets.AssetFactoryHelper;
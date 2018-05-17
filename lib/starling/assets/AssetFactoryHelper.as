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

	import starling.utils.Execute;
	import starling.utils.SystemUtil;
	import openfl.utils.ByteArray;

	/**
	 * @externs
	 * A helper class that's passed to an AssetFactory's "create" method.
	 */
	public class AssetFactoryHelper
	{
		/** Forwarded to the AssetManager's method with the same name. */
		public function getNameFromUrl(url:String):String { return null; }

		/** Forwarded to the AssetManager's method with the same name. */
		public function getExtensionFromUrl(url:String):String { return null; }

		/** Accesses a URL (local or remote) and passes the loaded ByteArray to the
		 *  'onComplete' callback - or executes 'onError' when the data can't be loaded.
		 *
		 *  @param url         Either a String or an URLRequest, or an arbitrary object containing
		 *                     an 'url' property.
		 *  @param onComplete  function(data:ByteArray, mimeType:String):void;
		 *  @param onError     function(error:String):void;
		 */
		public function loadDataFromUrl(url:Object, onComplete:Function, onError:Function):void {}

		/** Adds a method to be called by the AssetManager when the queue has finished processing.
		 *  Useful e.g. if assets depend on other assets (like an atlas XML depending on the atlas
		 *  texture).
		 *
		 *  @param processor  function(manager:AssetManager):void;
		 *  @param priority   Processors with a higher priority will be called first.
		 *                    The default processor for texture atlases is called with a
		 *                    priority of '100', others with '0'.
		 */
		public function addPostProcessor(processor:Function, priority:int=0):void {}

		/** Textures are required to call this method when they begin their restoration process
		 *  after a context loss. */
		public function onBeginRestore():void {}

		/** Textures are required to call this method when they have finished their restoration
		 *  process after a context loss. */
		public function onEndRestore():void {}

		/** Forwarded to the AssetManager's method with the same name. */
		public function log(message:String):void {}

		/** Adds additional assets to the AssetManager. To be called when the factory
		 *  creates more than one asset. */
		public function addComplementaryAsset(name:String, asset:Object, type:String=null):void {}

		/** Delay the execution of 'call' until it's allowed. (On mobile, the context
		 *  may not be accessed while the application is in the background.)
		 */
		public function executeWhenContextReady(call:Function, args:Array = null):void {}
	}
	
}
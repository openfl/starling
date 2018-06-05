// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import ByteArray from "openfl/utils/ByteArray";

declare namespace starling.assets
{
	/** Loads binary data from a local or remote URL with a very simple callback system.
	 *
	 *  <p>The DataLoader is used by the AssetManager to load any local or remote data.
	 *  Its single purpose is to get the binary data that's stored at a specific URL.</p>
	 *
	 *  <p>You can use this class for your own purposes (as an easier to use 'URLLoader'
	 *  alternative), or you can extend the class to modify the AssetManager's behavior.
	 *  E.g. you could extend this class to add a caching mechanism for remote assets.
	 *  Assign an instance of your extended class to the AssetManager's <code>dataLoader</code>
	 *  property.</p>
	 */
	export class DataLoader
	{
		/** Creates a new DataLoader instance. */
		public constructor();

		/** Loads the binary data from a specific URL. Always supply both 'onComplete' and
		 *  'onError' parameters; in case of an error, only the latter will be called.
		 *
		 *  <p>The 'onComplete' callback may have up to four parameters, all of them being optional.
		 *  If you pass a callback that just takes zero or one, it will work just as well. The
		 *  additional parameters may be used to describe the name and type of the downloaded
		 *  data. They are not provided by the base class, but the AssetManager will check
		 *  if they are available.</p>
		 *
		 * @param url          a String containing an URL.
		 * @param onComplete   will be called when the data has been loaded.
		 * <code>function(data:ByteArray, mimeType:string, name:string, extension:string):void</code>
		 * @param onError      will be called in case of an error. The 2nd parameter is optional.
		 *                     <code>function(error:string, httpStatus:number):void</code>
		 * @param onProgress   will be called multiple times with the current load ratio (0-1).
		 *                     <code>function(ratio:Number):void</code>
		 */
		public load(url:string, onComplete:(data?:ByteArray, mimeType?:string, name?:string, extension?:string)=>void,
							onError:(string)=>void, onProgress?:(number)=>void):void;

		/** Aborts all current load operations. The loader can still be used, though. */
		public close():void;
	}
}

export default starling.assets.DataLoader;
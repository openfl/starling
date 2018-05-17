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

	import openfl.utils.ByteArray;

	/**
	 * @externs
	 * This AssetFactory forwards ByteArrays to the AssetManager. It's the fallback when
	 *  no other factory can handle an asset reference (default priority: -100).
	 */
	public class ByteArrayFactory extends AssetFactory
	{
		/** Creates a new instance. */
		public function ByteArrayFactory();
	}
	
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils {

	import openfl.utils.ByteArray;
	import openfl.errors.RangeError;

	import starling.errors.AbstractClassError;

	/**
	 * @externs
	 */
	public class ByteArrayUtil
	{
		/** Figures out if a byte array starts with the UTF bytes of a certain string. If the
		 *  array starts with a 'BOM', it is ignored; so are leading zeros and whitespace. */
		public static function startsWithString(bytes:ByteArray, string:String):Boolean { return false; }

		/** Compares the range of bytes within two byte arrays. */
		public static function compareByteArrays(a:ByteArray, indexA:int,
												b:ByteArray, indexB:int,
												numBytes:int=-1):Boolean { return false; }
	}
	
}
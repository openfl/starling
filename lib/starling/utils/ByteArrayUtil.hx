// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import flash.utils.ByteArray;
import openfl.errors.RangeError;

import starling.errors.AbstractClassError;

@:jsRequire("starling/utils/ByteArrayUtil", "default")

extern class ByteArrayUtil
{
    /** @private */
    // public function new() { throw new AbstractClassError(); }

    /** Figures out if a byte array starts with the UTF bytes of a certain string. If the
     *  array starts with a 'BOM', it is ignored; so are leading zeros and whitespace. */
    public static function startsWithString(bytes:ByteArray, string:String):Bool;

    /** Compares the range of bytes within two byte arrays. */
    public static function compareByteArrays(a:ByteArray, indexA:Int,
                                             b:ByteArray, indexB:Int,
                                             numBytes:Int=-1):Bool;
}
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

import openfl.utils.ByteArray;
import openfl.errors.RangeError;

import starling.errors.AbstractClassError;

/** A utility class containing methods related to the ByteArray class. */
class ByteArrayUtil
{
    /** @private */
    // public function new() { throw new AbstractClassError(); }

    /** Figures out if a byte array starts with the UTF bytes of a certain string. If the
     *  array starts with a 'BOM', it is ignored; so are leading zeros and whitespace. */
    public static function startsWithString(bytes:ByteArray, string:String):Bool
    {
        var start:Int = 0;
        var length:Int = bytes.length;

        var wantedBytes:ByteArray = new ByteArray();
        wantedBytes.writeUTFBytes(string);

        // recognize BOMs

        #if commonjs
        if (length >= 4 &&
            (bytes.get(0) == 0x00 && bytes.get(1) == 0x00 && bytes.get(2) == 0xfe && bytes.get(3) == 0xff) ||
            (bytes.get(0) == 0xff && bytes.get(1) == 0xfe && bytes.get(2) == 0x00 && bytes.get(3) == 0x00))
        {
            start = 4; // UTF-32
        }
        else if (length >= 3 && bytes.get(0) == 0xef && bytes.get(1) == 0xbb && bytes.get(2) == 0xbf)
        {
            start = 3; // UTF-8
        }
        else if (length >= 2 &&
            (bytes.get(0) == 0xfe && bytes.get(1) == 0xff) || (bytes.get(0) == 0xff && bytes.get(1) == 0xfe))
        {
            start = 2; // UTF-16
        }

        for (i in start...length)
        {
            var byte:Int = bytes.get(i);
            if (byte != 0 && byte != 10 && byte != 13 && byte != 32) // null, \n, \r, space
                return compareByteArrays(bytes, i, wantedBytes, 0, wantedBytes.length);
        }
        #else
        if (length >= 4 &&
            (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0xfe && bytes[3] == 0xff) ||
            (bytes[0] == 0xff && bytes[1] == 0xfe && bytes[2] == 0x00 && bytes[3] == 0x00))
        {
            start = 4; // UTF-32
        }
        else if (length >= 3 && bytes[0] == 0xef && bytes[1] == 0xbb && bytes[2] == 0xbf)
        {
            start = 3; // UTF-8
        }
        else if (length >= 2 &&
            (bytes[0] == 0xfe && bytes[1] == 0xff) || (bytes[0] == 0xff && bytes[1] == 0xfe))
        {
            start = 2; // UTF-16
        }

        for (i in start...length)
        {
            var byte:Int = bytes[i];
            if (byte != 0 && byte != 10 && byte != 13 && byte != 32) // null, \n, \r, space
                return compareByteArrays(bytes, i, wantedBytes, 0, wantedBytes.length);
        }
        #end

        return false;
    }
    
    /** Figures out if a byte array starts with the given bytes.
     *  Pass an array that contains integers in the range 0-255. */
    public static function startsWithBytes(byteArray:ByteArray, firstBytes:Array<Int>):Bool
    {
        if ((firstBytes.length : UInt) > byteArray.length) return false;

        var len = firstBytes.length;
        #if commonjs
         for (i in 0...len)
            if (byteArray.get(i) != firstBytes[i]) return false;
        #else
        for (i in 0...len)
            if (byteArray[i] != firstBytes[i]) return false;
        #end

        return true;
    }

    /** Compares the range of bytes within two byte arrays. */
    public static function compareByteArrays(a:ByteArray, indexA:Int,
                                             b:ByteArray, indexB:Int,
                                             numBytes:Int=-1):Bool
    {
        var b1:Int = indexA + numBytes - a.length;
        var b2:Int = indexB + numBytes - b.length;
        
        if (numBytes < 0)
            numBytes = Std.int(MathUtil.min(a.length - indexA, b.length - indexB));
        else if (b1 > 0 || b2 > 0 )
            throw new RangeError();

        #if commonjs
        for (i in 0...numBytes)
            if (a.get(indexA + i) != b.get(indexB + i)) return false;
        #else
        for (i in 0...numBytes)
            if (a[indexA + i] != b[indexB + i]) return false;
        #end

        return true;
    }
}
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
import starling.errors.AbstractClassError;

/** A utility class containing methods related to the Vector class.
 *
 *  <p>Many methods of the Vector class cause the creation of temporary objects, which is
 *  problematic for any code that repeats very often. The utility methods in this class
 *  can be used to avoid that.</p> */
class VectorUtil
{
    /** @private */
    public function new() { throw new AbstractClassError(); }

    /** Inserts a value into the 'int'-Vector at the specified index. Supports negative
     *  indices (counting from the end); gaps will be filled up with zeroes. */
    public static function insertIntAt(vector:Array<Int>, index:Int, value:Int):Void
    {
        var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length + 1;
        if (index < 0) index = 0;

        //for (i = index - 1; i >= length; --i)
        i = index - 1;
        while(i >= length)
        {
            vector[i] = 0;
            --i;
        }

        //for (i = length; i > index; --i)
        i = length;
        while(i > index)
        {
            vector[i] = vector[i-1];
            --i;
        }

        vector[index] = value;
    }

    /** Removes the value at the specified index from the 'int'-Vector. Pass a negative
     *  index to specify a position relative to the end of the vector. */
    public static function removeIntAt(vector:Array<Int>, index:Int):Int
    {
        //var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length;
        if (index < 0) index = 0; else if (index >= length) index = length - 1;

        var value:Int = vector[index];

        //for (i = index+1; i < length; ++i)
        for(i in index + 1 ... length)
            vector[i-1] = vector[i];

        ArrayUtil.resize(vector, vector.length - 1, 0);
        return value;
    }

    /** Inserts a value into the 'uint'-Vector at the specified index. Supports negative
     *  indices (counting from the end); gaps will be filled up with zeroes. */
    public static function insertUnsignedIntAt(vector:Array<UInt>, index:Int, value:UInt):Void
    {
        var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length + 1;
        if (index < 0) index = 0;

        //for (i = index - 1; i >= length; --i)
        i = index - 1;
        while(i >= length)
        {
            vector[i] = 0;
           --i;
        }

        //for (i = length; i > index; --i)
        i = length;
        while(i > index)
        {
            vector[i] = vector[i-1];
            --i;
        }

        vector[index] = value;
    }

    /** Removes the value at the specified index from the 'int'-Vector. Pass a negative
     *  index to specify a position relative to the end of the vector. */
    public static function removeUnsignedIntAt(vector:Array<UInt>, index:Int):UInt
    {
        //var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length;
        if (index < 0) index = 0; else if (index >= length) index = length - 1;

        var value:UInt = vector[index];

        //for (i = index+1; i < length; ++i)
        for(i in index + 1 ... length)
            vector[i-1] = vector[i];

        ArrayUtil.resize(vector, vector.length - 1, 0);
        return value;
    }

    /** Inserts a value into the 'Number'-Vector at the specified index. Supports negative
     *  indices (counting from the end); gaps will be filled up with <code>NaN</code> values. */
    public static function insertNumberAt(vector:Array<Float>, index:Int, value:Float):Void
    {
        var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length + 1;
        if (index < 0) index = 0;

        //for (i = index - 1; i >= length; --i)
        i = index - 1;
        while(i >= length)
        {
            vector[i] = Math.NaN;
            --i;
        }

        //for (i = length; i > index; --i)
        i = length;
        while(i > index)
        {
            vector[i] = vector[i-1];
            --i;
        }

        vector[index] = value;
    }

    /** Removes the value at the specified index from the 'Number'-Vector. Pass a negative
     *  index to specify a position relative to the end of the vector. */
    public static function removeNumberAt(vector:Array<Float>, index:Int):Float
    {
        //var i:Int;
        var length:UInt = vector.length;

        if (index < 0) index += length;
        if (index < 0) index = 0; else if (index >= length) index = length - 1;

        var value:Float = vector[index];

        //for (i = index+1; i < length; ++i)
        for(i in index + 1 ... length)
            vector[i-1] = vector[i];

        ArrayUtil.resize(vector, vector.length - 1, 0);
        return value;
    }
}

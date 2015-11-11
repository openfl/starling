// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2015 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
import starling.errors.AbstractClassError;
import openfl.Vector;

/** A utility class containing methods related to the Array class.
 *
 *  <p>Many methods of the Array class cause the creation of temporary objects, which is
 *  problematic for any code that repeats very often. The utility methods in this class
 *  can be used to avoid that.</p> */
class ArrayUtil
{
    /** @private */
    public function new() { throw new AbstractClassError(); }
    
    public static function resize<T>(arr:Array<T>, newLength:Int, defaultValue:T = null):Void
    {
        var length:Int = arr.length;
        if (newLength < length)
            arr.splice(newLength, length - newLength);
        else if (newLength > length)
        {
            for (i in length ... newLength)
                arr[i] = defaultValue;
        }
    }
    
    public static function clear<T>(arr:Array<T>)
    {
        arr.splice(0, arr.length);
    }

    /** Inserts an element into the array at the specified index.
     *  You can use a negative integer to specify a position relative to the end of the
     *  array (for example, -1 will insert at the very end). If <code>index</code> is
     *  higher than the array length, gaps are filled up with <code>null</code> values. */
    public static function insertAt<T>(array:Array<T>, index:Int, object:T):Void
    {
        var i:Int;
        var length:Int = array.length;

        if (index < 0) index += length + 1;
        if (index < 0) index = 0;

        //for (i = index - 1; i >= length; --i)
        i = index - 1;
        while (i >= length)
        {
            array[i] = null;
            --i;
        }

        //for (i = length; i > index; --i)
        i = length;
        while (i > index)
        {
            array[i] = array[i-1];
            --i;
        }

        array[index] = object;
    }

    /** Removes the element at the specified index from the array.
     *  You can use a negative integer to specify a position relative to the end of the
     *  array (for example, -1 will remove the last element). */
    public static function removeAt<T>(array:Array<T>, index:Int):T
    {
        var i:Int;
        var length:Int = array.length;

        if (index < 0) index += length;
        if (index < 0) index = 0; else if (index >= length) index = length - 1;

        var object:T = array[index];

        //for (i = index+1; i < length; ++i)
        i = index + 1;
        while (i < length)
        {
            array[i-1] = array[i];
            ++i;
        }

        ArrayUtil.resize(array, array.length - 1);
        return object;
    }
}
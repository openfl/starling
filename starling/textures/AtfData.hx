// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;
import flash.display3D.Context3DTextureFormat;
import flash.utils.ByteArray;
import openfl.errors.ArgumentError;
import openfl.errors.Error;

/** A parser for the ATF data format. */
class AtfData
{
    private var mFormat:Context3DTextureFormat;
    private var mWidth:Int;
    private var mHeight:Int;
    private var mNumTextures:Int;
    private var mData:ByteArray;
    
    /** Create a new instance by parsing the given byte array. */
    public function new(data:ByteArray)
    {
        if (!isAtfData(data)) throw new ArgumentError("Invalid ATF data");
        
        if (data.__get(6) == 255) data.position = 12; // new file version
        else                data.position =  6; // old file version
        
        switch (data.readUnsignedByte())
        {
            case 0, 1: mFormat = Context3DTextureFormat.BGRA;
            case 2, 3: mFormat = Context3DTextureFormat.COMPRESSED;
            case 4, 5: mFormat = Context3DTextureFormat.COMPRESSED_ALPHA; // explicit string to stay compatible 
                                                        // with older versions
            default: throw new Error("Invalid ATF format");
        }
        
        mWidth = Std.int(Math.pow(2, data.readUnsignedByte())); 
        mHeight = Std.int(Math.pow(2, data.readUnsignedByte()));
        mNumTextures = data.readUnsignedByte();
        mData = data;
        
        // version 2 of the new file format contains information about
        // the "-e" and "-n" parameters of png2atf
        
        if (data.__get(5) != 0 && data.__get(6) == 255)
        {
            var emptyMipmaps:Bool = (data.__get(5) & 0x01) == 1;
            var numTextures:Int  = data.__get(5) >> 1 & 0x7f;
            mNumTextures = emptyMipmaps ? 1 : numTextures;
        }
    }
    
    public static function isAtfData(data:ByteArray):Bool
    {
        if (data.length < 3) return false;
        else
        {
            var signature:String = "";
            for(i in 0 ... 3)
                signature += String.fromCharCode(data.__get(i));
            return signature == "ATF";
        }
    }
    
    public var format(get, never):Context3DTextureFormat;
    private function get_format():Context3DTextureFormat { return mFormat; }
    public var width(get, never):Int;
    private function get_width():Int { return mWidth; }
    public var height(get, never):Int;
    private function get_height():Int { return mHeight; }
    public var numTextures(get, never):Int;
    private function get_numTextures():Int { return mNumTextures; }
    public var data(get, never):ByteArray;
    private function get_data():ByteArray { return mData; }
}
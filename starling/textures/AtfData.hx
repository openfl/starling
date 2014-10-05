// =================================================================================================
//
//	Starling Framework
//	Copyright 2012 Gamua OG. All Rights Reserved.
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
    private var mFormat:String;
    private var mWidth:Int;
    private var mHeight:Int;
    private var mNumTextures:Int;
    private var mData:ByteArray;
    
    /** Create a new instance by parsing the given byte array. */
    public function new(data:ByteArray)
    {
        if (!isAtfData(data)) throw new ArgumentError("Invalid ATF data");
        
        if (data[6] == 255) data.position = 12; // new file version
        else                data.position =  6; // old file version
        
        switch (data.readUnsignedByte())
        {
            case 0, 1: mFormat = "bgra";
            case 2, 3: mFormat = "compressed";
            case 4, 5: mFormat = "compressedAlpha"; // explicit string to stay compatible 
                                                        // with older versions
            default: throw new Error("Invalid ATF format");
        }
        
        mWidth = Std.int(Math.pow(2, data.readUnsignedByte())); 
        mHeight = Std.int(Math.pow(2, data.readUnsignedByte()));
        mNumTextures = data.readUnsignedByte();
        mData = data;
        
        // version 2 of the new file format contains information about
        // the "-e" and "-n" parameters of png2atf
        
        if (data[5] != 0 && data[6] == 255)
        {
            var emptyMipmaps:Bool = (data[5] & 0x01) == 1;
            var numTextures:Int  = data[5] >> 1 & 0x7f;
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
                signature += String.fromCharCode(data[i]);
            return signature == "ATF";
        }
    }
    
    public var format(get, never):String;
    private function get_format():String { return mFormat; }
    public var width(get, never):Int;
    private function get_width():Int { return mWidth; }
    public var height(get, never):Int;
    private function get_height():Int { return mHeight; }
    public var numTextures(get, never):Int;
    private function get_numTextures():Int { return mNumTextures; }
    public var data(get, never):ByteArray;
    private function get_data():ByteArray { return mData; }
}
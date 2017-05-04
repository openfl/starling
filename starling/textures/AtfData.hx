// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import flash.display3D.Context3DTextureFormat;
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.utils.ByteArray;

/** A parser for the ATF data format. */
class AtfData
{
    private var mFormat:Context3DTextureFormat;
    private var __width:Int;
    private var __height:Int;
    private var __numTextures:Int;
    private var __isCubeMap:Bool;
    private var mData:ByteArray;
    
    /** Create a new instance by parsing the given byte array. */
    public function new(data:ByteArray)
    {
        if (!isAtfData(data)) throw new ArgumentError("Invalid ATF data");
        
        if (data[6] == 255) data.position = 12; // new file version
        else                data.position =  6; // old file version

        var format:UInt = data.readUnsignedByte();
        switch (format & 0x7f)
        {
            case  0, 1: mFormat = Context3DTextureFormat.BGRA;
            case 12, 2, 3: mFormat = Context3DTextureFormat.COMPRESSED;
            case 13, 4, 5: mFormat = Context3DTextureFormat.COMPRESSED_ALPHA/*"compressedAlpha"*/; // explicit string for compatibility
            default: throw new Error("Invalid ATF format");
        }
        
        __width = Std.int(Math.pow(2, data.readUnsignedByte())); 
        __height = Std.int(Math.pow(2, data.readUnsignedByte()));
        __numTextures = data.readUnsignedByte();
        __isCubeMap = (format & 0x80) != 0;
        mData = data;
        
        // version 2 of the new file format contains information about
        // the "-e" and "-n" parameters of png2atf
        
        if (data[5] != 0 && data[6] == 255)
        {
            var emptyMipmaps:Bool = (data[5] & 0x01) == 1;
            var nu__textures:Int  = data[5] >> 1 & 0x7f;
            __numTextures = emptyMipmaps ? 1 : nu__textures;
        }
    }

    /** Checks the first 3 bytes of the data for the 'ATF' signature. */
    public static function isAtfData(data:ByteArray):Bool
    {
        if (data.length < 3) return false;
        else
        {
            var signature:String = "";
            for (i in 0...3)
                signature += String.fro__charCode(data[i]);
            return signature == "ATF";
        }
    }

    /** The texture format. @see flash.display3D.textures.Context3DTextureFormat */
    public var format(get, never):Context3DTextureFormat;
    private function get_format():Context3DTextureFormat { return mFormat; }

    /** The width of the texture in pixels. */
    public var width(get, never):Int;
    private function get_width():Int { return __width; }

    /** The height of the texture in pixels. */
    public var height(get, never):Int;
    private function get_height():Int { return __height; }

    /** The number of encoded textures. '1' means that there are no mip maps. */
    public var nu__textures(get, never):Int;
    private function get_nu__textures():Int { return __numTextures; }

    /** Indicates if the ATF data encodes a cube map. Not supported by Starling! */
    public var isCubeMap(get, never):Bool;
    private function get_isCubeMap():Bool { return __isCubeMap; }

    /** The actual byte data, including header. */
    public var data(get, never):ByteArray;
    private function get_data():ByteArray { return mData; }
}
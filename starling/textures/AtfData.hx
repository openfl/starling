// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures
{
import flash.display3D.Context3DTextureFormat;
import flash.utils.ByteArray;

/** A parser for the ATF data format. */
public class AtfData
{
    private var mFormat:String;
    private var mWidth:Int;
    private var mHeight:Int;
    private var mNumTextures:Int;
    private var mIsCubeMap:Bool;
    private var mData:ByteArray;
    
    /** Create a new instance by parsing the given byte array. */
    public function AtfData(data:ByteArray)
    {
        if (!isAtfData(data)) throw new ArgumentError("Invalid ATF data");
        
        if (data[6] == 255) data.position = 12; // new file version
        else                data.position =  6; // old file version

        var format:UInt = data.readUnsignedByte();
        switch (format & 0x7f)
        {
            case  0:
            case  1: mFormat = Context3DTextureFormat.BGRA; break;
            case 12:
            case  2:
            case  3: mFormat = Context3DTextureFormat.COMPRESSED; break;
            case 13:
            case  4:
            case  5: mFormat = "compressedAlpha"; break; // explicit string for compatibility
            default: throw new Error("Invalid ATF format");
        }
        
        mWidth = Math.pow(2, data.readUnsignedByte()); 
        mHeight = Math.pow(2, data.readUnsignedByte());
        mNumTextures = data.readUnsignedByte();
        mIsCubeMap = (format & 0x80) != 0;
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

    /** Checks the first 3 bytes of the data for the 'ATF' signature. */
    public static function isAtfData(data:ByteArray):Bool
    {
        if (data.length < 3) return false;
        else
        {
            var signature:String = String.fromCharCode(data[0], data[1], data[2]);
            return signature == "ATF";
        }
    }

    /** The texture format. @see flash.display3D.textures.Context3DTextureFormat */
    public function get format():String { return mFormat; }

    /** The width of the texture in pixels. */
    public function get width():Int { return mWidth; }

    /** The height of the texture in pixels. */
    public function get height():Int { return mHeight; }

    /** The number of encoded textures. '1' means that there are no mip maps. */
    public function get numTextures():Int { return mNumTextures; }

    /** Indicates if the ATF data encodes a cube map. Not supported by Starling! */
    public function get isCubeMap():Bool { return mIsCubeMap; }

    /** The actual byte data, including header. */
    public function get data():ByteArray { return mData; }
}
}
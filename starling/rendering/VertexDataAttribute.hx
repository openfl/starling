// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.errors.ArgumentError;
/** Holds the properties of a single attribute in a VertexDataFormat instance.
 *  The member variables must never be changed; they are only <code>public</code>
 *  for performance reasons. */
class VertexDataAttribute
{
    #if 0
    private static var FORMAT_SIZES:Map<Context3DVertexBufferFormat, Int> = [
        Context3DVertexBufferFormat.BYTES_4=> 4,
        Context3DVertexBufferFormat.FLOAT_1=> 4,
        Context3DVertexBufferFormat.FLOAT_2=> 8,
        Context3DVertexBufferFormat.FLOAT_3=> 12,
        Context3DVertexBufferFormat.FLOAT_4=> 16
    ];
    #end

    public var name:String;
    public var format:Context3DVertexBufferFormat;
    public var isColor:Bool;
    public var offset:Int; // in bytes
    public var size:Int;   // in bytes

    /** Creates a new instance with the given properties. */
    public function new(name:String, format:Context3DVertexBufferFormat, offset:Int)
    {
        #if 0
        if (!FORMAT_SIZES.exists(format))
            throw new ArgumentError(
                "Invalid attribute format: " + format + ". " +
                "Use one of the following: 'float1'-'float4', 'bytes4'");
        #end

        this.name = name;
        this.format = format;
        this.offset = offset;
        this.size = switch(format)
        {
            case BYTES_4: 4;
            case FLOAT_1: 4;
            case FLOAT_2: 8;
            case FLOAT_3: 12;
            case FLOAT_4: 16;
        }
        this.isColor = name.indexOf("color") != -1 || name.indexOf("Color") != -1;
    }
}

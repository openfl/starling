package starling.utils;
import flash.utils.ByteArray;
import flash.utils.Endian;
import haxe.io.Bytes;
import openfl.utils.ArrayBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray.ByteArrayData;

@:forward(clear, fastReadFloat, fastWriteBytes, fastWriteFloat, readFloat, readUnsignedInt, resize, writeBytes, writeFloat, writeUnsignedInt, bytesAvailable, endian, length, position)
abstract Float32ArrayWrapper(Float32ArrayWrappedData) from Float32ArrayWrappedData to Float32ArrayWrappedData
{
    public function new()
    {
        this = new Float32ArrayWrappedData();
    }
    
    @:noCompletion @:to public inline function toByteArray():ByteArray
    {
        return this.data;
    }
    
    @:noCompletion @:arrayAccess private inline function get(index:Int):Int
    {
        return this.data[index];
    }
    
    @:noCompletion @:arrayAccess private inline function set(index:Int, value:Int):Int
    {
        return this.data[index] = value;
    }
}

class Float32ArrayWrappedData
{
    public var data(default, null):ByteArray;
    private var float32Array:Float32Array;

    public function new()
    {
        data = new ByteArray();
        #if js
        float32Array = new Float32Array(data.toArrayBuffer());
        #end
    }
    
    public inline function clear()
    {
        data.clear();
    }
    
    public #if (js || flash) inline #end function readFloat():Float
    {
        #if js
        data.position += 4;
        return float32Array[Std.int((data.position - 4) / 4)];
        #elseif flash
        return data.readFloat();
        #elseif cpp
        data.position += 4;
        return untyped __global__.__hxcpp_memory_get_float(data.b, data.position - 4);
        #elseif js
        data.position += 4;
        return float32Array[Std.int((data.position - 4) / 4)];
        #else
        data.position += 4;
        return (data:ByteArrayData).getFloat(data.position - 4);
        #end
    }
    
    public inline function readUnsignedInt():UInt
    {
        return data.readUnsignedInt();
    }
    
    #if (cs && unsafe)
    @:unsafe @:skipReflection
    #end
    public #if (!cs && !unsafe) inline #end function writeBytes(bytes:ByteArray, offset:UInt=0, length:UInt=0)
    {
        #if (cs && unsafe)
        @:privateAccess (data:ByteArrayData).__resize (data.position + length);
        untyped __cs__("fixed(byte *dst = this.data.b, src = bytes.b){");
        untyped __cs__("byte *d = dst + this.data.position, s = src + offset.@value");
        for (i in 0 ... length)
        {
            untyped __cs__("*d = *s");
            untyped __cs__("d++;s++");
        }
        untyped __cs__("}");
        this.data.position += length;
        #else
        data.writeBytes(bytes, offset, length);
        #if js
        createFloat32ArrayIfNeeded();
        #end
        #end
    }

    public #if (js || flash) inline #end function writeFloat(value:Float):Void
    {
        #if js
        float32Array[Std.int(data.position / 4)] = value;
        data.position += 4;
        #elseif flash
        data.writeFloat(value);
        #elseif cpp
        untyped __global__.__hxcpp_memory_set_float(data.b, data.position, value);
        data.position += 4;
        #elseif js
        float32Array[Std.int(data.position / 4)] = value;
        data.position += 4;
        #else
        (data:ByteArrayData).setFloat (data.position, value);
        data.position += 4;
        #end
    }
    
    #if (cs && unsafe)
    @:unsafe @:skipReflection
    #end
    public #if (!cs && !unsafe) inline #end function fastReadFloat(ptr:UInt8Ptr):Float
    {
        #if (cs && unsafe)
        var r:Float = untyped __cs__("*(float*)&ptr[data.position]");
        data.position += 4;
        return r;
        #else
        return readFloat();
        #end
    }
    
    #if (cs && unsafe)
    @:unsafe @:skipReflection
    #end
    public #if flash inline #end function fastWriteBytes(ptr:UInt8Ptr, bytes:ByteArray, offset:UInt, length:UInt)
    {
        #if (cs && unsafe)
        
        #if 0
        if (length % 4 != 0)
            throw "length should be multiple of 4";
        #end
        
        untyped __cs__("fixed(byte *src = bytes.b){");
        untyped __cs__("uint *d = (uint*)(ptr + this.data.position), s = (uint*)(src + offset)");
        for (i in 0 ... untyped __cs__("(int)(length / 4)"))
        {
            untyped __cs__("*d = *s");
            untyped __cs__("d++;s++");
        }
        untyped __cs__("}");
        this.data.position += length;
        #elseif flash
        data.writeBytes(bytes, offset, length);
        #elseif js
        @:privateAccess (data:ByteArrayData).b.set(
            (offset == 0 && length == (bytes:ByteArrayData).b.length) ? (bytes:ByteArrayData).b : @:privateAccess (bytes:ByteArrayData).b.subarray(offset, offset + length),
            this.data.position);
        this.data.position += length;
        #else
        (data:ByteArrayData).blit(position, (bytes:ByteArrayData), offset, length);
        this.data.position += length;
        #end
    }
    
    #if (cs && unsafe)
    @:unsafe @:skipReflection
    #end
    public #if (!cs && !unsafe) inline #end function fastWriteFloat(ptr:UInt8Ptr, v:Float):Void
    {
        #if (cs && unsafe)
        untyped __cs__("float *fptr = (float*)(ptr + this.data.position)");
        untyped __cs__("*fptr = (float)v");
        data.position += 4;
        #else
        writeFloat(v);
        #end
    }
    
    public inline function writeUnsignedInt(value:Int):Void
    {
        data.writeUnsignedInt(value);
    }
    
    public inline function resize(value:UInt):Void
    {
        #if flash
        length = value;
        #else
        @:privateAccess (data:ByteArrayData).__resize(value);
        createFloat32ArrayIfNeeded();
        #end
    }
    
    private function createFloat32ArrayIfNeeded():Void
    {
        #if js
        var buffer:ArrayBuffer = data.toArrayBuffer();
        if (buffer != float32Array.buffer)
            float32Array = new Float32Array(buffer, 0, Std.int(buffer.byteLength / 4));
        #end
    }
    
    public var bytesAvailable(get, never):Int;
    @:noCompletion private inline function get_bytesAvailable():Int { return data.bytesAvailable; }
    
    public var endian(get, set):Endian;
    @:noCompletion private inline function get_endian():Endian { return data.endian; }
    @:noCompletion private inline function set_endian(value:Endian):Endian { return data.endian = value; }
    
    public var length(get, set):UInt;
    @:noCompletion private inline function get_length():UInt { return data.length; }
    @:noCompletion private inline function set_length(value:UInt):UInt
    {
        #if js
        data.length = value;
        createFloat32ArrayIfNeeded();
        return value;
        #else
        return data.length = value;
        #end
    }
    
    public var position(get, set):Int;
    @:noCompletion private inline function get_position():Int { return data.position; }
    @:noCompletion private inline function set_position(value:Int):Int { return data.position = value; }
}
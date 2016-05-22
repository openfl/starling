package starling.utils;
import flash.utils.ByteArray;
import flash.utils.Endian;
import haxe.io.Bytes;
import openfl.utils.ArrayBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray.ByteArrayData;

@:forward(clear, readFloat, readUnsignedInt, writeBytes, writeFloat, writeUnsignedInt, bytesAvailable, endian, length, position)
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
        #else
        data.position += 4;
        return (data:ByteArrayData).getFloat(data.position - 4);
        #end
    }
    
    public inline function readUnsignedInt():UInt
    {
        return data.readUnsignedInt();
    }
    
    public inline function writeBytes(bytes:ByteArray, offset:UInt=0, length:UInt=0)
    {
        data.writeBytes(bytes, offset, length);
        #if js
        createFloat32ArrayIfNeeded();
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
        #else
        (data:ByteArrayData).setFloat (data.position, value);
        data.position += 4;
        #end
    }
    
    public inline function writeUnsignedInt(value:Int):Void
    {
        data.writeUnsignedInt(value);
    }
    
    private function createFloat32ArrayIfNeeded():Void
    {
        #if js
        var buffer:ArrayBuffer = data.toArrayBuffer();
        if (data.toArrayBuffer() != float32Array.buffer)
            float32Array = new Float32Array(buffer);
        #end
    }
    
    public var bytesAvailable(get, never):Int;
    @:noCompletion private inline function get_bytesAvailable():Int { return data.bytesAvailable; }
    
    public var endian(get, set):Endian;
    @:noCompletion private inline function get_endian():Endian { return data.endian; }
	@:noCompletion private inline function set_endian(value:Endian):Endian { return data.endian = value; }
    
    public var length(get, set):UInt;
    @:noCompletion private inline function get_length():UInt { return data.length; }
    @:noCompletion private inline function set_length(value:Int):UInt
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
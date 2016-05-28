package starling.utils;
import openfl.utils.ArrayBuffer;
import openfl.utils.ByteArray;
import openfl.utils.ByteArray.ByteArrayData;
import openfl.utils.Endian;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;

@:forward(clear, readUnsignedInt, readUnsignedShort, writeBytes, writeShort, writeUnsignedInt, bytesAvailable, endian, length, position)
abstract Int16ArrayWrapper(Int16ArrayWrappedData) from Int16ArrayWrappedData to Int16ArrayWrappedData
{
    public function new()
    {
        this = new Int16ArrayWrappedData();
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

class Int16ArrayWrappedData
{
    public var data(default, null):ByteArray;
    #if js
    private var int16Array:Int16Array;
    #end

    public function new()
    {
        data = new ByteArray();
        #if js
        int16Array = new Int16Array(data.toArrayBuffer());
        #end
    }
    
    public inline function clear()
    {
        data.clear();
    }
    
    public inline function readUnsignedInt():UInt
    {
        return data.readUnsignedInt();
    }
    
    public inline function readUnsignedShort():UInt
    {
        #if js
        data.position += 2;
        return int16Array[Std.int((data.position - 2) / 2)];
        #else
        return data.readUnsignedShort();
        #end
    }
    
    public inline function writeBytes(bytes:ByteArray, offset:UInt=0, length:UInt=0)
    {
        data.writeBytes(bytes, offset, length);
        #if js
        createInt16ArrayIfNeeded();
        #end
    }
    
    public function writeShort(value:Int):Void
    {
        #if js
        @:privateAccess (data : ByteArrayData).__resize(data.position + 2);
        createInt16ArrayIfNeeded();
        int16Array[Std.int(data.position / 2)] = value;
        data.position += 2;
        #else
        data.writeShort(value);
        #end
    }
    
    public inline function writeUnsignedInt(value:Int):Void
    {
        data.writeUnsignedInt(value);
    }
    
    private function createInt16ArrayIfNeeded():Void
    {
        #if js
        var buffer:ArrayBuffer = data.toArrayBuffer();
        if (buffer != int16Array.buffer)
            int16Array = new Int16Array(buffer);
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
        createInt16ArrayIfNeeded();
        return value;
        #else
        return data.length = value;
        #end
    }
    
    public var position(get, set):Int;
    @:noCompletion private inline function get_position():Int { return data.position; }
    @:noCompletion private inline function set_position(value:Int):Int { return data.position = value; }
}
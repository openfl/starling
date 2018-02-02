package starling.rendering;

import Std;
import starling.utils.StringUtil;
import starling.core.Starling;
import starling.errors.MissingContextError;

@:jsRequire("starling/rendering/IndexData", "default")

extern class IndexData {
	var indexSizeInBytes(get,never) : Int;
	var numIndices(get,set) : Int;
	var numQuads(get,set) : Int;
	var numTriangles(get,set) : Int;
	var rawData(get,never) : openfl.utils.ByteArray;
	var useQuadLayout(get,set) : Bool;
	function new(initialCapacity : Int = 0) : Void;
	function addQuad(a : UInt, b : UInt, c : UInt, d : UInt) : Void;
	function addTriangle(a : UInt, b : UInt, c : UInt) : Void;
	function clear() : Void;
	function clone() : IndexData;
	function copyTo(target : IndexData, targetIndexID : Int = 0, offset : Int = 0, indexID : Int = 0, numIndices : Int = 0) : Void;
	function createIndexBuffer(upload : Bool = false, ?bufferUsage : String) : openfl.display3D.IndexBuffer3D;
	function getIndex(indexID : Int) : Int;
	function offsetIndices(offset : Int, indexID : Int = 0, numIndices : Int = 0) : Void;
	function setIndex(indexID : Int, index : UInt) : Void;
	function toString() : String;
	function toVector(?out : openfl.Vector<UInt>) : openfl.Vector<UInt>;
	function trim() : Void;
	function uploadToIndexBuffer(buffer : openfl.display3D.IndexBuffer3D, indexID : Int = 0, numIndices : Int = 0) : Void;
}

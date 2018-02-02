package starling.rendering;

import starling.core.Starling;
import js.Boot;
import Std;
import starling.errors.MissingContextError;
import starling.rendering.Program;
import haxe.ds.IntMap;
import StringTools;
import starling.rendering.VertexDataFormat;
import haxe.ds.StringMap;
import Type;

@:jsRequire("starling/rendering/Effect", "default")

extern class Effect {
	var mvpMatrix3D(get,set) : openfl.geom.Matrix3D;
	var onRestore(get,set) : Effect -> Void;
	var programBaseName(get,set) : String;
	var programName(get,never) : String;
	var programVariantName(get,never) : UInt;
	var vertexFormat(get,never) : VertexDataFormat;
	function new() : Void;
	function dispose() : Void;
	function purgeBuffers(vertexBuffer : Bool = false, indexBuffer : Bool = false) : Void;
	function render(firstIndex : Int = 0, numTriangles : Int = 0) : Void;
	function uploadIndexData(indexData : IndexData, ?bufferUsage : String) : Void;
	function uploadVertexData(vertexData : VertexData, ?bufferUsage : String) : Void;
	static var VERTEX_FORMAT : VertexDataFormat;
}

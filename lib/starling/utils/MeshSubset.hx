package starling.utils;



@:jsRequire("starling/utils/MeshSubset", "default")

extern class MeshSubset {
	var indexID : Int;
	var numIndices : Int;
	var numVertices : Int;
	var vertexID : Int;
	function new(vertexID : Int = 0, numVertices : Int = 0, indexID : Int = 0, numIndices : Int = 0) : Void;
	function setTo(vertexID : Int = 0, numVertices : Int = 0, indexID : Int = 0, numIndices : Int = 0) : Void;
}

package starling.utils;



@:jsRequire("starling/utils/MeshSubset", "default")

extern class MeshSubset implements Dynamic {

	function new(?vertexID:Dynamic, ?numVertices:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic);
	var vertexID:Dynamic;
	var numVertices:Dynamic;
	var indexID:Dynamic;
	var numIndices:Dynamic;
	function setTo(?vertexID:Dynamic, ?numVertices:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic):Dynamic;


}
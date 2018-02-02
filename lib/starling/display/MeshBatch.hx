package starling.display;

import starling.display.Mesh;
import Type;
import starling.utils.MatrixUtil;
import starling.utils.MeshSubset;
import starling.rendering.VertexData;
import starling.rendering.IndexData;

@:jsRequire("starling/display/MeshBatch", "default")

extern class MeshBatch extends Mesh {
	var batchable(get,set) : Bool;
	function new() : Void;
	function addMesh(mesh : Mesh, ?matrix : openfl.geom.Matrix, alpha : Float = 0, ?subset : starling.utils.MeshSubset, ignoreTransformations : Bool = false) : Void;
	function addMeshAt(mesh : Mesh, indexID : Int, vertexID : Int) : Void;
	function canAddMesh(mesh : Mesh, numVertices : Int = 0) : Bool;
	function clear() : Void;
	static var MAX_NUM_VERTICES(default,never) : Int;
}

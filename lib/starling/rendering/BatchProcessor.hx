package starling.rendering;

import starling.utils.MeshSubset;
// import starling.rendering.BatchPool;
import starling.rendering.BatchToken;

@:jsRequire("starling/rendering/BatchProcessor", "default")

extern class BatchProcessor {
	var numBatches(get,never) : Int;
	var onBatchComplete(get,set) : starling.display.MeshBatch -> Void;
	function new() : Void;
	function addMesh(mesh : starling.display.Mesh, state : RenderState, ?subset : starling.utils.MeshSubset, ignoreTransformations : Bool = false) : Void;
	function clear() : Void;
	function dispose() : Void;
	function fillToken(token : BatchToken) : BatchToken;
	function finishBatch() : Void;
	function getBatchAt(batchID : Int) : starling.display.MeshBatch;
	function trim() : Void;
}

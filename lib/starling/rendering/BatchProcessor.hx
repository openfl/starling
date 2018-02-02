package starling.rendering;

import starling.utils.MeshSubset;
// import starling.rendering.BatchPool;
import starling.rendering.BatchToken;

@:jsRequire("starling/rendering/BatchProcessor", "default")

extern class BatchProcessor implements Dynamic {

	function new();
	var _batches:Dynamic;
	var _batchPool:Dynamic;
	var _currentBatch:Dynamic;
	var _currentStyleType:Dynamic;
	function _onBatchComplete(a1:Dynamic):Dynamic;
	var _cacheToken:Dynamic;
	function dispose():Dynamic;
	function addMesh(mesh:Dynamic, state:Dynamic, ?subset:Dynamic, ?ignoreTransformations:Dynamic):Dynamic;
	function finishBatch():Dynamic;
	function clear():Dynamic;
	function getBatchAt(batchID:Dynamic):Dynamic;
	function trim():Dynamic;
	function fillToken(token:Dynamic):Dynamic;
	var numBatches:Dynamic;
	function get_numBatches():Dynamic;
	function onBatchComplete(a1:Dynamic):Dynamic;
	function get_onBatchComplete():Dynamic;
	function set_onBatchComplete(value:Dynamic):Dynamic;
	static var sMeshSubset:Dynamic;


}
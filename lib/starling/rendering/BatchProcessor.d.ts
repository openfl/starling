import starling_utils_MeshSubset from "./../../starling/utils/MeshSubset";
import openfl_Vector from "openfl/Vector";
import starling_rendering_BatchPool from "./../../starling/rendering/BatchPool";
import starling_rendering_BatchToken from "./../../starling/rendering/BatchToken";

declare namespace starling.rendering {

export class BatchProcessor {

	constructor();
	_batches:any;
	_batchPool:any;
	_currentBatch:any;
	_currentStyleType:any;
	_onBatchComplete(a1:any):any;
	_cacheToken:any;
	dispose():any;
	addMesh(mesh:any, state:any, subset?:any, ignoreTransformations?:any):any;
	finishBatch():any;
	clear():any;
	getBatchAt(batchID:any):any;
	trim():any;
	fillToken(token:any):any;
	numBatches:any;
	get_numBatches():any;
	onBatchComplete(a1:any):any;
	get_onBatchComplete():any;
	set_onBatchComplete(value:any):any;
	static sMeshSubset:any;


}

}

export default starling.rendering.BatchProcessor;
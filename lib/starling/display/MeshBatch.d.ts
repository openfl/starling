import starling_display_Mesh from "./../../starling/display/Mesh";
import Type from "./../../Type";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_utils_MeshSubset from "./../../starling/utils/MeshSubset";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";

declare namespace starling.display {

export class MeshBatch extends starling_display_Mesh {

	constructor();
	__effect:any;
	__batchable:any;
	__vertexSyncRequired:any;
	__indexSyncRequired:any;
	dispose():any;
	setVertexDataChanged():any;
	setIndexDataChanged():any;
	__setVertexAndIndexDataChanged():any;
	__syncVertexBuffer():any;
	__syncIndexBuffer():any;
	clear():any;
	addMesh(mesh:any, matrix?:any, alpha?:any, subset?:any, ignoreTransformations?:any):any;
	addMeshAt(mesh:any, indexID:any, vertexID:any):any;
	__setupFor(mesh:any):any;
	canAddMesh(mesh:any, numVertices?:any):any;
	render(painter:any):any;
	setStyle(meshStyle?:any, mergeWithPredecessor?:any):any;
	set_numVertices(value:any):any;
	set_numIndices(value:any):any;
	batchable:any;
	get_batchable():any;
	set_batchable(value:any):any;
	static MAX_NUM_VERTICES:any;
	static sFullMeshSubset:any;


}

}

export default starling.display.MeshBatch;
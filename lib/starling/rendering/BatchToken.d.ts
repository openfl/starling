import starling_utils_StringUtil from "./../../starling/utils/StringUtil";

declare namespace starling.rendering {

export class BatchToken {

	constructor(batchID?:any, vertexID?:any, indexID?:any);
	batchID:any;
	vertexID:any;
	indexID:any;
	copyFrom(token:any):any;
	setTo(batchID?:any, vertexID?:any, indexID?:any):any;
	reset():any;
	equals(other:any):any;
	toString():any;


}

}

export default starling.rendering.BatchToken;
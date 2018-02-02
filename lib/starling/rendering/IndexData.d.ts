import Std from "./../../Std";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_EOFError from "openfl/errors/EOFError";
import openfl_Vector from "openfl/Vector";
import starling_utils_StringUtil from "./../../starling/utils/StringUtil";
import openfl_utils_ByteArray from "openfl/utils/ByteArray";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_errors_MissingContextError from "./../../starling/errors/MissingContextError";
import openfl_display3D__$Context3DBufferUsage_Context3DBufferUsage_$Impl_$ from "./../../openfl/display3D/_Context3DBufferUsage/Context3DBufferUsage_Impl_";

declare namespace starling.rendering {

export class IndexData {

	constructor(initialCapacity?:any);
	_rawData:any;
	_numIndices:any;
	_initialCapacity:any;
	_useQuadLayout:any;
	clear():any;
	clone():any;
	copyTo(target:any, targetIndexID?:any, offset?:any, indexID?:any, numIndices?:any):any;
	setIndex(indexID:any, index:any):any;
	getIndex(indexID:any):any;
	offsetIndices(offset:any, indexID?:any, numIndices?:any):any;
	addTriangle(a:any, b:any, c:any):any;
	addQuad(a:any, b:any, c:any, d:any):any;
	toVector(out?:any):any;
	toString():any;
	switchToGenericData():any;
	ensureQuadDataCapacity(numIndices:any):any;
	createIndexBuffer(upload?:any, bufferUsage?:any):any;
	uploadToIndexBuffer(buffer:any, indexID?:any, numIndices?:any):any;
	trim():any;
	numIndices:any;
	get_numIndices():any;
	set_numIndices(value:any):any;
	numTriangles:any;
	get_numTriangles():any;
	set_numTriangles(value:any):any;
	numQuads:any;
	get_numQuads():any;
	set_numQuads(value:any):any;
	indexSizeInBytes:any;
	get_indexSizeInBytes():any;
	useQuadLayout:any;
	get_useQuadLayout():any;
	set_useQuadLayout(value:any):any;
	rawData:any;
	get_rawData():any;
	static INDEX_SIZE:any;
	static sQuadData:any;
	static sQuadDataNumIndices:any;
	static sVector:any;
	static sTrimData:any;
	static getBasicQuadIndexAt(indexID:any):any;


}

}

export default starling.rendering.IndexData;
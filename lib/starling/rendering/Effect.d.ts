import starling_core_Starling from "./../../starling/core/Starling";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import js_Boot from "./../../js/Boot";
import openfl_errors_Error from "openfl/errors/Error";
import Std from "./../../Std";
import starling_errors_MissingContextError from "./../../starling/errors/MissingContextError";
import starling_rendering_Program from "./../../starling/rendering/Program";
import haxe_ds_IntMap from "./../../haxe/ds/IntMap";
import StringTools from "./../../StringTools";
import starling_rendering_VertexDataFormat from "./../../starling/rendering/VertexDataFormat";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import Type from "./../../Type";

declare namespace starling.rendering {

export class Effect {

	constructor();
	_vertexBuffer:any;
	_vertexBufferSize:any;
	_indexBuffer:any;
	_indexBufferSize:any;
	_indexBufferUsesQuadLayout:any;
	_mvpMatrix3D:any;
	_onRestore(a1:any):any;
	_programBaseName:any;
	dispose():any;
	onContextCreated(event:any):any;
	purgeBuffers(vertexBuffer?:any, indexBuffer?:any):any;
	uploadIndexData(indexData:any, bufferUsage?:any):any;
	uploadVertexData(vertexData:any, bufferUsage?:any):any;
	render(firstIndex?:any, numTriangles?:any):any;
	beforeDraw(context:any):any;
	afterDraw(context:any):any;
	createProgram():any;
	programVariantName:any;
	get_programVariantName():any;
	programBaseName:any;
	get_programBaseName():any;
	set_programBaseName(value:any):any;
	programName:any;
	get_programName():any;
	program:any;
	get_program():any;
	onRestore(a1:any):any;
	get_onRestore():any;
	set_onRestore(value:any):any;
	vertexFormat:any;
	get_vertexFormat():any;
	mvpMatrix3D:any;
	get_mvpMatrix3D():any;
	set_mvpMatrix3D(value:any):any;
	indexBuffer:any;
	get_indexBuffer():any;
	indexBufferSize:any;
	get_indexBufferSize():any;
	vertexBuffer:any;
	get_vertexBuffer():any;
	vertexBufferSize:any;
	get_vertexBufferSize():any;
	static VERTEX_FORMAT:any;
	static sProgramNameCache:any;


}

}

export default starling.rendering.Effect;
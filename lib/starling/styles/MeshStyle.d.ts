import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import Type from "./../../Type";
import starling_rendering_MeshEffect from "./../../starling/rendering/MeshEffect";
import openfl_geom_Point from "openfl/geom/Point";

declare namespace starling.styles {

export class MeshStyle extends starling_events_EventDispatcher {

	constructor();
	_type:any;
	_target:any;
	_texture:any;
	_textureSmoothing:any;
	_textureRepeat:any;
	_textureRoot:any;
	_vertexData:any;
	_indexData:any;
	copyFrom(meshStyle:any):any;
	clone():any;
	createEffect():any;
	updateEffect(effect:any, state:any):any;
	canBatchWith(meshStyle:any):any;
	batchVertexData(targetStyle:any, targetVertexID?:any, matrix?:any, vertexID?:any, numVertices?:any):any;
	batchIndexData(targetStyle:any, targetIndexID?:any, offset?:any, indexID?:any, numIndices?:any):any;
	setRequiresRedraw():any;
	setVertexDataChanged():any;
	setIndexDataChanged():any;
	onTargetAssigned(target:any):any;
	addEventListener(type:any, listener:any):any;
	removeEventListener(type:any, listener:any):any;
	onEnterFrame(event:any):any;
	setTarget(target?:any, vertexData?:any, indexData?:any):any;
	getVertexPosition(vertexID:any, out?:any):any;
	setVertexPosition(vertexID:any, x:any, y:any):any;
	getVertexAlpha(vertexID:any):any;
	setVertexAlpha(vertexID:any, alpha:any):any;
	getVertexColor(vertexID:any):any;
	setVertexColor(vertexID:any, color:any):any;
	getTexCoords(vertexID:any, out?:any):any;
	setTexCoords(vertexID:any, u:any, v:any):any;
	vertexData:any;
	get_vertexData():any;
	indexData:any;
	get_indexData():any;
	type:any;
	get_type():any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	vertexFormat:any;
	get_vertexFormat():any;
	texture:any;
	get_texture():any;
	set_texture(value:any):any;
	textureSmoothing:any;
	get_textureSmoothing():any;
	set_textureSmoothing(value:any):any;
	textureRepeat:any;
	get_textureRepeat():any;
	set_textureRepeat(value:any):any;
	target:any;
	get_target():any;
	static VERTEX_FORMAT:any;
	static sPoint:any;


}

}

export default starling.styles.MeshStyle;
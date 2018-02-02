import starling_display_DisplayObject from "./../../starling/display/DisplayObject";
import starling_utils_MeshUtil from "./../../starling/utils/MeshUtil";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import Type from "./../../Type";
import starling_styles_MeshStyle from "./../../starling/styles/MeshStyle";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.display {

export class Mesh extends starling_display_DisplayObject {

	constructor(vertexData:any, indexData:any, style?:any);
	__style:any;
	__vertexData:any;
	__indexData:any;
	__pixelSnapping:any;
	dispose():any;
	hitTest(localPoint:any):any;
	getBounds(targetSpace:any, out?:any):any;
	render(painter:any):any;
	setStyle(meshStyle?:any, mergeWithPredecessor?:any):any;
	__createDefaultMeshStyle():any;
	setVertexDataChanged():any;
	setIndexDataChanged():any;
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
	style:any;
	get_style():any;
	set_style(value:any):any;
	texture:any;
	get_texture():any;
	set_texture(value:any):any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	textureSmoothing:any;
	get_textureSmoothing():any;
	set_textureSmoothing(value:any):any;
	textureRepeat:any;
	get_textureRepeat():any;
	set_textureRepeat(value:any):any;
	pixelSnapping:any;
	get_pixelSnapping():any;
	set_pixelSnapping(value:any):any;
	numVertices:any;
	get_numVertices():any;
	numIndices:any;
	get_numIndices():any;
	numTriangles:any;
	get_numTriangles():any;
	vertexFormat:any;
	get_vertexFormat():any;
	static sDefaultStyle:any;
	static sDefaultStyleFactory(a1?:any):any;
	static defaultStyle:any;
	static get_defaultStyle():any;
	static set_defaultStyle(value:any):any;
	static defaultStyleFactory(a1?:any):any;
	static get_defaultStyleFactory():any;
	static set_defaultStyleFactory(value:any):any;
	static fromPolygon(polygon:any, style?:any):any;


}

}

export default starling.display.Mesh;
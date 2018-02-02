import Std from "./../../Std";
import openfl_geom_Point from "openfl/geom/Point";
import js_Boot from "./../../js/Boot";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import Type from "./../../Type";
import openfl_errors_RangeError from "openfl/errors/RangeError";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import starling_utils_Pool from "./../../starling/utils/Pool";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import openfl_Vector from "openfl/Vector";
import starling_geom_Ellipse from "./../../starling/geom/Ellipse";
import starling_geom_Rectangle from "./../../starling/geom/Rectangle";

declare namespace starling.geom {

export class Polygon {

	constructor(vertices?:any);
	__coords:any;
	clone():any;
	reverse():any;
	addVertices(args:any):any;
	setVertex(index:any, x:any, y:any):any;
	getVertex(index:any, out?:any):any;
	contains(x:any, y:any):any;
	containsPoint(point:any):any;
	triangulate(indexData?:any, offset?:any):any;
	copyToVertexData(target:any, targetVertexID?:any, attrName?:any):any;
	toString():any;
	isSimple:any;
	get_isSimple():any;
	isConvex:any;
	get_isConvex():any;
	area:any;
	get_area():any;
	numVertices:any;
	get_numVertices():any;
	set_numVertices(value:any):any;
	numTriangles:any;
	get_numTriangles():any;
	static sRestIndices:any;
	static createEllipse(x:any, y:any, radiusX:any, radiusY:any, numSides?:any):any;
	static createCircle(x:any, y:any, radius:any, numSides?:any):any;
	static createRectangle(x:any, y:any, width:any, height:any):any;
	static isConvexTriangle(ax:any, ay:any, bx:any, by:any, cx:any, cy:any):any;
	static areVectorsIntersecting(ax:any, ay:any, bx:any, by:any, cx:any, cy:any, dx:any, dy:any):any;


}

}

export default starling.geom.Polygon;
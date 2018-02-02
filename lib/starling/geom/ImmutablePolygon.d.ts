import starling_geom_Polygon from "./../../starling/geom/Polygon";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import Type from "./../../Type";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";

declare namespace starling.geom {

export class ImmutablePolygon extends starling_geom_Polygon {

	constructor(vertices:any);
	__frozen:any;
	addVertices(args:any):any;
	setVertex(index:any, x:any, y:any):any;
	reverse():any;
	set_numVertices(value:any):any;
	getImmutableError():any;


}

}

export default starling.geom.ImmutablePolygon;
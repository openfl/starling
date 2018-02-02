import starling_geom_ImmutablePolygon from "./../../starling/geom/ImmutablePolygon";
import Std from "./../../Std";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";

declare namespace starling.geom {

export class Ellipse extends starling_geom_ImmutablePolygon {

	constructor(x:any, y:any, radiusX:any, radiusY:any, numSides?:any);
	__x:any;
	__y:any;
	__radiusX:any;
	__radiusY:any;
	getVertices(numSides:any):any;
	triangulate(indexData?:any, offset?:any):any;
	contains(x:any, y:any):any;
	get_area():any;
	get_isSimple():any;
	get_isConvex():any;


}

}

export default starling.geom.Ellipse;
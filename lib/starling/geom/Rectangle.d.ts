import starling_geom_ImmutablePolygon from "./../../starling/geom/ImmutablePolygon";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";

declare namespace starling.geom {

export class Rectangle extends starling_geom_ImmutablePolygon {

	constructor(x:any, y:any, width:any, height:any);
	__x:any;
	__y:any;
	__width:any;
	__height:any;
	triangulate(indexData?:any, offset?:any):any;
	contains(x:any, y:any):any;
	get_area():any;
	get_isSimple():any;
	get_isConvex():any;


}

}

export default starling.geom.Rectangle;
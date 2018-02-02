import starling_display_DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import starling_geom_Polygon from "./../../starling/geom/Polygon";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import starling_display_Mesh from "./../../starling/display/Mesh";
import openfl_Vector from "openfl/Vector";

declare namespace starling.display {

export class Canvas extends starling_display_DisplayObjectContainer {

	constructor();
	__polygons:any;
	__fillColor:any;
	__fillAlpha:any;
	dispose():any;
	hitTest(localPoint:any):any;
	drawCircle(x:any, y:any, radius:any):any;
	drawEllipse(x:any, y:any, width:any, height:any):any;
	drawRectangle(x:any, y:any, width:any, height:any):any;
	drawPolygon(polygon:any):any;
	beginFill(color?:any, alpha?:any):any;
	endFill():any;
	clear():any;
	__appendPolygon(polygon:any):any;


}

}

export default starling.display.Canvas;
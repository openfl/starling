import starling_display_Mesh from "./../../starling/display/Mesh";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import starling_styles_MeshStyle from "./../../starling/styles/MeshStyle";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.display {

export class Quad extends starling_display_Mesh {

	constructor(width:any, height:any, color?:any);
	__bounds:any;
	__setupVertices():any;
	getBounds(targetSpace:any, out?:any):any;
	hitTest(localPoint:any):any;
	readjustSize(width?:any, height?:any):any;
	set_texture(value:any):any;
	static sPoint3D:any;
	static sMatrix:any;
	static sMatrix3D:any;
	static fromTexture(texture:any):any;


}

}

export default starling.display.Quad;
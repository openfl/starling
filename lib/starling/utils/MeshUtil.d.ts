import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import starling_errors_AbstractClassError from "./../../starling/errors/AbstractClassError";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import starling_utils_Pool from "./../../starling/utils/Pool";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";

declare namespace starling.utils {

export class MeshUtil {

	MeshUtil():any;
	static sPoint3D:any;
	static sMatrix:any;
	static sMatrix3D:any;
	static containsPoint(vertexData:any, indexData:any, point:any):any;
	static calculateBounds(vertexData:any, sourceSpace:any, targetSpace:any, out?:any):any;


}

}

export default starling.utils.MeshUtil;
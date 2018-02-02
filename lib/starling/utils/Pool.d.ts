import openfl_Vector from "openfl/Vector";
import openfl_geom_Point from "openfl/geom/Point";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";

declare namespace starling.utils {

export class Pool {

	constructor();
	static sPoints:any;
	static sPoints3D:any;
	static sMatrices:any;
	static sMatrices3D:any;
	static sRectangles:any;
	static getPoint(x?:any, y?:any):any;
	static putPoint(point:any):any;
	static getPoint3D(x?:any, y?:any, z?:any):any;
	static putPoint3D(point:any):any;
	static getMatrix(a?:any, b?:any, c?:any, d?:any, tx?:any, ty?:any):any;
	static putMatrix(matrix:any):any;
	static getMatrix3D(identity?:any):any;
	static putMatrix3D(matrix:any):any;
	static getRectangle(x?:any, y?:any, width?:any, height?:any):any;
	static putRectangle(rectangle:any):any;


}

}

export default starling.utils.Pool;
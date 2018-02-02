import openfl_Vector from "openfl/Vector";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Point from "openfl/geom/Point";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";

declare namespace starling.utils {

export class MatrixUtil {

	static sRawData:any;
	static sRawData2:any;
	static sPoint3D:any;
	static sMatrixData:any;
	static convertTo3D(matrix:any, out?:any):any;
	static convertTo2D(matrix3D:any, out?:any):any;
	static isIdentity(matrix:any):any;
	static isIdentity3D(matrix:any):any;
	static transformPoint(matrix:any, point:any, out?:any):any;
	static transformPoint3D(matrix:any, point:any, out?:any):any;
	static transformCoords(matrix:any, x:any, y:any, out?:any):any;
	static transformCoords3D(matrix:any, x:any, y:any, z:any, out?:any):any;
	static skew(matrix:any, skewX:any, skewY:any):any;
	static prependMatrix(base:any, prep:any):any;
	static prependTranslation(matrix:any, tx:any, ty:any):any;
	static prependScale(matrix:any, sx:any, sy:any):any;
	static prependRotation(matrix:any, angle:any):any;
	static prependSkew(matrix:any, skewX:any, skewY:any):any;
	static toString3D(matrix:any, transpose?:any, precision?:any):any;
	static toString(matrix:any, precision?:any):any;
	static formatRawData(data:any, numCols:any, numRows:any, precision:any, indent?:any):any;
	static snapToPixels(matrix:any, pixelSize:any):any;
	static createPerspectiveProjectionMatrix(x:any, y:any, width:any, height:any, stageWidth?:any, stageHeight?:any, cameraPos?:any, out?:any):any;
	static createOrthographicProjectionMatrix(x:any, y:any, width:any, height:any, out?:any):any;


}

}

export default starling.utils.MatrixUtil;
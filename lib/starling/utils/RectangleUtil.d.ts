import openfl_geom_Point from "openfl/geom/Point";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import openfl_Vector from "openfl/Vector";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_ScaleMode from "./../../starling/utils/ScaleMode";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";

declare namespace starling.utils {

export class RectangleUtil {

	static sPoint:any;
	static sPoint3D:any;
	static sPositions:any;
	static intersect(rect1:any, rect2:any, out?:any):any;
	static fit(rectangle:any, into:any, scaleMode?:any, pixelPerfect?:any, out?:any):any;
	static nextSuitableScaleFactor(factor:any, up:any):any;
	static normalize(rect:any):any;
	static extend(rect:any, left?:any, right?:any, top?:any, bottom?:any):any;
	static extendToWholePixels(rect:any, scaleFactor?:any):any;
	static getBounds(rectangle:any, matrix:any, out?:any):any;
	static getBoundsProjected(rectangle:any, matrix:any, camPos:any, out?:any):any;
	static getPositions(rectangle:any, out?:any):any;
	static compare(r1:any, r2:any, e?:any):any;


}

}

export default starling.utils.RectangleUtil;
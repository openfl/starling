import openfl_geom_Point from "openfl/geom/Point";
import Std from "./../../Std";

declare namespace starling.utils {

export class MathUtil {

	static TWO_PI:any;
	static intersectLineWithXYPlane(pointA:any, pointB:any, out?:any):any;
	static isPointInTriangle(p:any, a:any, b:any, c:any):any;
	static normalizeAngle(angle:any):any;
	static getNextPowerOfTwo(number:any):any;
	static isEquivalent(a:any, b:any, epsilon?:any):any;
	static max(a:any, b:any):any;
	static min(a:any, b:any):any;
	static clamp(value:any, min:any, max:any):any;
	static minValues(values:any):any;
	static deg2rad(deg:any):any;
	static rad2deg(rad:any):any;
	static toFixed(value:any, precision:any):any;


}

}

export default starling.utils.MathUtil;
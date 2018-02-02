import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_filters_ColorMatrixEffect from "./../../starling/filters/ColorMatrixEffect";
import starling_utils_Color from "./../../starling/utils/Color";
import openfl_Vector from "openfl/Vector";

declare namespace starling.filters {

export class ColorMatrixFilter extends starling_filters_FragmentFilter {

	constructor(matrix?:any);
	createEffect():any;
	invert():any;
	adjustSaturation(sat:any):any;
	adjustContrast(value:any):any;
	adjustBrightness(value:any):any;
	adjustHue(value:any):any;
	tint(color:any, amount?:any):any;
	reset():any;
	concat(matrix:any):any;
	concatValues(m0:any, m1:any, m2:any, m3:any, m4:any, m5:any, m6:any, m7:any, m8:any, m9:any, m10:any, m11:any, m12:any, m13:any, m14:any, m15:any, m16:any, m17:any, m18:any, m19:any):any;
	matrix:any;
	get_matrix():any;
	set_matrix(value:any):any;
	colorEffect:any;
	get_colorEffect():any;
	static LUMA_R:any;
	static LUMA_G:any;
	static LUMA_B:any;
	static sMatrix:any;


}

}

export default starling.filters.ColorMatrixFilter;
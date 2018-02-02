import starling_rendering_FilterEffect from "./../../starling/rendering/FilterEffect";
import starling_rendering_Program from "./../../starling/rendering/Program";
import openfl_Vector from "openfl/Vector";
import Type from "./../../Type";

declare namespace starling.rendering {

export class MeshEffect extends starling_rendering_FilterEffect {

	constructor();
	_alpha:any;
	_tinted:any;
	_optimizeIfNotTinted:any;
	get_programVariantName():any;
	createProgram():any;
	beforeDraw(context:any):any;
	afterDraw(context:any):any;
	get_vertexFormat():any;
	alpha:any;
	get_alpha():any;
	set_alpha(value:any):any;
	tinted:any;
	get_tinted():any;
	set_tinted(value:any):any;
	static VERTEX_FORMAT:any;
	static sRenderAlpha:any;


}

}

export default starling.rendering.MeshEffect;
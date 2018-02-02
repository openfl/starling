import starling_rendering_Effect from "./../../starling/rendering/Effect";
import starling_utils_RenderUtil from "./../../starling/utils/RenderUtil";
import starling_rendering_Program from "./../../starling/rendering/Program";

declare namespace starling.rendering {

export class FilterEffect extends starling_rendering_Effect {

	constructor();
	_texture:any;
	_textureSmoothing:any;
	_textureRepeat:any;
	get_programVariantName():any;
	createProgram():any;
	beforeDraw(context:any):any;
	afterDraw(context:any):any;
	get_vertexFormat():any;
	texture:any;
	get_texture():any;
	set_texture(value:any):any;
	textureSmoothing:any;
	get_textureSmoothing():any;
	set_textureSmoothing(value:any):any;
	textureRepeat:any;
	get_textureRepeat():any;
	set_textureRepeat(value:any):any;
	static VERTEX_FORMAT:any;
	static STD_VERTEX_SHADER:any;
	static tex(resultReg:any, uvReg:any, sampler:any, texture:any, convertToPmaIfRequired?:any):any;


}

}

export default starling.rendering.FilterEffect;
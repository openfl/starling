import Std from "./../../Std";
import starling_core_Starling from "./../../starling/core/Starling";
import openfl_display3D__$Context3DVertexBufferFormat_Context3DVertexBufferFormat_$Impl_$ from "./../../openfl/display3D/_Context3DVertexBufferFormat/Context3DVertexBufferFormat_Impl_";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import starling_utils_StringUtil from "./../../starling/utils/StringUtil";
import starling_rendering_VertexDataAttribute from "./../../starling/rendering/VertexDataAttribute";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";
import openfl_Vector from "openfl/Vector";

declare namespace starling.rendering {

export class VertexDataFormat {

	constructor();
	_format:any;
	_vertexSize:any;
	_attributes:any;
	extend(format:any):any;
	getSize(attrName:any):any;
	getSizeIn32Bits(attrName:any):any;
	getOffset(attrName:any):any;
	getOffsetIn32Bits(attrName:any):any;
	getFormat(attrName:any):any;
	getName(attrIndex:any):any;
	hasAttribute(attrName:any):any;
	setVertexBufferAt(index:any, buffer:any, attrName:any):any;
	parseFormat(format:any):any;
	toString():any;
	getAttribute(attrName:any):any;
	attributes:any;
	get_attributes():any;
	formatString:any;
	get_formatString():any;
	vertexSize:any;
	get_vertexSize():any;
	vertexSizeIn32Bits:any;
	get_vertexSizeIn32Bits():any;
	numAttributes:any;
	get_numAttributes():any;
	static sFormats:any;
	static fromString(format:any):any;


}

}

export default starling.rendering.VertexDataFormat;
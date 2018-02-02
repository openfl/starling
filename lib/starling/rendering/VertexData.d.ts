import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";
import Std from "./../../Std";
import starling_utils_StringUtil from "./../../starling/utils/StringUtil";
import openfl_geom_Point from "openfl/geom/Point";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import _$UInt_UInt_$Impl_$ from "./../../_UInt/UInt_Impl_";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_errors_MissingContextError from "./../../starling/errors/MissingContextError";
import openfl_display3D__$Context3DBufferUsage_Context3DBufferUsage_$Impl_$ from "./../../openfl/display3D/_Context3DBufferUsage/Context3DBufferUsage_Impl_";
import openfl_utils_ByteArray from "openfl/utils/ByteArray";
import starling_styles_MeshStyle from "./../../starling/styles/MeshStyle";
import starling_rendering_VertexDataFormat from "./../../starling/rendering/VertexDataFormat";

declare namespace starling.rendering {

export class VertexData {

	constructor(format?:any, initialCapacity?:any);
	_rawData:any;
	_numVertices:any;
	_format:any;
	_attributes:any;
	_numAttributes:any;
	_premultipliedAlpha:any;
	_tinted:any;
	_posOffset:any;
	_colOffset:any;
	_vertexSize:any;
	clear():any;
	clone():any;
	copyTo(target:any, targetVertexID?:any, matrix?:any, vertexID?:any, numVertices?:any):any;
	copyAttributeTo(target:any, targetVertexID:any, attrName:any, matrix?:any, vertexID?:any, numVertices?:any):any;
	copyAttributeTo_internal(target:any, targetVertexID:any, matrix:any, sourceAttribute:any, targetAttribute:any, vertexID:any, numVertices:any):any;
	trim():any;
	toString():any;
	getUnsignedInt(vertexID:any, attrName:any):any;
	setUnsignedInt(vertexID:any, attrName:any, value:any):any;
	getFloat(vertexID:any, attrName:any):any;
	setFloat(vertexID:any, attrName:any, value:any):any;
	getPoint(vertexID:any, attrName:any, out?:any):any;
	setPoint(vertexID:any, attrName:any, x:any, y:any):any;
	getPoint3D(vertexID:any, attrName:any, out?:any):any;
	setPoint3D(vertexID:any, attrName:any, x:any, y:any, z:any):any;
	getPoint4D(vertexID:any, attrName:any, out?:any):any;
	setPoint4D(vertexID:any, attrName:any, x:any, y:any, z:any, w?:any):any;
	getColor(vertexID:any, attrName?:any):any;
	setColor(vertexID:any, attrName:any, color:any):any;
	getAlpha(vertexID:any, attrName?:any):any;
	setAlpha(vertexID:any, attrName:any, alpha:any):any;
	getBounds(attrName?:any, matrix?:any, vertexID?:any, numVertices?:any, out?:any):any;
	getBoundsProjected(attrName:any, matrix:any, camPos:any, vertexID?:any, numVertices?:any, out?:any):any;
	premultipliedAlpha:any;
	get_premultipliedAlpha():any;
	set_premultipliedAlpha(value:any):any;
	setPremultipliedAlpha(value:any, updateData:any):any;
	updateTinted(attrName?:any):any;
	transformPoints(attrName:any, matrix:any, vertexID?:any, numVertices?:any):any;
	translatePoints(attrName:any, deltaX:any, deltaY:any, vertexID?:any, numVertices?:any):any;
	scaleAlphas(attrName:any, factor:any, vertexID?:any, numVertices?:any):any;
	colorize(attrName?:any, color?:any, alpha?:any, vertexID?:any, numVertices?:any):any;
	getFormat(attrName:any):any;
	getSize(attrName:any):any;
	getSizeIn32Bits(attrName:any):any;
	getOffset(attrName:any):any;
	getOffsetIn32Bits(attrName:any):any;
	hasAttribute(attrName:any):any;
	createVertexBuffer(upload?:any, bufferUsage?:any):any;
	uploadToVertexBuffer(buffer:any, vertexID?:any, numVertices?:any):any;
	getAttribute(attrName:any):any;
	numVertices:any;
	get_numVertices():any;
	set_numVertices(value:any):any;
	rawData:any;
	get_rawData():any;
	format:any;
	get_format():any;
	set_format(value:any):any;
	tinted:any;
	get_tinted():any;
	set_tinted(value:any):any;
	formatString:any;
	get_formatString():any;
	vertexSize:any;
	get_vertexSize():any;
	vertexSizeIn32Bits:any;
	get_vertexSizeIn32Bits():any;
	size:any;
	get_size():any;
	sizeIn32Bits:any;
	get_sizeIn32Bits():any;
	static sHelperPoint:any;
	static sHelperPoint3D:any;
	static sBytes:any;
	static switchEndian(value:any):any;
	static premultiplyAlpha(rgba:any):any;
	static unmultiplyAlpha(rgba:any):any;


}

}

export default starling.rendering.VertexData;
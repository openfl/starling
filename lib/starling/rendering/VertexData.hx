package starling.rendering;

import Std;
import starling.utils.StringUtil;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;
import starling.core.Starling;
import starling.errors.MissingContextError;
import starling.styles.MeshStyle;
import starling.rendering.VertexDataFormat;

@:jsRequire("starling/rendering/VertexData", "default")

extern class VertexData implements Dynamic {

	function new(?format:Dynamic, ?initialCapacity:Dynamic);
	var _rawData:Dynamic;
	var _numVertices:Dynamic;
	var _format:Dynamic;
	var _attributes:Dynamic;
	var _numAttributes:Dynamic;
	var _premultipliedAlpha:Dynamic;
	var _tinted:Dynamic;
	var _posOffset:Dynamic;
	var _colOffset:Dynamic;
	var _vertexSize:Dynamic;
	function clear():Dynamic;
	function clone():Dynamic;
	function copyTo(target:Dynamic, ?targetVertexID:Dynamic, ?matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function copyAttributeTo(target:Dynamic, targetVertexID:Dynamic, attrName:Dynamic, ?matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function copyAttributeTo_internal(target:Dynamic, targetVertexID:Dynamic, matrix:Dynamic, sourceAttribute:Dynamic, targetAttribute:Dynamic, vertexID:Dynamic, numVertices:Dynamic):Dynamic;
	function trim():Dynamic;
	function toString():Dynamic;
	function getUnsignedInt(vertexID:Dynamic, attrName:Dynamic):Dynamic;
	function setUnsignedInt(vertexID:Dynamic, attrName:Dynamic, value:Dynamic):Dynamic;
	function getFloat(vertexID:Dynamic, attrName:Dynamic):Dynamic;
	function setFloat(vertexID:Dynamic, attrName:Dynamic, value:Dynamic):Dynamic;
	function getPoint(vertexID:Dynamic, attrName:Dynamic, ?out:Dynamic):Dynamic;
	function setPoint(vertexID:Dynamic, attrName:Dynamic, x:Dynamic, y:Dynamic):Dynamic;
	function getPoint3D(vertexID:Dynamic, attrName:Dynamic, ?out:Dynamic):Dynamic;
	function setPoint3D(vertexID:Dynamic, attrName:Dynamic, x:Dynamic, y:Dynamic, z:Dynamic):Dynamic;
	function getPoint4D(vertexID:Dynamic, attrName:Dynamic, ?out:Dynamic):Dynamic;
	function setPoint4D(vertexID:Dynamic, attrName:Dynamic, x:Dynamic, y:Dynamic, z:Dynamic, ?w:Dynamic):Dynamic;
	function getColor(vertexID:Dynamic, ?attrName:Dynamic):Dynamic;
	function setColor(vertexID:Dynamic, attrName:Dynamic, color:Dynamic):Dynamic;
	function getAlpha(vertexID:Dynamic, ?attrName:Dynamic):Dynamic;
	function setAlpha(vertexID:Dynamic, attrName:Dynamic, alpha:Dynamic):Dynamic;
	function getBounds(?attrName:Dynamic, ?matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic, ?out:Dynamic):Dynamic;
	function getBoundsProjected(attrName:Dynamic, matrix:Dynamic, camPos:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic, ?out:Dynamic):Dynamic;
	var premultipliedAlpha:Dynamic;
	function get_premultipliedAlpha():Dynamic;
	function set_premultipliedAlpha(value:Dynamic):Dynamic;
	function setPremultipliedAlpha(value:Dynamic, updateData:Dynamic):Dynamic;
	function updateTinted(?attrName:Dynamic):Dynamic;
	function transformPoints(attrName:Dynamic, matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function translatePoints(attrName:Dynamic, deltaX:Dynamic, deltaY:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function scaleAlphas(attrName:Dynamic, factor:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function colorize(?attrName:Dynamic, ?color:Dynamic, ?alpha:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function getFormat(attrName:Dynamic):Dynamic;
	function getSize(attrName:Dynamic):Dynamic;
	function getSizeIn32Bits(attrName:Dynamic):Dynamic;
	function getOffset(attrName:Dynamic):Dynamic;
	function getOffsetIn32Bits(attrName:Dynamic):Dynamic;
	function hasAttribute(attrName:Dynamic):Dynamic;
	function createVertexBuffer(?upload:Dynamic, ?bufferUsage:Dynamic):Dynamic;
	function uploadToVertexBuffer(buffer:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function getAttribute(attrName:Dynamic):Dynamic;
	var numVertices:Dynamic;
	function get_numVertices():Dynamic;
	function set_numVertices(value:Dynamic):Dynamic;
	var rawData:Dynamic;
	function get_rawData():Dynamic;
	var format:Dynamic;
	function get_format():Dynamic;
	function set_format(value:Dynamic):Dynamic;
	var tinted:Dynamic;
	function get_tinted():Dynamic;
	function set_tinted(value:Dynamic):Dynamic;
	var formatString:Dynamic;
	function get_formatString():Dynamic;
	var vertexSize:Dynamic;
	function get_vertexSize():Dynamic;
	var vertexSizeIn32Bits:Dynamic;
	function get_vertexSizeIn32Bits():Dynamic;
	var size:Dynamic;
	function get_size():Dynamic;
	var sizeIn32Bits:Dynamic;
	function get_sizeIn32Bits():Dynamic;
	static var sHelperPoint:Dynamic;
	static var sHelperPoint3D:Dynamic;
	static var sBytes:Dynamic;
	static function switchEndian(value:Dynamic):Dynamic;
	static function premultiplyAlpha(rgba:Dynamic):Dynamic;
	static function unmultiplyAlpha(rgba:Dynamic):Dynamic;


}
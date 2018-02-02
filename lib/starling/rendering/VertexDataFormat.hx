package starling.rendering;

import Std;
import starling.core.Starling;
import starling.utils.StringUtil;
import starling.rendering.VertexDataAttribute;
import haxe.ds.StringMap;

@:jsRequire("starling/rendering/VertexDataFormat", "default")

extern class VertexDataFormat implements Dynamic {

	function new();
	var _format:Dynamic;
	var _vertexSize:Dynamic;
	var _attributes:Dynamic;
	function extend(format:Dynamic):Dynamic;
	function getSize(attrName:Dynamic):Dynamic;
	function getSizeIn32Bits(attrName:Dynamic):Dynamic;
	function getOffset(attrName:Dynamic):Dynamic;
	function getOffsetIn32Bits(attrName:Dynamic):Dynamic;
	function getFormat(attrName:Dynamic):Dynamic;
	function getName(attrIndex:Dynamic):Dynamic;
	function hasAttribute(attrName:Dynamic):Dynamic;
	function setVertexBufferAt(index:Dynamic, buffer:Dynamic, attrName:Dynamic):Dynamic;
	function parseFormat(format:Dynamic):Dynamic;
	function toString():Dynamic;
	function getAttribute(attrName:Dynamic):Dynamic;
	var attributes:Dynamic;
	function get_attributes():Dynamic;
	var formatString:Dynamic;
	function get_formatString():Dynamic;
	var vertexSize:Dynamic;
	function get_vertexSize():Dynamic;
	var vertexSizeIn32Bits:Dynamic;
	function get_vertexSizeIn32Bits():Dynamic;
	var numAttributes:Dynamic;
	function get_numAttributes():Dynamic;
	static var sFormats:Dynamic;
	static function fromString(format:Dynamic):Dynamic;


}
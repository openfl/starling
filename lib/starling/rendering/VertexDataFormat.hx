package starling.rendering;

import Std;
import starling.core.Starling;
import starling.utils.StringUtil;
import starling.rendering.VertexDataAttribute;
import haxe.ds.StringMap;

@:jsRequire("starling/rendering/VertexDataFormat", "default")

extern class VertexDataFormat {
	var formatString(get,null) : String;
	var numAttributes(get,null) : Int;
	var vertexSize(get,null) : Int;
	var vertexSizeIn32Bits(get,null) : Int;
	function new() : Void;
	function extend(format : String) : VertexDataFormat;
	function getFormat(attrName : String) : String;
	function getName(attrIndex : Int) : String;
	function getOffset(attrName : String) : Int;
	function getOffsetIn32Bits(attrName : String) : Int;
	function getSize(attrName : String) : Int;
	function getSizeIn32Bits(attrName : String) : Int;
	function hasAttribute(attrName : String) : Bool;
	function setVertexBufferAt(index : Int, buffer : openfl.display3D.VertexBuffer3D, attrName : String) : Void;
	function toString() : String;
	static function fromString(format : String) : VertexDataFormat;
}

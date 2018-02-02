package starling.rendering;

import Std;
import starling.utils.StringUtil;
import starling.core.Starling;
import starling.errors.MissingContextError;

@:jsRequire("starling/rendering/IndexData", "default")

extern class IndexData implements Dynamic {

	function new(?initialCapacity:Dynamic);
	var _rawData:Dynamic;
	var _numIndices:Dynamic;
	var _initialCapacity:Dynamic;
	var _useQuadLayout:Dynamic;
	function clear():Dynamic;
	function clone():Dynamic;
	function copyTo(target:Dynamic, ?targetIndexID:Dynamic, ?offset:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic):Dynamic;
	function setIndex(indexID:Dynamic, index:Dynamic):Dynamic;
	function getIndex(indexID:Dynamic):Dynamic;
	function offsetIndices(offset:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic):Dynamic;
	function addTriangle(a:Dynamic, b:Dynamic, c:Dynamic):Dynamic;
	function addQuad(a:Dynamic, b:Dynamic, c:Dynamic, d:Dynamic):Dynamic;
	function toVector(?out:Dynamic):Dynamic;
	function toString():Dynamic;
	function switchToGenericData():Dynamic;
	function ensureQuadDataCapacity(numIndices:Dynamic):Dynamic;
	function createIndexBuffer(?upload:Dynamic, ?bufferUsage:Dynamic):Dynamic;
	function uploadToIndexBuffer(buffer:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic):Dynamic;
	function trim():Dynamic;
	var numIndices:Dynamic;
	function get_numIndices():Dynamic;
	function set_numIndices(value:Dynamic):Dynamic;
	var numTriangles:Dynamic;
	function get_numTriangles():Dynamic;
	function set_numTriangles(value:Dynamic):Dynamic;
	var numQuads:Dynamic;
	function get_numQuads():Dynamic;
	function set_numQuads(value:Dynamic):Dynamic;
	var indexSizeInBytes:Dynamic;
	function get_indexSizeInBytes():Dynamic;
	var useQuadLayout:Dynamic;
	function get_useQuadLayout():Dynamic;
	function set_useQuadLayout(value:Dynamic):Dynamic;
	var rawData:Dynamic;
	function get_rawData():Dynamic;
	static var INDEX_SIZE:Dynamic;
	static var sQuadData:Dynamic;
	static var sQuadDataNumIndices:Dynamic;
	static var sVector:Dynamic;
	static var sTrimData:Dynamic;
	static function getBasicQuadIndexAt(indexID:Dynamic):Dynamic;


}
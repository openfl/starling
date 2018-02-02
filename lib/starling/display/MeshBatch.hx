package starling.display;

import starling.display.Mesh;
import Type;
import starling.utils.MatrixUtil;
import starling.utils.MeshSubset;
import starling.rendering.VertexData;
import starling.rendering.IndexData;

@:jsRequire("starling/display/MeshBatch", "default")

extern class MeshBatch extends starling.display.Mesh implements Dynamic {

	function new();
	var __effect:Dynamic;
	var __batchable:Dynamic;
	var __vertexSyncRequired:Dynamic;
	var __indexSyncRequired:Dynamic;
	override function dispose():Dynamic;
	override function setVertexDataChanged():Dynamic;
	override function setIndexDataChanged():Dynamic;
	function __setVertexAndIndexDataChanged():Dynamic;
	function __syncVertexBuffer():Dynamic;
	function __syncIndexBuffer():Dynamic;
	function clear():Dynamic;
	function addMesh(mesh:Dynamic, ?matrix:Dynamic, ?alpha:Dynamic, ?subset:Dynamic, ?ignoreTransformations:Dynamic):Dynamic;
	function addMeshAt(mesh:Dynamic, indexID:Dynamic, vertexID:Dynamic):Dynamic;
	function __setupFor(mesh:Dynamic):Dynamic;
	function canAddMesh(mesh:Dynamic, ?numVertices:Dynamic):Dynamic;
	override function render(painter:Dynamic):Dynamic;
	override function setStyle(?meshStyle:Dynamic, ?mergeWithPredecessor:Dynamic):Dynamic;
	function set_numVertices(value:Dynamic):Dynamic;
	function set_numIndices(value:Dynamic):Dynamic;
	var batchable:Dynamic;
	function get_batchable():Dynamic;
	function set_batchable(value:Dynamic):Dynamic;
	static var MAX_NUM_VERTICES:Dynamic;
	static var sFullMeshSubset:Dynamic;


}
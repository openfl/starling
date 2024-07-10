// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package starling.rendering;

import openfl.geom.Matrix;
import starling.display.Mesh;
import starling.display.MeshBatch;
import starling.utils.MeshSubset;
import starling.utils.ArrayUtil;
import haxe.ds.ObjectMap;

/** This class manages a list of mesh batches of different types;
 *  it acts as a "meta" MeshBatch that initiates all rendering.
 */
class BatchProcessor {
	private var _batches:Array<MeshBatch>;
	private var _batchPool:BatchPool;
	private var _currentBatch:MeshBatch;
	private var _currentStyleType:Class<Dynamic>;
	private var _onBatchComplete:MeshBatch->Void;
	private var _cacheToken:BatchToken;

	// helper objects
	private static var sMeshSubset:MeshSubset = new MeshSubset();

	#if commonjs
	private static function __init__() {
		untyped Object.defineProperties(BatchProcessor.prototype, {
			"numBatches": {get: untyped __js__("function () { return this.get_numBatches (); }")},
			"onBatchComplete": {
				get: untyped __js__("function () { return this.get_onBatchComplete (); }"),
				set: untyped __js__("function (v) { return this.set_onBatchComplete (v); }")
			},
		});
	}
	#end

	/** Creates a new batch processor. */
	public function new() {
		_batches = new Array<MeshBatch>();
		_batchPool = new BatchPool();
		_cacheToken = new BatchToken();
	}

	/** Disposes all batches (including those in the reusable pool). */
	public function dispose():Void {
		for (batch in _batches)
			batch.dispose();

		#if (haxe_ver >= 4.0)
		_batches.resize(0);
		#else
		ArrayUtil.resize(_batches, 0);
		#end

		_batchPool.purge();
		_currentBatch = null;
		_onBatchComplete = null;
	}

	/** Adds a mesh to the current batch, or to a new one if the current one does not support
	 *  it. Whenever the batch changes, <code>onBatchComplete</code> is called for the previous
	 *  one.
	 *
	 *  @param mesh       the mesh to add to the current (or new) batch.
	 *  @param state      the render state from which to take the current settings for alpha,
	 *                    modelview matrix, and blend mode.
	 *  @param subset     the subset of the mesh you want to add, or <code>null</code> for
	 *                    the complete mesh.
	 *  @param ignoreTransformations   when enabled, the mesh's vertices will be added
	 *                    without transforming them in any way (no matter the value of the
	 *                    state's <code>modelviewMatrix</code>).
	 */
	public function addMesh(mesh:Mesh, state:RenderState, subset:MeshSubset = null, ignoreTransformations:Bool = false):Void {
		if (subset == null) {
			subset = sMeshSubset;
			subset.vertexID = subset.indexID = 0;
			subset.numVertices = mesh.numVertices;
			subset.numIndices = mesh.numIndices;
		} else {
			if (subset.numVertices < 0)
				subset.numVertices = mesh.numVertices - subset.vertexID;
			if (subset.numIndices < 0)
				subset.numIndices = mesh.numIndices - subset.indexID;
		}

		if (subset.numVertices > 0) {
			if (_currentBatch == null || !_currentBatch.canAddMesh(mesh, subset.numVertices)) {
				finishBatch();

				_currentStyleType = mesh.style.type;
				_currentBatch = _batchPool.get(_currentStyleType);
				_currentBatch.blendMode = state != null ? state.blendMode : mesh.blendMode;
				_cacheToken.setTo(_batches.length);
				_batches[_batches.length] = _currentBatch;
			}

			var matrix:Matrix = state != null ? state._modelviewMatrix : null;
			var alpha:Float = state != null ? state._alpha : 1.0;

			_currentBatch.addMeshAt(mesh, -1, -1, matrix, alpha, subset, ignoreTransformations);
			_cacheToken.vertexID += subset.numVertices;
			_cacheToken.indexID += subset.numIndices;
		}
	}

	/** Finishes the current batch, i.e. call the 'onComplete' callback on the batch and
	 *  prepares initialization of a new one. */
	public function finishBatch():Void {
		var meshBatch:MeshBatch = _currentBatch;

		if (meshBatch != null) {
			_currentBatch = null;
			_currentStyleType = null;

			if (_onBatchComplete != null)
				_onBatchComplete(meshBatch);
		}
	}

	/** Clears all batches and adds them to a pool so they can be reused later. */
	public function clear():Void {
		var numBatches:Int = _batches.length;

		for (i in 0...numBatches)
			_batchPool.put(_batches[i]);

		#if (haxe_ver >= 4.0)
		_batches.resize(0);
		#else
		ArrayUtil.resize(_batches, 0);
		#end
		_currentBatch = null;
		_currentStyleType = null;
		_cacheToken.reset();
	}

	/** Returns the batch at a certain index. */
	public function getBatchAt(batchID:Int):MeshBatch {
		return _batches[batchID];
	}

	/** Disposes all batches that are currently unused. */
	public function trim():Void {
		_batchPool.purge();
	}

	/** Sets all properties of the given token so that it describes the current position
	 *  within this instance. */
	public function fillToken(token:BatchToken):BatchToken {
		token.batchID = _cacheToken.batchID;
		token.vertexID = _cacheToken.vertexID;
		token.indexID = _cacheToken.indexID;
		return token;
	}

	/** The number of batches currently stored in the BatchProcessor. */
	public var numBatches(get, never):Int;

	private function get_numBatches():Int {
		return _batches.length;
	}

	/** This callback is executed whenever a batch is finished and replaced by a new one.
	 *  The finished MeshBatch is passed to the callback. Typically, this callback is used
	 *  to actually render it. */
	public var onBatchComplete(get, set):MeshBatch->Void;

	private function get_onBatchComplete():MeshBatch->Void {
		return _onBatchComplete;
	}

	private function set_onBatchComplete(value:MeshBatch->Void):MeshBatch->Void {
		return _onBatchComplete = value;
	}
}

class BatchPool {
	private var _batchLists:ObjectMap<Dynamic, Array<MeshBatch>>;

	public function new() {
		_batchLists = new ObjectMap();
	}

	public function purge():Void {
		for (batchList in _batchLists) {
			if (batchList != null) {
				for (i in 0...batchList.length) {
					if (batchList[i] != null)
						batchList[i].dispose();
				}

				#if (haxe_ver >= 4.0)
				batchList.resize(0);
				#else
				ArrayUtil.resize(batchList, 0);
				#end
			}
		}
	}

	public function get(styleType:Class<Dynamic>):MeshBatch {
		var batchList:Array<MeshBatch> = _batchLists.get(styleType);
		if (batchList == null) {
			batchList = new Array<MeshBatch>();
			_batchLists.set(styleType, batchList);
		}

		if (batchList.length > 0)
			return batchList.pop();
		else
			return new MeshBatch();
	}

	public function put(meshBatch:MeshBatch):Void {
		var styleType:Class<Dynamic> = meshBatch.style.type;
		var batchList:Array<MeshBatch> = _batchLists.get(styleType);
		if (batchList == null) {
			batchList = new Array<MeshBatch>();
			_batchLists.set(styleType, batchList);
		}

		meshBatch.clear();
		batchList.push(meshBatch);
	}
}

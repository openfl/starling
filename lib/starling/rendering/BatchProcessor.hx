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
import openfl.utils.Dictionary;
import openfl.Vector;

import starling.display.Mesh;
import starling.display.MeshBatch;
import starling.utils.MeshSubset;

/** This class manages a list of mesh batches of different types;
 *  it acts as a "meta" MeshBatch that initiates all rendering.
 */

@:jsRequire("starling/rendering/BatchProcessor", "default")

extern class BatchProcessor
{
    /** Creates a new batch processor. */
    public function new();

    /** Disposes all batches (including those in the reusable pool). */
    public function dispose():Void;

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
    public function addMesh(mesh:Mesh, state:RenderState, subset:MeshSubset=null,
                            ignoreTransformations:Bool=false):Void;

    /** Finishes the current batch, i.e. call the 'onComplete' callback on the batch and
     *  prepares initialization of a new one. */
    public function finishBatch():Void;

    /** Clears all batches and adds them to a pool so they can be reused later. */
    public function clear():Void;

    /** Returns the batch at a certain index. */
    public function getBatchAt(batchID:Int):MeshBatch;

    /** Disposes all batches that are currently unused. */
    public function trim():Void;

    /** Sets all properties of the given token so that it describes the current position
     *  within this instance. */
    public function fillToken(token:BatchToken):BatchToken;

    /** The number of batches currently stored in the BatchProcessor. */
    public var numBatches(get, never):Int;
    private function get_numBatches():Int;

    /** This callback is executed whenever a batch is finished and replaced by a new one.
     *  The finished MeshBatch is passed to the callback. Typically, this callback is used
     *  to actually render it. */
    public var onBatchComplete(get, set):MeshBatch->Void;
    private function get_onBatchComplete():MeshBatch->Void;
    private function set_onBatchComplete(value:MeshBatch->Void):MeshBatch->Void;
}

extern class BatchPool
{
    public function new();

    public function purge():Void;

    public function get(styleType:Class<Dynamic>):MeshBatch;

    public function put(meshBatch:MeshBatch):Void;
}
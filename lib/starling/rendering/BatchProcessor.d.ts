import MeshSubset from "./../../starling/utils/MeshSubset";
import Vector from "openfl/Vector";
import BatchPool from "./../../starling/rendering/BatchPool";
import BatchToken from "./../../starling/rendering/BatchToken";
import Mesh from "./../display/Mesh";
import MeshBatch from "./../display/MeshBatch";
import RenderState from "./RenderState";

declare namespace starling.rendering
{
	/** This class manages a list of mesh batches of different types;
	 *  it acts as a "meta" MeshBatch that initiates all rendering.
	 */
	export class BatchProcessor
	{
		/** Creates a new batch processor. */
		public constructor();
	
		/** Disposes all batches (including those in the reusable pool). */
		public dispose():void;
	
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
		public addMesh(mesh:Mesh, state:RenderState, subset?:MeshSubset,
								ignoreTransformations?:boolean):void;
	
		/** Finishes the current batch, i.e. call the 'onComplete' callback on the batch and
		 *  prepares initialization of a new one. */
		public finishBatch():void;
	
		/** Clears all batches and adds them to a pool so they can be reused later. */
		public clear():void;
	
		/** Returns the batch at a certain index. */
		public getBatchAt(batchID:number):MeshBatch;
	
		/** Disposes all batches that are currently unused. */
		public trim():void;
	
		/** Sets all properties of the given token so that it describes the current position
		 *  within this instance. */
		public fillToken(token:BatchToken):BatchToken;
	
		/** The number of batches currently stored in the BatchProcessor. */
		public readonly numBatches:number;
		protected get_numBatches():number;
	
		/** This callback is executed whenever a batch is finished and replaced by a new one.
		 *  The finished MeshBatch is passed to the callback. Typically, this callback is used
		 *  to actually render it. */
		public onBatchComplete:(MeshBatch)=>void;
		protected get_onBatchComplete():(MeshBatch)=>void;
		protected set_onBatchComplete(value:(MeshBatch)=>void):(MeshBatch)=>void;
	}
	
	export class BatchPool
	{
		public constructor();
	
		public purge():void;
	
		public get(styleType:any):MeshBatch;
	
		public put(meshBatch:MeshBatch):void;
	}
}

export default starling.rendering.BatchProcessor;
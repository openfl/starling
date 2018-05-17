package starling.rendering {

	import starling.display.Mesh;
	import starling.display.MeshBatch;
	import starling.utils.MeshSubset;
	// import starling.rendering.BatchPool;
	import starling.rendering.BatchToken;

	/**
	 * @externs
	 */
	public class BatchProcessor {
		public function get numBatches():int { return 0; }
		public var onBatchComplete:Function;
		public function BatchProcessor():void {}
		public function addMesh(mesh:starling.display.Mesh, state:RenderState, subset:starling.utils.MeshSubset = null, ignoreTransformations:Boolean = false):void {}
		public function clear():void {}
		public function dispose():void {}
		public function fillToken(token:BatchToken):BatchToken { return null; }
		public function finishBatch():void {}
		public function getBatchAt(batchID:int):starling.display.MeshBatch { return null; }
		public function trim():void {}
	}

}
package starling.display {
	
	import openfl.geom.Matrix;
	import starling.display.Mesh;
	import starling.utils.MatrixUtil;
	import starling.utils.MeshSubset;
	import starling.rendering.VertexData;
	import starling.rendering.IndexData;
	
	/**
	 * @externs
	 */
	public class MeshBatch extends Mesh {
		public var batchable:Boolean;
		public function MeshBatch():void { super (null, null); }
		public function addMesh(mesh:Mesh, matrix:openfl.geom.Matrix = null, alpha:Number = 0, subset:starling.utils.MeshSubset = null, ignoreTransformations:Boolean = false):void {}
		public function addMeshAt(mesh:Mesh, indexID:int, vertexID:int):void {}
		public function canAddMesh(mesh:Mesh, numVertices:int = 0):Boolean { return false; }
		public function clear():void {}
		public static function get MAX_NUM_VERTICES ():int { return 0; }
	}
	
}
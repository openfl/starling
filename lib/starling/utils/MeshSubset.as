package starling.utils {

	/**
	 * @externs
	 */
	public class MeshSubset {
		public var indexID:int;
		public var numIndices:int;
		public var numVertices:int;
		public var vertexID:int;
		public function MeshSubset(vertexID:int = 0, numVertices:int = 0, indexID:int = 0, numIndices:int = 0):void {}
		public function setTo(vertexID:int = 0, numVertices:int = 0, indexID:int = 0, numIndices:int = 0):void {}
	}

}
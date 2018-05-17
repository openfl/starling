package starling.rendering {

	import starling.rendering.FilterEffect;
	import starling.rendering.Program;

	/**
	 * @externs
	 */
	public class MeshEffect extends FilterEffect {
		public var alpha:Number;
		public var tinted:Boolean;
		public function MeshEffect():void {}
		public static var VERTEX_FORMAT:VertexDataFormat;
	}

}
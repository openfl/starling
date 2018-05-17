package starling.rendering {

	import starling.rendering.Effect;
	import starling.utils.RenderUtil;
	import starling.rendering.Program;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public class FilterEffect extends Effect {
		public var texture:starling.textures.Texture;
		public var textureRepeat:Boolean;
		public var textureSmoothing:String;
		public function FilterEffect():void {}
		public static var STD_VERTEX_SHADER:String;
		public static var VERTEX_FORMAT:VertexDataFormat;
	}

}
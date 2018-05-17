package starling.display {
	
	import starling.display.Mesh;
	import starling.utils.RectangleUtil;
	import starling.rendering.VertexData;
	import starling.styles.MeshStyle;
	import starling.rendering.IndexData;
	import starling.textures.Texture;
	
	/**
	 * @externs
	 */
	public class Quad extends Mesh {
		public function Quad(width:Number, height:Number, color:uint = 0):void { super (null, null); }
		public function readjustSize(width:Number = 0, height:Number = 0):void {}
		public static function fromTexture(texture:starling.textures.Texture):Quad { return null; }
	}
	
}
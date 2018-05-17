package starling.text {

	import starling.display.MeshBatch;
	import starling.text.ITextCompositor;
	import starling.textures.Texture;
	import starling.utils.SystemUtil;
	import starling.utils.MathUtil;
	// import starling.text.BitmapDataEx;
	import starling.display.Quad;

	/**
	 * @externs
	 */
	public class TrueTypeCompositor implements ITextCompositor {
		public function TrueTypeCompositor():void {}
		public function clearMeshBatch(meshBatch:starling.display.MeshBatch):void {}
		public function dispose():void {}
		public function fillMeshBatch(meshBatch:starling.display.MeshBatch, width:Number, height:Number, text:String, format:TextFormat, options:TextOptions = null):void {}
	}

}
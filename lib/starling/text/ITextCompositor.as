package starling.text {

	import starling.display.MeshBatch;

	/**
	 * @externs
	 */
	public interface ITextCompositor {
		function clearMeshBatch(meshBatch:starling.display.MeshBatch):void;
		function dispose():void;
		function fillMeshBatch(meshBatch:starling.display.MeshBatch, width:Number, height:Number, text:String, format:TextFormat, options:TextOptions = null):void;
	}

}
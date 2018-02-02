package starling.text;



@:jsRequire("starling/text/ITextCompositor", "default")

extern interface ITextCompositor {
	function clearMeshBatch(meshBatch : starling.display.MeshBatch) : Void;
	function dispose() : Void;
	function fillMeshBatch(meshBatch : starling.display.MeshBatch, width : Float, height : Float, text : String, format : TextFormat, ?options : TextOptions) : Void;
}

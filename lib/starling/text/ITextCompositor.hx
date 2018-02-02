package starling.text;



@:jsRequire("starling/text/ITextCompositor", "default")

extern class ITextCompositor implements Dynamic {

	
	function fillMeshBatch(meshBatch:Dynamic, width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, ?options:Dynamic):Dynamic;
	function clearMeshBatch(meshBatch:Dynamic):Dynamic;
	function dispose():Dynamic;


}
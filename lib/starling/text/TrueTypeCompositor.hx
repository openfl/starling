package starling.text;

import starling.text.ITextCompositor;
import starling.textures.Texture;
import Std;
import starling.utils.SystemUtil;
import starling.utils.MathUtil;
// import starling.text.BitmapDataEx;
import starling.display.Quad;

@:jsRequire("starling/text/TrueTypeCompositor", "default")

extern class TrueTypeCompositor implements ITextCompositor {
	function new() : Void;
	function clearMeshBatch(meshBatch : starling.display.MeshBatch) : Void;
	function dispose() : Void;
	function fillMeshBatch(meshBatch : starling.display.MeshBatch, width : Float, height : Float, text : String, format : TextFormat, ?options : TextOptions) : Void;
}

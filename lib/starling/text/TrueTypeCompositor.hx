package starling.text;

import starling.text.ITextCompositor;
import starling.textures.Texture;
import Std;
import starling.utils.SystemUtil;
import starling.utils.MathUtil;
// import starling.text.BitmapDataEx;
import starling.display.Quad;

@:jsRequire("starling/text/TrueTypeCompositor", "default")

extern class TrueTypeCompositor implements Dynamic {

	function new();
	function dispose():Dynamic;
	function fillMeshBatch(meshBatch:Dynamic, width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, ?options:Dynamic):Dynamic;
	function clearMeshBatch(meshBatch:Dynamic):Dynamic;
	function renderText(width:Dynamic, height:Dynamic, text:Dynamic, format:Dynamic, options:Dynamic):Dynamic;
	function autoScaleNativeTextField(textField:Dynamic, text:Dynamic, isHtmlText:Dynamic):Dynamic;
	static var sHelperMatrix:Dynamic;
	static var sHelperQuad:Dynamic;
	static var sNativeTextField:Dynamic;
	static var sNativeFormat:Dynamic;


}
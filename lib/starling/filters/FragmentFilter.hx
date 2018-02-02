package starling.filters;

import starling.events.EventDispatcher;
import starling.core.Starling;
import starling.filters.FilterHelper;
// import starling.filters.FilterQuad;
import starling.utils.Pool;
import Std;
import starling.display.Stage;
import starling.utils.RectangleUtil;
import starling.utils.MatrixUtil;
import js.Boot;
import starling.rendering.FilterEffect;
import starling.rendering.VertexData;
import starling.rendering.IndexData;
import starling.utils.Padding;

@:jsRequire("starling/filters/FragmentFilter", "default")

@:meta(Event(name = "change", type = "starling.events.Event")) @:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent")) extern class FragmentFilter extends starling.events.EventDispatcher {
	var alwaysDrawToBackBuffer(get,set) : Bool;
	var antiAliasing(get,set) : Int;
	var isCached(get,never) : Bool;
	var numPasses(get,never) : Int;
	var padding(get,set) : starling.utils.Padding;
	var resolution(get,set) : Float;
	var textureFormat(get,set) : String;
	var textureSmoothing(get,set) : String;
	function new() : Void;
	function cache() : Void;
	function clearCache() : Void;
	function dispose() : Void;
	function process(painter : starling.rendering.Painter, helper : IFilterHelper, ?input0 : starling.textures.Texture, ?input1 : starling.textures.Texture, ?input2 : starling.textures.Texture, ?input3 : starling.textures.Texture) : starling.textures.Texture;
	function render(painter : starling.rendering.Painter) : Void;
}

package starling.filters;

import starling.events.EventDispatcher;
import starling.core.Starling;
import starling.filters.FilterHelper;
import starling.filters.FilterQuad;
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

extern class FragmentFilter extends starling.events.EventDispatcher implements Dynamic {

	function new();
	var _quad:Dynamic;
	var _target:Dynamic;
	var _effect:Dynamic;
	var _vertexData:Dynamic;
	var _indexData:Dynamic;
	var _padding:Dynamic;
	var _helper:Dynamic;
	var _resolution:Dynamic;
	var _antiAliasing:Dynamic;
	var _textureFormat:Dynamic;
	var _textureSmoothing:Dynamic;
	var _alwaysDrawToBackBuffer:Dynamic;
	var _cacheRequested:Dynamic;
	var _cached:Dynamic;
	function dispose():Dynamic;
	function onContextCreated(event:Dynamic):Dynamic;
	function render(painter:Dynamic):Dynamic;
	function renderPasses(painter:Dynamic, forCache:Dynamic):Dynamic;
	function process(painter:Dynamic, helper:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	function createEffect():Dynamic;
	function cache():Dynamic;
	function clearCache():Dynamic;
	override function addEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	override function removeEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	function onEnterFrame(event:Dynamic):Dynamic;
	var effect:Dynamic;
	function get_effect():Dynamic;
	var vertexData:Dynamic;
	function get_vertexData():Dynamic;
	var indexData:Dynamic;
	function get_indexData():Dynamic;
	function setRequiresRedraw():Dynamic;
	var numPasses:Dynamic;
	function get_numPasses():Dynamic;
	function onTargetAssigned(target:Dynamic):Dynamic;
	var padding:Dynamic;
	function get_padding():Dynamic;
	function set_padding(value:Dynamic):Dynamic;
	var isCached:Dynamic;
	function get_isCached():Dynamic;
	var resolution:Dynamic;
	function get_resolution():Dynamic;
	function set_resolution(value:Dynamic):Dynamic;
	var antiAliasing:Dynamic;
	function get_antiAliasing():Dynamic;
	function set_antiAliasing(value:Dynamic):Dynamic;
	var textureSmoothing:Dynamic;
	function get_textureSmoothing():Dynamic;
	function set_textureSmoothing(value:Dynamic):Dynamic;
	var textureFormat:Dynamic;
	function get_textureFormat():Dynamic;
	function set_textureFormat(value:Dynamic):Dynamic;
	var alwaysDrawToBackBuffer:Dynamic;
	function get_alwaysDrawToBackBuffer():Dynamic;
	function set_alwaysDrawToBackBuffer(value:Dynamic):Dynamic;
	function setTarget(target:Dynamic):Dynamic;
	static var sMatrix3D:Dynamic;


}
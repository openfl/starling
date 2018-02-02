package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.DisplacementMapEffect;

@:jsRequire("starling/filters/DisplacementMapFilter", "default")

extern class DisplacementMapFilter extends starling.filters.FragmentFilter implements Dynamic {

	function new(mapTexture:Dynamic, ?componentX:Dynamic, ?componentY:Dynamic, ?scaleX:Dynamic, ?scaleY:Dynamic);
	var _mapX:Dynamic;
	var _mapY:Dynamic;
	override function process(painter:Dynamic, pool:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	override function createEffect():Dynamic;
	function updateVertexData(inputTexture:Dynamic, mapTexture:Dynamic, ?mapOffsetX:Dynamic, ?mapOffsetY:Dynamic):Dynamic;
	function updatePadding():Dynamic;
	var componentX:Dynamic;
	function get_componentX():Dynamic;
	function set_componentX(value:Dynamic):Dynamic;
	var componentY:Dynamic;
	function get_componentY():Dynamic;
	function set_componentY(value:Dynamic):Dynamic;
	var scaleX:Dynamic;
	function get_scaleX():Dynamic;
	function set_scaleX(value:Dynamic):Dynamic;
	var scaleY:Dynamic;
	function get_scaleY():Dynamic;
	function set_scaleY(value:Dynamic):Dynamic;
	var mapX:Dynamic;
	function get_mapX():Dynamic;
	function set_mapX(value:Dynamic):Dynamic;
	var mapY:Dynamic;
	function get_mapY():Dynamic;
	function set_mapY(value:Dynamic):Dynamic;
	var mapTexture:Dynamic;
	function get_mapTexture():Dynamic;
	function set_mapTexture(value:Dynamic):Dynamic;
	var mapRepeat:Dynamic;
	function get_mapRepeat():Dynamic;
	function set_mapRepeat(value:Dynamic):Dynamic;
	var dispEffect:Dynamic;
	function get_dispEffect():Dynamic;
	static var sBounds:Dynamic;


}
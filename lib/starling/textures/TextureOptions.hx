package starling.textures;

import starling.core.Starling;

@:jsRequire("starling/textures/TextureOptions", "default")

extern class TextureOptions implements Dynamic {

	function new(?scale:Dynamic, ?mipMapping:Dynamic, ?format:Dynamic, ?premultipliedAlpha:Dynamic, ?forcePotTexture:Dynamic);
	var _scale:Dynamic;
	var _format:Dynamic;
	var _mipMapping:Dynamic;
	var _optimizeForRenderToTexture:Dynamic;
	var _premultipliedAlpha:Dynamic;
	var _forcePotTexture:Dynamic;
	function _onReady(a1:Dynamic):Dynamic;
	function clone():Dynamic;
	var scale:Dynamic;
	function get_scale():Dynamic;
	function set_scale(value:Dynamic):Dynamic;
	var format:Dynamic;
	function get_format():Dynamic;
	function set_format(value:Dynamic):Dynamic;
	var mipMapping:Dynamic;
	function get_mipMapping():Dynamic;
	function set_mipMapping(value:Dynamic):Dynamic;
	var optimizeForRenderToTexture:Dynamic;
	function get_optimizeForRenderToTexture():Dynamic;
	function set_optimizeForRenderToTexture(value:Dynamic):Dynamic;
	var forcePotTexture:Dynamic;
	function get_forcePotTexture():Dynamic;
	function set_forcePotTexture(value:Dynamic):Dynamic;
	function onReady(a1:Dynamic):Dynamic;
	function get_onReady():Dynamic;
	function set_onReady(value:Dynamic):Dynamic;
	var premultipliedAlpha:Dynamic;
	function get_premultipliedAlpha():Dynamic;
	function set_premultipliedAlpha(value:Dynamic):Dynamic;


}
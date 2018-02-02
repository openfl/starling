package starling.filters;

import starling.filters.IFilterHelper;
import starling.utils.Pool;
import starling.textures.Texture;
import starling.utils.MathUtil;
import Std;
import starling.textures.SubTexture;
import starling.core.Starling;

@:jsRequire("starling/filters/FilterHelper", "default")

extern class FilterHelper implements Dynamic {

	function new(?textureFormat:Dynamic);
	var _width:Dynamic;
	var _height:Dynamic;
	var _nativeWidth:Dynamic;
	var _nativeHeight:Dynamic;
	var _pool:Dynamic;
	var _usePotTextures:Dynamic;
	var _textureFormat:Dynamic;
	var _preferredScale:Dynamic;
	var _scale:Dynamic;
	var _sizeStep:Dynamic;
	var _numPasses:Dynamic;
	var _projectionMatrix:Dynamic;
	var _renderTarget:Dynamic;
	var _targetBounds:Dynamic;
	var _target:Dynamic;
	var _clipRect:Dynamic;
	var sRegion:Dynamic;
	function dispose():Dynamic;
	function start(numPasses:Dynamic, drawLastPassToBackBuffer:Dynamic):Dynamic;
	function getTexture(?resolution:Dynamic):Dynamic;
	function putTexture(texture:Dynamic):Dynamic;
	function purge():Dynamic;
	function setSize(width:Dynamic, height:Dynamic):Dynamic;
	function getNativeSize(size:Dynamic, textureScale:Dynamic):Dynamic;
	var projectionMatrix3D:Dynamic;
	function get_projectionMatrix3D():Dynamic;
	function set_projectionMatrix3D(value:Dynamic):Dynamic;
	var renderTarget:Dynamic;
	function get_renderTarget():Dynamic;
	function set_renderTarget(value:Dynamic):Dynamic;
	var clipRect:Dynamic;
	function get_clipRect():Dynamic;
	function set_clipRect(value:Dynamic):Dynamic;
	var targetBounds:Dynamic;
	function get_targetBounds():Dynamic;
	function set_targetBounds(value:Dynamic):Dynamic;
	var target:Dynamic;
	function get_target():Dynamic;
	function set_target(value:Dynamic):Dynamic;
	var textureScale:Dynamic;
	function get_textureScale():Dynamic;
	function set_textureScale(value:Dynamic):Dynamic;
	var textureFormat:Dynamic;
	function get_textureFormat():Dynamic;
	function set_textureFormat(value:Dynamic):Dynamic;


}
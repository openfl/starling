package starling.textures;

import starling.textures.Texture;
import starling.errors.NotSupportedError;
import starling.errors.AbstractMethodError;
import starling.utils.Color;
import Std;
import starling.core.Starling;
import js.Boot;

@:jsRequire("starling/textures/ConcreteTexture", "default")

extern class ConcreteTexture extends starling.textures.Texture implements Dynamic {

	function new(base:Dynamic, format:Dynamic, width:Dynamic, height:Dynamic, mipMapping:Dynamic, premultipliedAlpha:Dynamic, ?optimizedForRenderTexture:Dynamic, ?scale:Dynamic);
	var _base:Dynamic;
	var _format:Dynamic;
	var _width:Dynamic;
	var _height:Dynamic;
	var _mipMapping:Dynamic;
	var _premultipliedAlpha:Dynamic;
	var _optimizedForRenderTexture:Dynamic;
	var _scale:Dynamic;
	function _onRestore(a1:Dynamic):Dynamic;
	var _dataUploaded:Dynamic;
	override function dispose():Dynamic;
	function uploadBitmap(bitmap:Dynamic, ?async:Dynamic):Dynamic;
	function uploadBitmapData(data:Dynamic, ?async:Dynamic):Dynamic;
	function uploadAtfData(data:Dynamic, ?offset:Dynamic, ?async:Dynamic):Dynamic;
	function attachNetStream(netStream:Dynamic, ?onComplete:Dynamic):Dynamic;
	function attachVideo(type:Dynamic, attachment:Dynamic, ?onComplete:Dynamic):Dynamic;
	function onContextCreated():Dynamic;
	function createBase():Dynamic;
	function recreateBase():Dynamic;
	function clear(?color:Dynamic, ?alpha:Dynamic):Dynamic;
	function setDataUploaded():Dynamic;
	var optimizedForRenderTexture:Dynamic;
	function get_optimizedForRenderTexture():Dynamic;
	var isPotTexture:Dynamic;
	function get_isPotTexture():Dynamic;
	function onRestore(a1:Dynamic):Dynamic;
	function get_onRestore():Dynamic;
	function set_onRestore(value:Dynamic):Dynamic;
	override function get_base():Dynamic;
	override function get_root():Dynamic;
	override function get_format():Dynamic;
	override function get_width():Dynamic;
	override function get_height():Dynamic;
	override function get_nativeWidth():Dynamic;
	override function get_nativeHeight():Dynamic;
	override function get_scale():Dynamic;
	override function get_mipMapping():Dynamic;
	override function get_premultipliedAlpha():Dynamic;


}
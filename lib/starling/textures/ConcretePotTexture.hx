package starling.textures;

import starling.textures.ConcreteTexture;
import starling.core.Starling;
import Std;
import Reflect;
import js.Boot;
import haxe.Timer;
import starling.utils.MathUtil;

@:jsRequire("starling/textures/ConcretePotTexture", "default")

extern class ConcretePotTexture extends starling.textures.ConcreteTexture implements Dynamic {

	function new(base:Dynamic, format:Dynamic, width:Dynamic, height:Dynamic, mipMapping:Dynamic, premultipliedAlpha:Dynamic, ?optimizedForRenderTexture:Dynamic, ?scale:Dynamic);
	function _textureReadyCallback(a1:Dynamic):Dynamic;
	override function dispose():Dynamic;
	override function createBase():Dynamic;
	override function uploadBitmapData(data:Dynamic, ?async:Dynamic):Dynamic;
	override function get_isPotTexture():Dynamic;
	override function uploadAtfData(data:Dynamic, ?offset:Dynamic, ?async:Dynamic):Dynamic;
	function upload(source:Dynamic, mipLevel:Dynamic, isAsync:Dynamic):Dynamic;
	function uploadAsync(source:Dynamic, mipLevel:Dynamic):Dynamic;
	function onTextureReady(event:Dynamic):Dynamic;
	var potBase:Dynamic;
	function get_potBase():Dynamic;
	static var sMatrix:Dynamic;
	static var sRectangle:Dynamic;
	static var sOrigin:Dynamic;
	static var sAsyncUploadEnabled:Dynamic;
	static var asyncUploadEnabled:Dynamic;
	static function get_asyncUploadEnabled():Dynamic;
	static function set_asyncUploadEnabled(value:Dynamic):Dynamic;


}
package starling.textures;

import starling.textures.ConcreteTexture;
import starling.core.Starling;
import Std;
import Reflect;
import js.Boot;
import haxe.Timer;

@:jsRequire("starling/textures/ConcreteRectangleTexture", "default")

extern class ConcreteRectangleTexture extends starling.textures.ConcreteTexture implements Dynamic {

	function new(base:Dynamic, format:Dynamic, width:Dynamic, height:Dynamic, premultipliedAlpha:Dynamic, ?optimizedForRenderTexture:Dynamic, ?scale:Dynamic);
	function _textureReadyCallback(a1:Dynamic):Dynamic;
	override function uploadBitmapData(data:Dynamic, ?async:Dynamic):Dynamic;
	override function createBase():Dynamic;
	var rectBase:Dynamic;
	function get_rectBase():Dynamic;
	function upload(source:Dynamic, isAsync:Dynamic):Dynamic;
	function uploadAsync(source:Dynamic):Dynamic;
	function onTextureReady(event:Dynamic):Dynamic;
	static var sAsyncUploadEnabled:Dynamic;
	static var asyncUploadEnabled:Dynamic;
	static function get_asyncUploadEnabled():Dynamic;
	static function set_asyncUploadEnabled(value:Dynamic):Dynamic;


}
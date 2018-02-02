package starling.textures;

import starling.textures.ConcreteTexture;
import starling.core.Starling;
import Reflect;

@:jsRequire("starling/textures/ConcreteVideoTexture", "default")

extern class ConcreteVideoTexture extends starling.textures.ConcreteTexture implements Dynamic {

	function new(base:Dynamic, ?scale:Dynamic);
	function _textureReadyCallback(a1:Dynamic):Dynamic;
	var _disposed:Dynamic;
	override function dispose():Dynamic;
	override function createBase():Dynamic;
	override function attachVideo(type:Dynamic, attachment:Dynamic, ?onComplete:Dynamic):Dynamic;
	function onTextureReady(event:Dynamic):Dynamic;
	override function get_nativeWidth():Dynamic;
	override function get_nativeHeight():Dynamic;
	override function get_width():Dynamic;
	override function get_height():Dynamic;
	var videoBase:Dynamic;
	function get_videoBase():Dynamic;


}
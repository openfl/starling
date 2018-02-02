package starling.textures;

import starling.textures.SubTexture;
import starling.core.Starling;
import starling.textures.Texture;
import starling.display.Image;

@:jsRequire("starling/textures/RenderTexture", "default")

extern class RenderTexture extends starling.textures.SubTexture implements Dynamic {

	function new(width:Dynamic, height:Dynamic, ?persistent:Dynamic, ?scale:Dynamic, ?format:Dynamic);
	var _activeTexture:Dynamic;
	var _bufferTexture:Dynamic;
	var _helperImage:Dynamic;
	var _drawing:Dynamic;
	var _bufferReady:Dynamic;
	var _isPersistent:Dynamic;
	override function dispose():Dynamic;
	function draw(object:Dynamic, ?matrix:Dynamic, ?alpha:Dynamic, ?antiAliasing:Dynamic):Dynamic;
	function drawBundled(drawingBlock:Dynamic, ?antiAliasing:Dynamic):Dynamic;
	function __render(object:Dynamic, ?matrix:Dynamic, ?alpha:Dynamic):Dynamic;
	function __renderBundled(renderBlock:Dynamic, ?object:Dynamic, ?matrix:Dynamic, ?alpha:Dynamic, ?antiAliasing:Dynamic):Dynamic;
	function clear(?color:Dynamic, ?alpha:Dynamic):Dynamic;
	var isDoubleBuffered:Dynamic;
	function get_isDoubleBuffered():Dynamic;
	var isPersistent:Dynamic;
	function get_isPersistent():Dynamic;
	override function get_base():Dynamic;
	override function get_root():Dynamic;
	static var USE_DOUBLE_BUFFERING_DATA_NAME:Dynamic;
	static var sClipRect:Dynamic;
	static var useDoubleBuffering:Dynamic;
	static function get_useDoubleBuffering():Dynamic;
	static function set_useDoubleBuffering(value:Dynamic):Dynamic;


}
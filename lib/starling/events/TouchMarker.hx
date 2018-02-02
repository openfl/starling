package starling.events;

import starling.display.Sprite;
import starling.core.Starling;
import Std;
import starling.textures.Texture;
import js.Boot;
import starling.display.Image;

@:jsRequire("starling/events/TouchMarker", "default")

extern class TouchMarker extends starling.display.Sprite implements Dynamic {

	function new();
	var __center:Dynamic;
	var __texture:Dynamic;
	override function dispose():Dynamic;
	function moveMarker(x:Dynamic, y:Dynamic, ?withCenter:Dynamic):Dynamic;
	function moveCenter(x:Dynamic, y:Dynamic):Dynamic;
	function createTexture():Dynamic;
	var realMarker:Dynamic;
	function get_realMarker():Dynamic;
	var mockMarker:Dynamic;
	function get_mockMarker():Dynamic;
	var realX:Dynamic;
	function get_realX():Dynamic;
	var realY:Dynamic;
	function get_realY():Dynamic;
	var mockX:Dynamic;
	function get_mockX():Dynamic;
	var mockY:Dynamic;
	function get_mockY():Dynamic;


}
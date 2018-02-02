package starling.text;

import haxe.ds.IntMap;
import starling.display.Image;

@:jsRequire("starling/text/BitmapChar", "default")

extern class BitmapChar implements Dynamic {

	function new(id:Dynamic, texture:Dynamic, xOffset:Dynamic, yOffset:Dynamic, xAdvance:Dynamic);
	var __texture:Dynamic;
	var __charID:Dynamic;
	var __xOffset:Dynamic;
	var __yOffset:Dynamic;
	var __xAdvance:Dynamic;
	var __kernings:Dynamic;
	function addKerning(charID:Dynamic, amount:Dynamic):Dynamic;
	function getKerning(charID:Dynamic):Dynamic;
	function createImage():Dynamic;
	var charID:Dynamic;
	function get_charID():Dynamic;
	var xOffset:Dynamic;
	function get_xOffset():Dynamic;
	var yOffset:Dynamic;
	function get_yOffset():Dynamic;
	var xAdvance:Dynamic;
	function get_xAdvance():Dynamic;
	var texture:Dynamic;
	function get_texture():Dynamic;
	var width:Dynamic;
	function get_width():Dynamic;
	var height:Dynamic;
	function get_height():Dynamic;


}
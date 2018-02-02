package starling.text;

import haxe.ds.IntMap;
import starling.display.Image;

@:jsRequire("starling/text/BitmapChar", "default")

extern class BitmapChar {
	var charID(get,never) : Int;
	var height(get,never) : Float;
	var texture(get,never) : starling.textures.Texture;
	var width(get,never) : Float;
	var xAdvance(get,never) : Float;
	var xOffset(get,never) : Float;
	var yOffset(get,never) : Float;
	function new(id : Int, texture : starling.textures.Texture, xOffset : Float, yOffset : Float, xAdvance : Float) : Void;
	function addKerning(charID : Int, amount : Float) : Void;
	function createImage() : starling.display.Image;
	function getKerning(charID : Int) : Float;
}

package starling.text;

import starling.text.ITextCompositor;
import Std;
import haxe.Log;
import starling.textures.Texture;
import starling.text.BitmapChar;
import HxOverrides;
import starling.display.Sprite;
// import starling.text.CharLocation;
// import starling.utils.ArrayUtil;
import starling.text.TextOptions;
// import starling.text.MiniBitmapFont;
import haxe.ds.IntMap;
import starling.display.Image;

@:jsRequire("starling/text/BitmapFont", "default")

extern class BitmapFont implements ITextCompositor {
	var baseline(get,set) : Float;
	var lineHeight(get,never) : Float;
	var name(get,never) : String;
	var offsetX(get,set) : Float;
	var offsetY(get,set) : Float;
	var padding(get,set) : Float;
	var size(get,never) : Float;
	var smoothing(get,set) : String;
	function new(?texture : starling.textures.Texture, ?fontXml : Dynamic) : Void;
	function addChar(charID : Int, bitmapChar : BitmapChar) : Void;
	function clearMeshBatch(meshBatch : starling.display.MeshBatch) : Void;
	function createSprite(width : Float, height : Float, text : String, format : TextFormat, ?options : TextOptions) : starling.display.Sprite;
	function dispose() : Void;
	function fillMeshBatch(meshBatch : starling.display.MeshBatch, width : Float, height : Float, text : String, format : TextFormat, ?options : TextOptions) : Void;
	function getChar(charID : Int) : BitmapChar;
	function getCharIDs(?result : openfl.Vector<Int>) : openfl.Vector<Int>;
	function hasChars(text : String) : Bool;
	static var MINI(default,never) : String;
	static var NATIVE_SIZE(default,never) : Int;
}

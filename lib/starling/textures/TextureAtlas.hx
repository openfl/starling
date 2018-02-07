package starling.textures;

import Std;
import starling.textures.SubTexture;
import haxe.ds.StringMap;

@:jsRequire("starling/textures/TextureAtlas", "default")

extern class TextureAtlas {
	var texture(get,never) : Texture;
	function new(texture : Texture, ?atlasXml : Dynamic) : Void;
	function addRegion(name : String, region : openfl.geom.Rectangle, ?frame : openfl.geom.Rectangle, rotated : Bool = false) : Void;
	function dispose() : Void;
	function getFrame(name : String) : openfl.geom.Rectangle;
	function getNames(?prefix : String, ?result : openfl.Vector<String>) : openfl.Vector<String>;
	function getRegion(name : String) : openfl.geom.Rectangle;
	function getRotation(name : String) : Bool;
	function getTexture(name : String) : Texture;
	function getTextures(?prefix : String, ?result : openfl.Vector<Texture>) : openfl.Vector<Texture>;
	function removeRegion(name : String) : Void;
}

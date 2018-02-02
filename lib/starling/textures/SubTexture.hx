package starling.textures;

import starling.textures.Texture;
import haxe.Log;
import Std;

@:jsRequire("starling/textures/SubTexture", "default")

extern class SubTexture extends Texture {
	var ownsParent(get,never) : Bool;
	var parent(get,never) : Texture;
	var region(get,never) : openfl.geom.Rectangle;
	var rotated(get,never) : Bool;
	function new(parent : Texture, ?region : openfl.geom.Rectangle, ownsParent : Bool = false, ?frame : openfl.geom.Rectangle, rotated : Bool = false, scaleModifier : Float = 0) : Void;
}

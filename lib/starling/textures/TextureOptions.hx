package starling.textures;

import starling.core.Starling;

@:jsRequire("starling/textures/TextureOptions", "default")

extern class TextureOptions {
	var forcePotTexture(get,set) : Bool;
	var format(get,set) : String;
	var mipMapping(get,set) : Bool;
	var onReady(get,set) : Texture -> Void;
	var optimizeForRenderToTexture(get,set) : Bool;
	var premultipliedAlpha(get,set) : Bool;
	var scale(get,set) : Float;
	function new(scale : Float = 0, mipMapping : Bool = false, ?format : String, premultipliedAlpha : Bool = false, forcePotTexture : Bool = false) : Void;
	function clone() : TextureOptions;
}

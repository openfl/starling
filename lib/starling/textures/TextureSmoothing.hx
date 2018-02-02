package starling.textures;



@:jsRequire("starling/textures/TextureSmoothing", "default")

extern class TextureSmoothing {
	static var BILINEAR(default,never) : String;
	static var NONE(default,never) : String;
	static var TRILINEAR(default,never) : String;
	static function isValid(smoothing : String) : Bool;
}

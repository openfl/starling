package starling.textures;



@:jsRequire("starling/textures/TextureSmoothing", "default")

extern class TextureSmoothing implements Dynamic {

	static var NONE:Dynamic;
	static var BILINEAR:Dynamic;
	static var TRILINEAR:Dynamic;
	static function isValid(smoothing:Dynamic):Dynamic;


}
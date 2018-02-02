package starling.filters;



@:jsRequire("starling/filters/IFilterHelper", "default")

extern interface IFilterHelper {
	var target(get,never) : starling.display.DisplayObject;
	var targetBounds(get,never) : openfl.geom.Rectangle;
	function getTexture(resolution : Float = 0) : starling.textures.Texture;
	// @:compilerGenerated function get_target() : starling.display.DisplayObject;
	// @:compilerGenerated function get_targetBounds() : openfl.geom.Rectangle;
	function putTexture(texture : starling.textures.Texture) : Void;
}

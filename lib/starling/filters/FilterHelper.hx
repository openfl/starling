package starling.filters;

import starling.filters.IFilterHelper;
import starling.utils.Pool;
import starling.textures.Texture;
import starling.utils.MathUtil;
import Std;
import starling.textures.SubTexture;
import starling.core.Starling;

@:jsRequire("starling/filters/FilterHelper", "default")

extern class FilterHelper implements IFilterHelper {
	var clipRect(get,set) : openfl.geom.Rectangle;
	var projectionMatrix3D(get,set) : openfl.geom.Matrix3D;
	var renderTarget(get,set) : starling.textures.Texture;
	var target(get,set) : starling.display.DisplayObject;
	var targetBounds(get,set) : openfl.geom.Rectangle;
	var textureFormat(get,set) : String;
	var textureScale(get,set) : Float;
	function new(?textureFormat : String) : Void;
	function dispose() : Void;
	function getTexture(resolution : Float = 0) : starling.textures.Texture;
	function purge() : Void;
	function putTexture(texture : starling.textures.Texture) : Void;
	function start(numPasses : Int, drawLastPassToBackBuffer : Bool) : Void;
	
	@:compilerGenerated function get_target() : starling.display.DisplayObject;
	@:compilerGenerated function get_targetBounds() : openfl.geom.Rectangle;
}

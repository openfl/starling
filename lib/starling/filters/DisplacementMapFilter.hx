package starling.filters;

import starling.filters.FragmentFilter;
// import starling.filters.DisplacementMapEffect;

@:jsRequire("starling/filters/DisplacementMapFilter", "default")

extern class DisplacementMapFilter extends FragmentFilter {
	var componentX(get,set) : UInt;
	var componentY(get,set) : UInt;
	var dispEffect(get,never) : starling.rendering.Effect; //DisplacementMapEffect;
	var mapRepeat(get,set) : Bool;
	var mapTexture(get,set) : starling.textures.Texture;
	var mapX(get,set) : Float;
	var mapY(get,set) : Float;
	var scaleX(get,set) : Float;
	var scaleY(get,set) : Float;
	function new(mapTexture : starling.textures.Texture, componentX : UInt = 0, componentY : UInt = 0, scaleX : Float = 0, scaleY : Float = 0) : Void;
}

package starling.filters;



@:jsRequire("starling/filters/CompositeLayer", "default")

extern class CompositeLayer {
	var alpha : Float;
	var color : UInt;
	var replaceColor : Bool;
	var texture : starling.textures.Texture;
	var x : Float;
	var y : Float;
	function new() : Void;
}

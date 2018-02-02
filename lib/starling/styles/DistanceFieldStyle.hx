package starling.styles;

import starling.styles.MeshStyle;
import Std;
import starling.styles.DistanceFieldEffect;
import starling.utils.Color;
import starling.utils.MathUtil;
import js.Boot;

@:jsRequire("starling/styles/DistanceFieldStyle", "default")

extern class DistanceFieldStyle extends MeshStyle {
	var alpha(get,set) : Float;
	var mode(get,set) : String;
	var multiChannel(get,set) : Bool;
	var outerAlphaEnd(get,set) : Float;
	var outerAlphaStart(get,set) : Float;
	var outerColor(get,set) : UInt;
	var outerThreshold(get,set) : Float;
	var shadowOffsetX(get,set) : Float;
	var shadowOffsetY(get,set) : Float;
	var softness(get,set) : Float;
	var threshold(get,set) : Float;
	function new(softness : Float = 0, threshold : Float = 0) : Void;
	function setupBasic() : Void;
	function setupDropShadow(blur : Float = 0, offsetX : Float = 0, offsetY : Float = 0, color : UInt = 0, alpha : Float = 0) : Void;
	function setupGlow(blur : Float = 0, color : UInt = 0, alpha : Float = 0) : Void;
	function setupOutline(width : Float = 0, color : UInt = 0, alpha : Float = 0) : Void;
	static var MODE_BASIC(default,never) : String;
	static var MODE_GLOW(default,never) : String;
	static var MODE_OUTLINE(default,never) : String;
	static var MODE_SHADOW(default,never) : String;
	static var VERTEX_FORMAT : starling.rendering.VertexDataFormat;
}

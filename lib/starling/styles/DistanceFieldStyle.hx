package starling.styles;

import starling.styles.MeshStyle;
import Std;
import starling.styles.DistanceFieldEffect;
import starling.utils.Color;
import starling.utils.MathUtil;
import js.Boot;

@:jsRequire("starling/styles/DistanceFieldStyle", "default")

extern class DistanceFieldStyle extends starling.styles.MeshStyle implements Dynamic {

	function new(?softness:Dynamic, ?threshold:Dynamic);
	var _mode:Dynamic;
	var _multiChannel:Dynamic;
	var _threshold:Dynamic;
	var _alpha:Dynamic;
	var _softness:Dynamic;
	var _outerThreshold:Dynamic;
	var _outerAlphaEnd:Dynamic;
	var _shadowOffsetX:Dynamic;
	var _shadowOffsetY:Dynamic;
	var _outerColor:Dynamic;
	var _outerAlphaStart:Dynamic;
	override function copyFrom(meshStyle:Dynamic):Dynamic;
	override function createEffect():Dynamic;
	override function get_vertexFormat():Dynamic;
	override function onTargetAssigned(target:Dynamic):Dynamic;
	function updateVertices():Dynamic;
	override function batchVertexData(targetStyle:Dynamic, ?targetVertexID:Dynamic, ?matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	override function updateEffect(effect:Dynamic, state:Dynamic):Dynamic;
	override function canBatchWith(meshStyle:Dynamic):Dynamic;
	function setupBasic():Dynamic;
	function setupOutline(?width:Dynamic, ?color:Dynamic, ?alpha:Dynamic):Dynamic;
	function setupGlow(?blur:Dynamic, ?color:Dynamic, ?alpha:Dynamic):Dynamic;
	function setupDropShadow(?blur:Dynamic, ?offsetX:Dynamic, ?offsetY:Dynamic, ?color:Dynamic, ?alpha:Dynamic):Dynamic;
	var mode:Dynamic;
	function get_mode():Dynamic;
	function set_mode(value:Dynamic):Dynamic;
	var multiChannel:Dynamic;
	function get_multiChannel():Dynamic;
	function set_multiChannel(value:Dynamic):Dynamic;
	var threshold:Dynamic;
	function get_threshold():Dynamic;
	function set_threshold(value:Dynamic):Dynamic;
	var softness:Dynamic;
	function get_softness():Dynamic;
	function set_softness(value:Dynamic):Dynamic;
	var alpha:Dynamic;
	function get_alpha():Dynamic;
	function set_alpha(value:Dynamic):Dynamic;
	var outerThreshold:Dynamic;
	function get_outerThreshold():Dynamic;
	function set_outerThreshold(value:Dynamic):Dynamic;
	var outerAlphaStart:Dynamic;
	function get_outerAlphaStart():Dynamic;
	function set_outerAlphaStart(value:Dynamic):Dynamic;
	var outerAlphaEnd:Dynamic;
	function get_outerAlphaEnd():Dynamic;
	function set_outerAlphaEnd(value:Dynamic):Dynamic;
	var outerColor:Dynamic;
	function get_outerColor():Dynamic;
	function set_outerColor(value:Dynamic):Dynamic;
	var shadowOffsetX:Dynamic;
	function get_shadowOffsetX():Dynamic;
	function set_shadowOffsetX(value:Dynamic):Dynamic;
	var shadowOffsetY:Dynamic;
	function get_shadowOffsetY():Dynamic;
	function set_shadowOffsetY(value:Dynamic):Dynamic;
	static var VERTEX_FORMAT:Dynamic;
	static var MODE_BASIC:Dynamic;
	static var MODE_OUTLINE:Dynamic;
	static var MODE_GLOW:Dynamic;
	static var MODE_SHADOW:Dynamic;


}
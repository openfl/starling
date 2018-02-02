package starling.display;

import starling.display.DisplayObjectContainer;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;
import js.Boot;
import starling.display.DisplayObject;
import Std;

@:jsRequire("starling/display/Sprite3D", "default")

extern class Sprite3D extends starling.display.DisplayObjectContainer implements Dynamic {

	function new();
	var __rotationX:Dynamic;
	var __rotationY:Dynamic;
	var __scaleZ:Dynamic;
	var __pivotZ:Dynamic;
	var __z:Dynamic;
	override function render(painter:Dynamic):Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	function __onAddedChild(event:Dynamic):Dynamic;
	function __onRemovedChild(event:Dynamic):Dynamic;
	function __recursivelySetIs3D(object:Dynamic, value:Dynamic):Dynamic;
	override function __updateTransformationMatrices(x:Dynamic, y:Dynamic, pivotX:Dynamic, pivotY:Dynamic, scaleX:Dynamic, scaleY:Dynamic, skewX:Dynamic, skewY:Dynamic, rotation:Dynamic, out:Dynamic, out3D:Dynamic):Dynamic;
	function __updateTransformationMatrices3D(x:Dynamic, y:Dynamic, z:Dynamic, pivotX:Dynamic, pivotY:Dynamic, pivotZ:Dynamic, scaleX:Dynamic, scaleY:Dynamic, scaleZ:Dynamic, rotationX:Dynamic, rotationY:Dynamic, rotationZ:Dynamic, out:Dynamic, out3D:Dynamic):Dynamic;
	override function set_transformationMatrix(value:Dynamic):Dynamic;
	var z:Dynamic;
	function get_z():Dynamic;
	function set_z(value:Dynamic):Dynamic;
	var pivotZ:Dynamic;
	function get_pivotZ():Dynamic;
	function set_pivotZ(value:Dynamic):Dynamic;
	var scaleZ:Dynamic;
	function get_scaleZ():Dynamic;
	function set_scaleZ(value:Dynamic):Dynamic;
	override function set_scale(value:Dynamic):Dynamic;
	override function set_skewX(value:Dynamic):Dynamic;
	override function set_skewY(value:Dynamic):Dynamic;
	var rotationX:Dynamic;
	function get_rotationX():Dynamic;
	function set_rotationX(value:Dynamic):Dynamic;
	var rotationY:Dynamic;
	function get_rotationY():Dynamic;
	function set_rotationY(value:Dynamic):Dynamic;
	var rotationZ:Dynamic;
	function get_rotationZ():Dynamic;
	function set_rotationZ(value:Dynamic):Dynamic;
	var isFlat:Dynamic;
	function get_isFlat():Dynamic;
	static var E:Dynamic;
	static var sHelperPoint:Dynamic;
	static var sHelperPointAlt:Dynamic;
	static var sHelperMatrix:Dynamic;


}
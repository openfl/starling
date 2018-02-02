package starling.utils;

import starling.events.EventDispatcher;

@:jsRequire("starling/utils/Padding", "default")

extern class Padding extends starling.events.EventDispatcher implements Dynamic {

	function new(?left:Dynamic, ?right:Dynamic, ?top:Dynamic, ?bottom:Dynamic);
	var _left:Dynamic;
	var _right:Dynamic;
	var _top:Dynamic;
	var _bottom:Dynamic;
	function setTo(?left:Dynamic, ?right:Dynamic, ?top:Dynamic, ?bottom:Dynamic):Dynamic;
	function setToUniform(value:Dynamic):Dynamic;
	function setToSymmetric(horizontal:Dynamic, vertical:Dynamic):Dynamic;
	function copyFrom(padding:Dynamic):Dynamic;
	function clone():Dynamic;
	var left:Dynamic;
	function get_left():Dynamic;
	function set_left(value:Dynamic):Dynamic;
	var right:Dynamic;
	function get_right():Dynamic;
	function set_right(value:Dynamic):Dynamic;
	var top:Dynamic;
	function get_top():Dynamic;
	function set_top(value:Dynamic):Dynamic;
	var bottom:Dynamic;
	function get_bottom():Dynamic;
	function set_bottom(value:Dynamic):Dynamic;


}
package starling.display;

import starling.display.DisplayObjectContainer;
import starling.utils.RectangleUtil;
import starling.utils.MatrixUtil;
import starling.core.Starling;
import starling.events.EnterFrameEvent;

@:jsRequire("starling/display/Stage", "default")

extern class Stage extends starling.display.DisplayObjectContainer implements Dynamic {

	function new(width:Dynamic, height:Dynamic, ?color:Dynamic);
	var __width:Dynamic;
	var __height:Dynamic;
	var __color:Dynamic;
	var __fieldOfView:Dynamic;
	var __projectionOffset:Dynamic;
	var __cameraPosition:Dynamic;
	var __enterFrameEvent:Dynamic;
	var __enterFrameListeners:Dynamic;
	function advanceTime(passedTime:Dynamic):Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	function getStageBounds(targetSpace:Dynamic, ?out:Dynamic):Dynamic;
	function getCameraPosition(?space:Dynamic, ?out:Dynamic):Dynamic;
	function addEnterFrameListener(listener:Dynamic):Dynamic;
	function removeEnterFrameListener(listener:Dynamic):Dynamic;
	override function __getChildEventListeners(object:Dynamic, eventType:Dynamic, listeners:Dynamic):Dynamic;
	override function set_width(value:Dynamic):Dynamic;
	override function set_height(value:Dynamic):Dynamic;
	override function set_x(value:Dynamic):Dynamic;
	override function set_y(value:Dynamic):Dynamic;
	override function set_scaleX(value:Dynamic):Dynamic;
	override function set_scaleY(value:Dynamic):Dynamic;
	override function set_rotation(value:Dynamic):Dynamic;
	override function set_skewX(value:Dynamic):Dynamic;
	override function set_skewY(value:Dynamic):Dynamic;
	override function set_filter(value:Dynamic):Dynamic;
	var color:Dynamic;
	function get_color():Dynamic;
	function set_color(value:Dynamic):Dynamic;
	var stageWidth:Dynamic;
	function get_stageWidth():Dynamic;
	function set_stageWidth(value:Dynamic):Dynamic;
	var stageHeight:Dynamic;
	function get_stageHeight():Dynamic;
	function set_stageHeight(value:Dynamic):Dynamic;
	var starling:Dynamic;
	function get_starling():Dynamic;
	var focalLength:Dynamic;
	function get_focalLength():Dynamic;
	function set_focalLength(value:Dynamic):Dynamic;
	var fieldOfView:Dynamic;
	function get_fieldOfView():Dynamic;
	function set_fieldOfView(value:Dynamic):Dynamic;
	var projectionOffset:Dynamic;
	function get_projectionOffset():Dynamic;
	function set_projectionOffset(value:Dynamic):Dynamic;
	var cameraPosition:Dynamic;
	function get_cameraPosition():Dynamic;
	static var sMatrix:Dynamic;
	static var sMatrix3D:Dynamic;


}
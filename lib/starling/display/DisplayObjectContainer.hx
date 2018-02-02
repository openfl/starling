package starling.display;

import starling.display.DisplayObject;
import Std;
import starling.utils.MatrixUtil;
import starling.events.Event;
import starling.rendering.BatchToken;

@:jsRequire("starling/display/DisplayObjectContainer", "default")

extern class DisplayObjectContainer extends starling.display.DisplayObject implements Dynamic {

	function new();
	var __children:Dynamic;
	var __touchGroup:Dynamic;
	override function dispose():Dynamic;
	function addChild(child:Dynamic):Dynamic;
	function addChildAt(child:Dynamic, index:Dynamic):Dynamic;
	function removeChild(child:Dynamic, ?dispose:Dynamic):Dynamic;
	function removeChildAt(index:Dynamic, ?dispose:Dynamic):Dynamic;
	function removeChildren(?beginIndex:Dynamic, ?endIndex:Dynamic, ?dispose:Dynamic):Dynamic;
	function getChildAt(index:Dynamic):Dynamic;
	function getChildByName(name:Dynamic):Dynamic;
	function getChildIndex(child:Dynamic):Dynamic;
	function setChildIndex(child:Dynamic, index:Dynamic):Dynamic;
	function swapChildren(child1:Dynamic, child2:Dynamic):Dynamic;
	function swapChildrenAt(index1:Dynamic, index2:Dynamic):Dynamic;
	function sortChildren(compareFunction:Dynamic):Dynamic;
	function contains(child:Dynamic):Dynamic;
	override function getBounds(targetSpace:Dynamic, ?out:Dynamic):Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	override function render(painter:Dynamic):Dynamic;
	function broadcastEvent(event:Dynamic):Dynamic;
	function broadcastEventWith(eventType:Dynamic, ?data:Dynamic):Dynamic;
	var numChildren:Dynamic;
	function get_numChildren():Dynamic;
	var touchGroup:Dynamic;
	function get_touchGroup():Dynamic;
	function set_touchGroup(value:Dynamic):Dynamic;
	function __getChildEventListeners(object:Dynamic, eventType:Dynamic, listeners:Dynamic):Dynamic;
	static var sHelperMatrix:Dynamic;
	static var sHelperPoint:Dynamic;
	static var sBroadcastListeners:Dynamic;
	static var sSortBuffer:Dynamic;
	static var sCacheToken:Dynamic;
	static function mergeSort(input:Dynamic, compareFunc:Dynamic, startIndex:Dynamic, length:Dynamic, buffer:Dynamic):Dynamic;


}
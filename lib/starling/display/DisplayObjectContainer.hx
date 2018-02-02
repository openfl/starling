package starling.display;

import starling.display.DisplayObject;
import Std;
import starling.utils.MatrixUtil;
import starling.events.Event;
import starling.rendering.BatchToken;

@:jsRequire("starling/display/DisplayObjectContainer", "default")

extern class DisplayObjectContainer extends DisplayObject {
	var numChildren(get,never) : Int;
	var touchGroup(get,set) : Bool;
	function addChild(child : DisplayObject) : DisplayObject;
	function addChildAt(child : DisplayObject, index : Int) : DisplayObject;
	function broadcastEvent(event : starling.events.Event) : Void;
	function broadcastEventWith(eventType : String, ?data : Dynamic) : Void;
	function contains(child : DisplayObject) : Bool;
	function getChildAt(index : Int) : DisplayObject;
	function getChildByName(name : String) : DisplayObject;
	function getChildIndex(child : DisplayObject) : Int;
	function removeChild(child : DisplayObject, dispose : Bool = false) : DisplayObject;
	function removeChildAt(index : Int, dispose : Bool = false) : DisplayObject;
	function removeChildren(beginIndex : Int = 0, endIndex : Int = 0, dispose : Bool = false) : Void;
	function setChildIndex(child : DisplayObject, index : Int) : Void;
	function sortChildren(compareFunction : DisplayObject -> DisplayObject -> Int) : Void;
	function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : Void;
	function swapChildrenAt(index1 : Int, index2 : Int) : Void;
}

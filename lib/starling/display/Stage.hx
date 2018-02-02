package starling.display;

import starling.display.DisplayObjectContainer;
import starling.utils.RectangleUtil;
import starling.utils.MatrixUtil;
import starling.core.Starling;
import starling.events.EnterFrameEvent;

@:jsRequire("starling/display/Stage", "default")

@:meta(Event(name = "resize", type = "starling.events.ResizeEvent")) extern class Stage extends DisplayObjectContainer {
	var cameraPosition(get,never) : openfl.geom.Vector3D;
	var color(get,set) : UInt;
	var fieldOfView(get,set) : Float;
	var focalLength(get,set) : Float;
	var projectionOffset(get,set) : openfl.geom.Point;
	var stageHeight(get,set) : Int;
	var stageWidth(get,set) : Int;
	var starling(get,never) : starling.core.Starling;
	function advanceTime(passedTime : Float) : Void;
	function getCameraPosition(?space : DisplayObject, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
	function getStageBounds(targetSpace : DisplayObject, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
}

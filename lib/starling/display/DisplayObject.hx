package starling.display;

import starling.events.EventDispatcher;
import starling.errors.AbstractMethodError;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;
import starling.core.Starling;
import Std;
import starling.display.Stage;
import starling.utils.Color;
import starling.utils.SystemUtil;
import haxe.Log;
import starling.rendering.BatchToken;

@:jsRequire("starling/display/DisplayObject", "default")

@:meta(Event(name = "added", type = "starling.events.Event")) @:meta(Event(name = "addedToStage", type = "starling.events.Event")) @:meta(Event(name = "removed", type = "starling.events.Event")) @:meta(Event(name = "removedFromStage", type = "starling.events.Event")) @:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent")) @:meta(Event(name = "touch", type = "starling.events.TouchEvent")) @:meta(Event(name = "keyUp", type = "starling.events.KeyboardEvent")) @:meta(Event(name = "keyDown", type = "starling.events.KeyboardEvent")) extern class DisplayObject extends starling.events.EventDispatcher {
	var alpha(get,set) : Float;
	var base(get,never) : DisplayObject;
	var blendMode(get,set) : String;
	var bounds(get,never) : openfl.geom.Rectangle;
	var filter(get,set) : starling.filters.FragmentFilter;
	var height(get,set) : Float;
	var is3D(get,never) : Bool;
	var mask(get,set) : DisplayObject;
	var maskInverted(get,set) : Bool;
	var name(get,set) : String;
	var parent(get,never) : DisplayObjectContainer;
	var pivotX(get,set) : Float;
	var pivotY(get,set) : Float;
	var requiresRedraw(get,never) : Bool;
	var root(get,never) : DisplayObject;
	var rotation(get,set) : Float;
	var scale(get,set) : Float;
	var scaleX(get,set) : Float;
	var scaleY(get,set) : Float;
	var skewX(get,set) : Float;
	var skewY(get,set) : Float;
	var stage(get,never) : Stage;
	var touchable(get,set) : Bool;
	var transformationMatrix(get,set) : openfl.geom.Matrix;
	var transformationMatrix3D(get,never) : openfl.geom.Matrix3D;
	var useHandCursor(get,set) : Bool;
	var visible(get,set) : Bool;
	var width(get,set) : Float;
	var x(get,set) : Float;
	var y(get,set) : Float;
	function alignPivot(?horizontalAlign : String, ?verticalAlign : String) : Void;
	function dispose() : Void;
	function drawToBitmapData(?out : openfl.display.BitmapData, color : UInt = 0, alpha : Float = 0) : openfl.display.BitmapData;
	function getBounds(targetSpace : DisplayObject, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	function getTransformationMatrix(targetSpace : DisplayObject, ?out : openfl.geom.Matrix) : openfl.geom.Matrix;
	function getTransformationMatrix3D(targetSpace : DisplayObject, ?out : openfl.geom.Matrix3D) : openfl.geom.Matrix3D;
	function globalToLocal(globalPoint : openfl.geom.Point, ?out : openfl.geom.Point) : openfl.geom.Point;
	function globalToLocal3D(globalPoint : openfl.geom.Point, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
	function hitTest(localPoint : openfl.geom.Point) : DisplayObject;
	function hitTestMask(localPoint : openfl.geom.Point) : Bool;
	function local3DToGlobal(localPoint : openfl.geom.Vector3D, ?out : openfl.geom.Point) : openfl.geom.Point;
	function localToGlobal(localPoint : openfl.geom.Point, ?out : openfl.geom.Point) : openfl.geom.Point;
	function removeFromParent(dispose : Bool = false) : Void;
	function render(painter : starling.rendering.Painter) : Void;
	function setRequiresRedraw() : Void;
}

import starling_display_DisplayObject from "./../../starling/display/DisplayObject";
import Std from "./../../Std";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_RangeError from "openfl/errors/RangeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_events_Event from "./../../starling/events/Event";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Point from "openfl/geom/Point";
import openfl_Vector from "openfl/Vector";
import starling_rendering_BatchToken from "./../../starling/rendering/BatchToken";

declare namespace starling.display {

export class DisplayObjectContainer extends starling_display_DisplayObject {

	constructor();
	__children:any;
	__touchGroup:any;
	dispose():any;
	addChild(child:any):any;
	addChildAt(child:any, index:any):any;
	removeChild(child:any, dispose?:any):any;
	removeChildAt(index:any, dispose?:any):any;
	removeChildren(beginIndex?:any, endIndex?:any, dispose?:any):any;
	getChildAt(index:any):any;
	getChildByName(name:any):any;
	getChildIndex(child:any):any;
	setChildIndex(child:any, index:any):any;
	swapChildren(child1:any, child2:any):any;
	swapChildrenAt(index1:any, index2:any):any;
	sortChildren(compareFunction:any):any;
	contains(child:any):any;
	getBounds(targetSpace:any, out?:any):any;
	hitTest(localPoint:any):any;
	render(painter:any):any;
	broadcastEvent(event:any):any;
	broadcastEventWith(eventType:any, data?:any):any;
	numChildren:any;
	get_numChildren():any;
	touchGroup:any;
	get_touchGroup():any;
	set_touchGroup(value:any):any;
	__getChildEventListeners(object:any, eventType:any, listeners:any):any;
	static sHelperMatrix:any;
	static sHelperPoint:any;
	static sBroadcastListeners:any;
	static sSortBuffer:any;
	static sCacheToken:any;
	static mergeSort(input:any, compareFunc:any, startIndex:any, length:any, buffer:any):any;


}

}

export default starling.display.DisplayObjectContainer;
import openfl_geom_Point from "openfl/geom/Point";
import starling_utils_StringUtil from "./../../starling/utils/StringUtil";
import openfl_Vector from "openfl/Vector";

declare namespace starling.events {

export class Touch {

	constructor(id:any);
	__id:any;
	__globalX:any;
	__globalY:any;
	__previousGlobalX:any;
	__previousGlobalY:any;
	__tapCount:any;
	__phase:any;
	__target:any;
	__timestamp:any;
	__pressure:any;
	__width:any;
	__height:any;
	__cancelled:any;
	__bubbleChain:any;
	getLocation(space:any, out?:any):any;
	getPreviousLocation(space:any, out?:any):any;
	getMovement(space:any, out?:any):any;
	isTouching(target:any):any;
	toString():any;
	clone():any;
	updateBubbleChain():any;
	id:any;
	get_id():any;
	previousGlobalX:any;
	get_previousGlobalX():any;
	previousGlobalY:any;
	get_previousGlobalY():any;
	globalX:any;
	get_globalX():any;
	set_globalX(value:any):any;
	globalY:any;
	get_globalY():any;
	set_globalY(value:any):any;
	tapCount:any;
	get_tapCount():any;
	set_tapCount(value:any):any;
	phase:any;
	get_phase():any;
	set_phase(value:any):any;
	target:any;
	get_target():any;
	set_target(value:any):any;
	timestamp:any;
	get_timestamp():any;
	set_timestamp(value:any):any;
	pressure:any;
	get_pressure():any;
	set_pressure(value:any):any;
	width:any;
	get_width():any;
	set_width(value:any):any;
	height:any;
	get_height():any;
	set_height(value:any):any;
	cancelled:any;
	get_cancelled():any;
	set_cancelled(value:any):any;
	dispatchEvent(event:any):any;
	bubbleChain:any;
	get_bubbleChain():any;
	static sHelperPoint:any;


}

}

export default starling.events.Touch;
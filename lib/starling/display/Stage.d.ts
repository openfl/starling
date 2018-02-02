import starling_display_DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";
import starling_core_Starling from "./../../starling/core/Starling";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import openfl_geom_Point from "openfl/geom/Point";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import starling_events_EnterFrameEvent from "./../../starling/events/EnterFrameEvent";
import openfl_Vector from "openfl/Vector";

declare namespace starling.display {

export class Stage extends starling_display_DisplayObjectContainer {

	constructor(width:any, height:any, color?:any);
	__width:any;
	__height:any;
	__color:any;
	__fieldOfView:any;
	__projectionOffset:any;
	__cameraPosition:any;
	__enterFrameEvent:any;
	__enterFrameListeners:any;
	advanceTime(passedTime:any):any;
	hitTest(localPoint:any):any;
	getStageBounds(targetSpace:any, out?:any):any;
	getCameraPosition(space?:any, out?:any):any;
	addEnterFrameListener(listener:any):any;
	removeEnterFrameListener(listener:any):any;
	__getChildEventListeners(object:any, eventType:any, listeners:any):any;
	set_width(value:any):any;
	set_height(value:any):any;
	set_x(value:any):any;
	set_y(value:any):any;
	set_scaleX(value:any):any;
	set_scaleY(value:any):any;
	set_rotation(value:any):any;
	set_skewX(value:any):any;
	set_skewY(value:any):any;
	set_filter(value:any):any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	stageWidth:any;
	get_stageWidth():any;
	set_stageWidth(value:any):any;
	stageHeight:any;
	get_stageHeight():any;
	set_stageHeight(value:any):any;
	starling:any;
	get_starling():any;
	focalLength:any;
	get_focalLength():any;
	set_focalLength(value:any):any;
	fieldOfView:any;
	get_fieldOfView():any;
	set_fieldOfView(value:any):any;
	projectionOffset:any;
	get_projectionOffset():any;
	set_projectionOffset(value:any):any;
	cameraPosition:any;
	get_cameraPosition():any;
	static sMatrix:any;
	static sMatrix3D:any;


}

}

export default starling.display.Stage;
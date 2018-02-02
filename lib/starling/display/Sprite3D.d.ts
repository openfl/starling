import starling_display_DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import js_Boot from "./../../js/Boot";
import starling_display_DisplayObject from "./../../starling/display/DisplayObject";
import Std from "./../../Std";
import openfl_geom_Vector3D from "openfl/geom/Vector3D";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_Error from "openfl/errors/Error";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";

declare namespace starling.display {

export class Sprite3D extends starling_display_DisplayObjectContainer {

	constructor();
	__rotationX:any;
	__rotationY:any;
	__scaleZ:any;
	__pivotZ:any;
	__z:any;
	render(painter:any):any;
	hitTest(localPoint:any):any;
	__onAddedChild(event:any):any;
	__onRemovedChild(event:any):any;
	__recursivelySetIs3D(object:any, value:any):any;
	__updateTransformationMatrices(x:any, y:any, pivotX:any, pivotY:any, scaleX:any, scaleY:any, skewX:any, skewY:any, rotation:any, out:any, out3D:any):any;
	__updateTransformationMatrices3D(x:any, y:any, z:any, pivotX:any, pivotY:any, pivotZ:any, scaleX:any, scaleY:any, scaleZ:any, rotationX:any, rotationY:any, rotationZ:any, out:any, out3D:any):any;
	set_transformationMatrix(value:any):any;
	z:any;
	get_z():any;
	set_z(value:any):any;
	pivotZ:any;
	get_pivotZ():any;
	set_pivotZ(value:any):any;
	scaleZ:any;
	get_scaleZ():any;
	set_scaleZ(value:any):any;
	set_scale(value:any):any;
	set_skewX(value:any):any;
	set_skewY(value:any):any;
	rotationX:any;
	get_rotationX():any;
	set_rotationX(value:any):any;
	rotationY:any;
	get_rotationY():any;
	set_rotationY(value:any):any;
	rotationZ:any;
	get_rotationZ():any;
	set_rotationZ(value:any):any;
	isFlat:any;
	get_isFlat():any;
	static E:any;
	static sHelperPoint:any;
	static sHelperPointAlt:any;
	static sHelperMatrix:any;


}

}

export default starling.display.Sprite3D;
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import openfl_display3D__$Context3DTriangleFace_Context3DTriangleFace_$Impl_$ from "./../../openfl/display3D/_Context3DTriangleFace/Context3DTriangleFace_Impl_";
import openfl_display3D__$Context3DCompareMode_Context3DCompareMode_$Impl_$ from "./../../openfl/display3D/_Context3DCompareMode/Context3DCompareMode_Impl_";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_utils_Pool from "./../../starling/utils/Pool";
import Std from "./../../Std";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_Vector from "openfl/Vector";

declare namespace starling.rendering {

export class RenderState {

	constructor();
	_alpha:any;
	_blendMode:any;
	_modelviewMatrix:any;
	_miscOptions:any;
	_clipRect:any;
	_renderTarget:any;
	_onDrawRequired():any;
	_modelviewMatrix3D:any;
	_projectionMatrix3D:any;
	_projectionMatrix3DRev:any;
	_mvpMatrix3D:any;
	copyFrom(renderState:any):any;
	reset():any;
	transformModelviewMatrix(matrix:any):any;
	transformModelviewMatrix3D(matrix:any):any;
	setProjectionMatrix(x:any, y:any, width:any, height:any, stageWidth?:any, stageHeight?:any, cameraPos?:any):any;
	setProjectionMatrixChanged():any;
	setModelviewMatricesToIdentity():any;
	modelviewMatrix:any;
	get_modelviewMatrix():any;
	set_modelviewMatrix(value:any):any;
	modelviewMatrix3D:any;
	get_modelviewMatrix3D():any;
	set_modelviewMatrix3D(value:any):any;
	projectionMatrix3D:any;
	get_projectionMatrix3D():any;
	set_projectionMatrix3D(value:any):any;
	mvpMatrix3D:any;
	get_mvpMatrix3D():any;
	setRenderTarget(target:any, enableDepthAndStencil?:any, antiAlias?:any):any;
	alpha:any;
	get_alpha():any;
	set_alpha(value:any):any;
	blendMode:any;
	get_blendMode():any;
	set_blendMode(value:any):any;
	renderTarget:any;
	get_renderTarget():any;
	set_renderTarget(value:any):any;
	renderTargetBase:any;
	get_renderTargetBase():any;
	renderTargetOptions:any;
	get_renderTargetOptions():any;
	culling:any;
	get_culling():any;
	set_culling(value:any):any;
	depthMask:any;
	get_depthMask():any;
	set_depthMask(value:any):any;
	depthTest:any;
	get_depthTest():any;
	set_depthTest(value:any):any;
	clipRect:any;
	get_clipRect():any;
	set_clipRect(value:any):any;
	renderTargetAntiAlias:any;
	get_renderTargetAntiAlias():any;
	renderTargetSupportsDepthAndStencil:any;
	get_renderTargetSupportsDepthAndStencil():any;
	is3D:any;
	get_is3D():any;
	onDrawRequired():any;
	get_onDrawRequired():any;
	set_onDrawRequired(value:any):any;
	static CULLING_VALUES:any;
	static COMPARE_VALUES:any;
	static sMatrix3D:any;
	static sProjectionMatrix3DRev:any;


}

}

export default starling.rendering.RenderState;
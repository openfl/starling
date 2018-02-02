package starling.rendering;

import starling.utils.RectangleUtil;
import starling.utils.MatrixUtil;
import starling.utils.Pool;
import Std;
import starling.utils.MathUtil;

@:jsRequire("starling/rendering/RenderState", "default")

extern class RenderState implements Dynamic {

	function new();
	var _alpha:Dynamic;
	var _blendMode:Dynamic;
	var _modelviewMatrix:Dynamic;
	var _miscOptions:Dynamic;
	var _clipRect:Dynamic;
	var _renderTarget:Dynamic;
	function _onDrawRequired():Dynamic;
	var _modelviewMatrix3D:Dynamic;
	var _projectionMatrix3D:Dynamic;
	var _projectionMatrix3DRev:Dynamic;
	var _mvpMatrix3D:Dynamic;
	function copyFrom(renderState:Dynamic):Dynamic;
	function reset():Dynamic;
	function transformModelviewMatrix(matrix:Dynamic):Dynamic;
	function transformModelviewMatrix3D(matrix:Dynamic):Dynamic;
	function setProjectionMatrix(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic, ?stageWidth:Dynamic, ?stageHeight:Dynamic, ?cameraPos:Dynamic):Dynamic;
	function setProjectionMatrixChanged():Dynamic;
	function setModelviewMatricesToIdentity():Dynamic;
	var modelviewMatrix:Dynamic;
	function get_modelviewMatrix():Dynamic;
	function set_modelviewMatrix(value:Dynamic):Dynamic;
	var modelviewMatrix3D:Dynamic;
	function get_modelviewMatrix3D():Dynamic;
	function set_modelviewMatrix3D(value:Dynamic):Dynamic;
	var projectionMatrix3D:Dynamic;
	function get_projectionMatrix3D():Dynamic;
	function set_projectionMatrix3D(value:Dynamic):Dynamic;
	var mvpMatrix3D:Dynamic;
	function get_mvpMatrix3D():Dynamic;
	function setRenderTarget(target:Dynamic, ?enableDepthAndStencil:Dynamic, ?antiAlias:Dynamic):Dynamic;
	var alpha:Dynamic;
	function get_alpha():Dynamic;
	function set_alpha(value:Dynamic):Dynamic;
	var blendMode:Dynamic;
	function get_blendMode():Dynamic;
	function set_blendMode(value:Dynamic):Dynamic;
	var renderTarget:Dynamic;
	function get_renderTarget():Dynamic;
	function set_renderTarget(value:Dynamic):Dynamic;
	var renderTargetBase:Dynamic;
	function get_renderTargetBase():Dynamic;
	var renderTargetOptions:Dynamic;
	function get_renderTargetOptions():Dynamic;
	var culling:Dynamic;
	function get_culling():Dynamic;
	function set_culling(value:Dynamic):Dynamic;
	var depthMask:Dynamic;
	function get_depthMask():Dynamic;
	function set_depthMask(value:Dynamic):Dynamic;
	var depthTest:Dynamic;
	function get_depthTest():Dynamic;
	function set_depthTest(value:Dynamic):Dynamic;
	var clipRect:Dynamic;
	function get_clipRect():Dynamic;
	function set_clipRect(value:Dynamic):Dynamic;
	var renderTargetAntiAlias:Dynamic;
	function get_renderTargetAntiAlias():Dynamic;
	var renderTargetSupportsDepthAndStencil:Dynamic;
	function get_renderTargetSupportsDepthAndStencil():Dynamic;
	var is3D:Dynamic;
	function get_is3D():Dynamic;
	function onDrawRequired():Dynamic;
	function get_onDrawRequired():Dynamic;
	function set_onDrawRequired(value:Dynamic):Dynamic;
	static var CULLING_VALUES:Dynamic;
	static var COMPARE_VALUES:Dynamic;
	static var sMatrix3D:Dynamic;
	static var sProjectionMatrix3DRev:Dynamic;


}
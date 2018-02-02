package starling.rendering;

import starling.utils.RectangleUtil;
import starling.utils.MatrixUtil;
import starling.utils.Pool;
import Std;
import starling.utils.MathUtil;

@:jsRequire("starling/rendering/RenderState", "default")

extern class RenderState {
	var alpha(get,set) : Float;
	var blendMode(get,set) : String;
	var clipRect(get,set) : openfl.geom.Rectangle;
	var culling(get,set) : String;
	var depthMask(get,set) : Bool;
	var depthTest(get,set) : String;
	var is3D(get,never) : Bool;
	var modelviewMatrix(get,set) : openfl.geom.Matrix;
	var modelviewMatrix3D(get,set) : openfl.geom.Matrix3D;
	var mvpMatrix3D(get,never) : openfl.geom.Matrix3D;
	var projectionMatrix3D(get,set) : openfl.geom.Matrix3D;
	var renderTarget(get,set) : starling.textures.Texture;
	var renderTargetAntiAlias(get,never) : Int;
	var renderTargetSupportsDepthAndStencil(get,never) : Bool;
	function new() : Void;
	function copyFrom(renderState : RenderState) : Void;
	function reset() : Void;
	function setModelviewMatricesToIdentity() : Void;
	function setProjectionMatrix(x : Float, y : Float, width : Float, height : Float, stageWidth : Float = 0, stageHeight : Float = 0, ?cameraPos : openfl.geom.Vector3D) : Void;
	function setProjectionMatrixChanged() : Void;
	function setRenderTarget(target : starling.textures.Texture, enableDepthAndStencil : Bool = false, antiAlias : Int = 0) : Void;
	function transformModelviewMatrix(matrix : openfl.geom.Matrix) : Void;
	function transformModelviewMatrix3D(matrix : openfl.geom.Matrix3D) : Void;
}

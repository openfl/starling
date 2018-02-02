package starling.rendering;

import haxe.ds.ObjectMap;
import starling.utils.RenderUtil;
import starling.utils.SystemUtil;
import Std;
import starling.rendering.RenderState;
import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;
import starling.utils.Pool;
import starling.display.Quad;
import starling.utils.MathUtil;
import starling.display.BlendMode;
import haxe.ds.StringMap;
import starling.utils.MeshSubset;
import starling.rendering.BatchProcessor;

@:jsRequire("starling/rendering/Painter", "default")

extern class Painter {
	var backBufferHeight(get,never) : Int;
	var backBufferScaleFactor(get,never) : Float;
	var backBufferWidth(get,never) : Int;
	var cacheEnabled(get,set) : Bool;
	var context(get,never) : openfl.display3D.Context3D;
	var contextValid(get,never) : Bool;
	var drawCount(get,set) : Int;
	var enableErrorChecking(get,set) : Bool;
	var frameID(get,set) : UInt;
	var pixelSize(get,set) : Float;
	var profile(get,never) : String;
	var shareContext(get,set) : Bool;
	var sharedData(get,never) : Map<String,Dynamic>;
	var stage3D(get,never) : openfl.display.Stage3D;
	var state(get,never) : RenderState;
	var stencilReferenceValue(get,set) : UInt;
	function new(stage3D : openfl.display.Stage3D) : Void;
	function batchMesh(mesh : starling.display.Mesh, ?subset : starling.utils.MeshSubset) : Void;
	function clear(rgb : UInt = 0, alpha : Float = 0) : Void;
	function configureBackBuffer(viewPort : openfl.geom.Rectangle, contentScaleFactor : Float, antiAlias : Int, enableDepthAndStencil : Bool) : Void;
	function deleteProgram(name : String) : Void;
	function dispose() : Void;
	function drawFromCache(startToken : BatchToken, endToken : BatchToken) : Void;
	function drawMask(mask : starling.display.DisplayObject, ?maskee : starling.display.DisplayObject) : Void;
	function eraseMask(mask : starling.display.DisplayObject, ?maskee : starling.display.DisplayObject) : Void;
	function excludeFromCache(object : starling.display.DisplayObject) : Void;
	function fillToken(token : BatchToken) : Void;
	function finishFrame() : Void;
	function finishMeshBatch() : Void;
	function getProgram(name : String) : Program;
	function hasProgram(name : String) : Bool;
	function nextFrame() : Void;
	function popState(?token : BatchToken) : Void;
	function prepareToDraw() : Void;
	function present() : Void;
	function pushState(?token : BatchToken) : Void;
	function registerProgram(name : String, program : Program) : Void;
	function requestContext3D(renderMode : String, profile : Dynamic) : Void;
	function restoreState() : Void;
	function setStateTo(transformationMatrix : openfl.geom.Matrix, alphaFactor : Float = 0, ?blendMode : String) : Void;
	function setupContextDefaults() : Void;
	static var DEFAULT_STENCIL_VALUE(default,never) : UInt;
}

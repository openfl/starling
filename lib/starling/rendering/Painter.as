package starling.rendering {

	import openfl.display3D.Context3D;
	import openfl.display.Stage3D;
	import openfl.geom.Matrix;
	import openfl.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Mesh;
	import starling.utils.RenderUtil;
	import starling.utils.SystemUtil;
	import starling.rendering.RenderState;
	import starling.utils.MatrixUtil;
	import starling.utils.RectangleUtil;
	import starling.utils.Pool;
	import starling.display.Quad;
	import starling.utils.MathUtil;
	import starling.display.BlendMode;
	import starling.utils.MeshSubset;
	import starling.rendering.BatchProcessor;

	/**
	 * @externs
	 */
	public class Painter {
		public function get backBufferHeight():int { return 0; }
		public function get backBufferScaleFactor():Number { return 0; }
		public function get backBufferWidth():int { return 0; }
		public var cacheEnabled:Boolean;
		public function get context():openfl.display3D.Context3D { return null; }
		public function get contextValid():Boolean { return false; }
		public var drawCount:int;
		public var enableErrorChecking:Boolean;
		public var frameID:uint;
		public var pixelSize:Number;
		public function get profile():String { return null; }
		public var shareContext:Boolean;
		public function get sharedData():Object { return null; }
		public function get stage3D():openfl.display.Stage3D { return null; }
		public function get state():RenderState { return null; }
		public var stencilReferenceValue:uint;
		public function Painter(stage3D:openfl.display.Stage3D):void {}
		public function batchMesh(mesh:starling.display.Mesh, subset:starling.utils.MeshSubset = null):void {}
		public function clear(rgb:uint = 0, alpha:Number = 0):void {}
		public function configureBackBuffer(viewPort:openfl.geom.Rectangle, contentScaleFactor:Number, antiAlias:int, enableDepthAndStencil:Boolean, supportBrowserZoom:Boolean=false):void {}
		public function deleteProgram(name:String):void {}
		public function dispose():void {}
		public function drawFromCache(startToken:BatchToken, endToken:BatchToken):void {}
		public function drawMask(mask:starling.display.DisplayObject, maskee:starling.display.DisplayObject = null):void {}
		public function eraseMask(mask:starling.display.DisplayObject, maskee:starling.display.DisplayObject = null):void {}
		public function excludeFromCache(object:starling.display.DisplayObject):void {}
		public function fillToken(token:BatchToken):void {}
		public function enableBatchTrimming(enabled:Boolean=true, interval:int=250):void {}
		public function finishFrame():void {}
		public function finishMeshBatch():void {}
		public function getProgram(name:String):Program { return null; }
		public function hasProgram(name:String):Boolean { return false; }
		public function nextFrame():void {}
		public function popState(token:BatchToken = null):void {}
		public function prepareToDraw():void {}
		public function present():void {}
		public function pushState(token:BatchToken = null):void {}
		public function registerProgram(name:String, program:Program):void {}
		public function requestContext3D(renderMode:String, profile:Object):void {}
		public function restoreState():void {}
		public function setStateTo(transformationMatrix:openfl.geom.Matrix, alphaFactor:Number = 0, blendMode:String = null):void {}
		public function setupContextDefaults():void {}
		public function refreshBackBufferSize(scaleFactor:Number):void {}
		public static function get DEFAULT_STENCIL_VALUE ():uint { return 0; }
	}

}
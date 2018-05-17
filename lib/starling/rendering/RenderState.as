package starling.rendering {

	import openfl.geom.Matrix;
	import openfl.geom.Rectangle;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class RenderState {
		public var alpha:Number;
		public var blendMode:String;
		public var clipRect:openfl.geom.Rectangle;
		public var culling:String;
		public var depthMask:Boolean;
		public var depthTest:String;
		public function get is3D():Boolean { return false; }
		public var modelviewMatrix:openfl.geom.Matrix;
		public var modelviewMatrix3D:openfl.geom.Matrix3D;
		public function get mvpMatrix3D():openfl.geom.Matrix3D { return null; }
		public var projectionMatrix3D:openfl.geom.Matrix3D;
		public var renderTarget:starling.textures.Texture;
		public function get renderTargetAntiAlias():int { return 0; }
		public function get renderTargetSupportsDepthAndStencil():Boolean { return false; }
		public function RenderState():void {}
		public function copyFrom(renderState:RenderState):void {}
		public function reset():void {}
		public function setModelviewMatricesToIdentity():void {}
		public function setProjectionMatrix(x:Number, y:Number, width:Number, height:Number, stageWidth:Number = 0, stageHeight:Number = 0, cameraPos:openfl.geom.Vector3D = null):void {}
		public function setProjectionMatrixChanged():void {}
		public function setRenderTarget(target:starling.textures.Texture, enableDepthAndStencil:Boolean = false, antiAlias:int = 0):void {}
		public function transformModelviewMatrix(matrix:openfl.geom.Matrix):void {}
		public function transformModelviewMatrix3D(matrix:openfl.geom.Matrix3D):void {}
	}

}
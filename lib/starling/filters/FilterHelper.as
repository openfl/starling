package starling.filters {

	import openfl.geom.Matrix3D;
	import openfl.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.filters.IFilterHelper;
	import starling.utils.Pool;
	import starling.textures.Texture;
	import starling.utils.MathUtil;
	import starling.textures.SubTexture;
	import starling.core.Starling;

	/**
	 * @externs
	 */
	public class FilterHelper implements IFilterHelper {
		public var clipRect:openfl.geom.Rectangle;
		public var projectionMatrix3D:openfl.geom.Matrix3D;
		public var renderTarget:starling.textures.Texture;
		// public var target:starling.display.DisplayObject;
		// public var targetBounds:openfl.geom.Rectangle;
		public var textureFormat:String;
		public var textureScale:Number;
		public function FilterHelper(textureFormat:String = null):void {}
		public function dispose():void {}
		public function getTexture(resolution:Number = 0):starling.textures.Texture { return null; }
		public function purge():void {}
		public function putTexture(texture:starling.textures.Texture):void {}
		public function start(numPasses:int, drawLastPassToBackBuffer:Boolean):void {}
		
		public function get target():starling.display.DisplayObject { return null; }
		public function set target(value:DisplayObject):void {}
		public function get targetBounds():openfl.geom.Rectangle { return null; }
		public function set targetBounds(value:Rectangle):void {}
	}

}
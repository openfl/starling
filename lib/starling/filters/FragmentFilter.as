package starling.filters {

	import starling.events.EventDispatcher;
	import starling.core.Starling;
	import starling.filters.FilterHelper;
	// import starling.filters.FilterQuad;
	import starling.utils.Pool;
	import starling.utils.Padding;
	import starling.display.Stage;
	import starling.utils.RectangleUtil;
	import starling.utils.MatrixUtil;
	import starling.rendering.FilterEffect;
	import starling.rendering.Painter;
	import starling.rendering.VertexData;
	import starling.rendering.IndexData;
	import starling.textures.Texture;
	import starling.utils.Padding;

	// @:meta(Event(name = "change", type = "starling.events.Event")) @:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent"))

	/**
	 * @externs
	 */
	public class FragmentFilter extends starling.events.EventDispatcher {
		public var alwaysDrawToBackBuffer:Boolean;
		public var antiAliasing:int;
		public function get isCached():Boolean { return false; }
		public function get numPasses():int { return 0; }
		public var padding:starling.utils.Padding;
		public var resolution:Number;
		public var textureFormat:String;
		public var textureSmoothing:String;
		public function FragmentFilter():void {}
		public function cache():void {}
		public function clearCache():void {}
		public function dispose():void {}
		public function process(painter:starling.rendering.Painter, helper:IFilterHelper, input0:starling.textures.Texture = null, input1:starling.textures.Texture = null, input2:starling.textures.Texture = null, input3:starling.textures.Texture = null):starling.textures.Texture { return null; }
		public function render(painter:starling.rendering.Painter):void {}
	}

}
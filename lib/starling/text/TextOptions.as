package starling.text {

	import starling.events.EventDispatcher;
	import starling.core.Starling;
	import starling.text.TextField;

	// @:meta(Event(name = "change", type = "starling.events.Event")) 

	/**
	 * @externs
	 */
	public class TextOptions extends starling.events.EventDispatcher {
		public var autoScale:Boolean;
		public var autoSize:String;
		public var isHtmlText:Boolean;
		public var padding:Number;
		public var textureFormat:String;
		public var textureScale:Number;
		public var wordWrap:Boolean;
		public function TextOptions(wordWrap:Boolean = false, autoScale:Boolean = false):void {}
		public function clone():TextOptions { return null; }
		public function copyFrom(options:TextOptions):void {}
	}

}
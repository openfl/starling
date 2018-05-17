package starling.text {

	import openfl.text.TextFormat;
	import starling.events.EventDispatcher;
	import starling.utils.Align;

	// @:meta(Event(name = "change", type = "starling.events.Event"))

	/**
	 * @externs
	 */
	public class TextFormat extends starling.events.EventDispatcher {
		public var bold:Boolean;
		public var color:uint;
		public var font:String;
		public var horizontalAlign:String;
		public var italic:Boolean;
		public var kerning:Boolean;
		public var leading:Number;
		public var letterSpacing:Number;
		public var size:Number;
		public var underline:Boolean;
		public var verticalAlign:String;
		public function TextFormat(font:String = null, size:Number = 0, color:uint = 0, horizontalAlign:String = null, verticalAlign:String = null):void {}
		public function clone():starling.text.TextFormat { return null; }
		public function copyFrom(format:starling.text.TextFormat):void {}
		public function setTo(font:String = null, size:Number = 0, color:uint = 0, horizontalAlign:String = null, verticalAlign:String = null):void {}
		public function toNativeFormat(out:openfl.text.TextFormat = null):openfl.text.TextFormat { return null; }
	}

}
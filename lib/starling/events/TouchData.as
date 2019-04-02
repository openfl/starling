package starling.events {

	/**
	 * @externs
	 */
	public class TouchData
	{
		public var id:int;
		public var phase:String;
		public var globalX:Number;
		public var globalY:Number;
		public var pressure:Number;
		public var width:Number;
		public var height:Number;

		public static function fromPool(touchID:int, phase:String, globalX:Number, globalY:Number,
										pressure:Number=1.0, width:Number=1.0, height:Number=1.0):TouchData { return null; }
		public static function toPool(rawTouch:TouchData):void {}
	}

}
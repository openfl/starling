package starling.animation;


@:jsRequire("starling/animation/Transitions", "default")


extern class Transitions {
	
	
	public static var LINEAR:String;
	public static var EASE_IN:String;
	public static var EASE_OUT:String;
	public static var EASE_IN_OUT:String;
	public static var EASE_OUT_IN:String;
	public static var EASE_IN_BACK:String;
	public static var EASE_OUT_BACK:String;
	public static var EASE_IN_OUT_BACK:String;
	public static var EASE_OUT_IN_BACK:String;
	public static var EASE_IN_ELASTIC:String;
	public static var EASE_OUT_ELASTIC:String;
	public static var EASE_IN_OUT_ELASTIC:String;
	public static var EASE_OUT_IN_ELASTIC:String;
	public static var EASE_IN_BOUNCE:String;
	public static var EASE_OUT_BOUNCE:String;
	public static var EASE_IN_OUT_BOUNCE:String;
	public static var EASE_OUT_IN_BOUNCE:String;
	
	
	public static function getTransition (name:String):Float->Float;
	public static function register (name:String, func:Float->Float):Void;
	
	
}
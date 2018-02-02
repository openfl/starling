package starling.events;



@:jsRequire("starling/events/TouchPhase", "default")

extern class TouchPhase {
	static var BEGAN(default,never) : String;
	static var ENDED(default,never) : String;
	static var HOVER(default,never) : String;
	static var MOVED(default,never) : String;
	static var STATIONARY(default,never) : String;
}

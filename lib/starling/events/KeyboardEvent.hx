package starling.events;

import starling.events.Event;

@:jsRequire("starling/events/KeyboardEvent", "default")

extern class KeyboardEvent extends starling.events.Event implements Dynamic {

	function new(type:Dynamic, ?charCode:Dynamic, ?keyCode:Dynamic, ?keyLocation:Dynamic, ?ctrlKey:Dynamic, ?altKey:Dynamic, ?shiftKey:Dynamic);
	var __charCode:Dynamic;
	var __keyCode:Dynamic;
	var __keyLocation:Dynamic;
	var __altKey:Dynamic;
	var __ctrlKey:Dynamic;
	var __shiftKey:Dynamic;
	var __isDefaultPrevented:Dynamic;
	function preventDefault():Dynamic;
	function isDefaultPrevented():Dynamic;
	var charCode:Dynamic;
	function get_charCode():Dynamic;
	var keyCode:Dynamic;
	function get_keyCode():Dynamic;
	var keyLocation:Dynamic;
	function get_keyLocation():Dynamic;
	var altKey:Dynamic;
	function get_altKey():Dynamic;
	var ctrlKey:Dynamic;
	function get_ctrlKey():Dynamic;
	var shiftKey:Dynamic;
	function get_shiftKey():Dynamic;
	static var KEY_UP:Dynamic;
	static var KEY_DOWN:Dynamic;


}
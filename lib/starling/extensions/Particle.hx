package starling.extensions;



@:jsRequire("starling/extensions/Particle", "default")

extern class Particle {
	var alpha : Float;
	var color : Int;
	var currentTime : Float;
	var rotation : Float;
	var scale : Float;
	var totalTime : Float;
	var x : Float;
	var y : Float;
	function new() : Void;
}

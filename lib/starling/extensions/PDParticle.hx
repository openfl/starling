package starling.extensions;

import starling.extensions.Particle;
import starling.extensions.ColorArgb;

@:jsRequire("starling/extensions/PDParticle", "default")

extern class PDParticle extends Particle {
	var colorArgb : ColorArgb;
	var colorArgbDelta : ColorArgb;
	var emitRadius : Float;
	var emitRadiusDelta : Float;
	var emitRotation : Float;
	var emitRotationDelta : Float;
	var radialAcceleration : Float;
	var rotationDelta : Float;
	var scaleDelta : Float;
	var startX : Float;
	var startY : Float;
	var tangentialAcceleration : Float;
	var velocityX : Float;
	var velocityY : Float;
	function new() : Void;
}

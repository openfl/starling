package starling.extensions;

import starling.extensions.Particle;
import starling.extensions.ColorArgb;

@:jsRequire("starling/extensions/PDParticle", "default")

extern class PDParticle extends starling.extensions.Particle implements Dynamic {

	function new();
	var colorArgb:Dynamic;
	var colorArgbDelta:Dynamic;
	var startX:Dynamic;
	var startY:Dynamic;
	var velocityX:Dynamic;
	var velocityY:Dynamic;
	var radialAcceleration:Dynamic;
	var tangentialAcceleration:Dynamic;
	var emitRadius:Dynamic;
	var emitRadiusDelta:Dynamic;
	var emitRotation:Dynamic;
	var emitRotationDelta:Dynamic;
	var rotationDelta:Dynamic;
	var scaleDelta:Dynamic;


}
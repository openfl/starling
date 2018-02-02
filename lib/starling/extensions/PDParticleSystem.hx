package starling.extensions;

import starling.extensions.ParticleSystem;
import starling.extensions.PDParticle;
import haxe.xml.Fast;
import Xml;
import Std;
import starling.utils.MathUtil;
import starling.extensions.ColorArgb;

@:jsRequire("starling/extensions/PDParticleSystem", "default")

extern class PDParticleSystem extends ParticleSystem {
	var defaultDuration(get,set) : Float;
	var emitAngle(get,set) : Float;
	var emitAngleVariance(get,set) : Float;
	var emitterType(get,set) : Int;
	var emitterXVariance(get,set) : Float;
	var emitterYVariance(get,set) : Float;
	var endColor(get,set) : ColorArgb;
	var endColorVariance(get,set) : ColorArgb;
	var endRotation(get,set) : Float;
	var endRotationVariance(get,set) : Float;
	var endSize(get,set) : Float;
	var endSizeVariance(get,set) : Float;
	var gravityX(get,set) : Float;
	var gravityY(get,set) : Float;
	var lifespan(get,set) : Float;
	var lifespanVariance(get,set) : Float;
	var maxRadius(get,set) : Float;
	var maxRadiusVariance(get,set) : Float;
	var minRadius(get,set) : Float;
	var minRadiusVariance(get,set) : Float;
	var radialAcceleration(get,set) : Float;
	var radialAccelerationVariance(get,set) : Float;
	var rotatePerSecond(get,set) : Float;
	var rotatePerSecondVariance(get,set) : Float;
	var speed(get,set) : Float;
	var speedVariance(get,set) : Float;
	var startColor(get,set) : ColorArgb;
	var startColorVariance(get,set) : ColorArgb;
	var startRotation(get,set) : Float;
	var startRotationVariance(get,set) : Float;
	var startSize(get,set) : Float;
	var startSizeVariance(get,set) : Float;
	var tangentialAcceleration(get,set) : Float;
	var tangentialAccelerationVariance(get,set) : Float;
	function new(config : String, texture : starling.textures.Texture) : Void;
}

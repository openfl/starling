import ParticleSystem from "./../../starling/extensions/ParticleSystem";
import PDParticle from "./../../starling/extensions/PDParticle";
import MathUtil from "./../../starling/utils/MathUtil";
import ColorArgb from "./../../starling/extensions/ColorArgb";
import ArgumentError from "openfl/errors/ArgumentError";
import Texture from "./../textures/Texture";

declare namespace starling.extensions
{
	export class PDParticleSystem extends ParticleSystem {
		defaultDuration:number;
		emitAngle:number;
		emitAngleVariance:number;
		emitterType:number;
		emitterXVariance:number;
		emitterYVariance:number;
		endColor:ColorArgb;
		endColorVariance:ColorArgb;
		endRotation:number;
		endRotationVariance:number;
		endSize:number;
		endSizeVariance:number;
		gravityX:number;
		gravityY:number;
		lifespan:number;
		lifespanVariance:number;
		maxRadius:number;
		maxRadiusVariance:number;
		minRadius:number;
		minRadiusVariance:number;
		radialAcceleration:number;
		radialAccelerationVariance:number;
		rotatePerSecond:number;
		rotatePerSecondVariance:number;
		speed:number;
		speedVariance:number;
		startColor:ColorArgb;
		startColorVariance:ColorArgb;
		startRotation:number;
		startRotationVariance:number;
		startSize:number;
		startSizeVariance:number;
		tangentialAcceleration:number;
		tangentialAccelerationVariance:number;
		constructor(config:string, texture:Texture);
	}
}

export default starling.extensions.PDParticleSystem;
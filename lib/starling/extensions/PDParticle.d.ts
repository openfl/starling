import Particle from "./../../starling/extensions/Particle";
import ColorArgb from "./../../starling/extensions/ColorArgb";

declare namespace starling.extensions
{
	export class PDParticle extends Particle {
		colorArgb:ColorArgb;
		colorArgbDelta:ColorArgb;
		emitRadius:number;
		emitRadiusDelta:number;
		emitRotation:number;
		emitRotationDelta:number;
		radialAcceleration:number;
		rotationDelta:number;
		scaleDelta:number;
		startX:number;
		startY:number;
		tangentialAcceleration:number;
		velocityX:number;
		velocityY:number;
		constructor();
	}
}

export default starling.extensions.PDParticle;
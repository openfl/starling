import starling_extensions_Particle from "./../../starling/extensions/Particle";
import starling_extensions_ColorArgb from "./../../starling/extensions/ColorArgb";

declare namespace starling.extensions {

export class PDParticle extends starling_extensions_Particle {

	constructor();
	colorArgb:any;
	colorArgbDelta:any;
	startX:any;
	startY:any;
	velocityX:any;
	velocityY:any;
	radialAcceleration:any;
	tangentialAcceleration:any;
	emitRadius:any;
	emitRadiusDelta:any;
	emitRotation:any;
	emitRotationDelta:any;
	rotationDelta:any;
	scaleDelta:any;


}

}

export default starling.extensions.PDParticle;
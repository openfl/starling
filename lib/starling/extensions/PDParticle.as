package starling.extensions {

	import starling.extensions.Particle;
	import starling.extensions.ColorArgb;

	/**
	 * @externs
	 */
	public class PDParticle extends Particle {
		public var colorArgb:ColorArgb;
		public var colorArgbDelta:ColorArgb;
		public var emitRadius:Number;
		public var emitRadiusDelta:Number;
		public var emitRotation:Number;
		public var emitRotationDelta:Number;
		public var radialAcceleration:Number;
		public var rotationDelta:Number;
		public var scaleDelta:Number;
		public var startX:Number;
		public var startY:Number;
		public var tangentialAcceleration:Number;
		public var velocityX:Number;
		public var velocityY:Number;
		public function PDParticle():void {}
	}

}
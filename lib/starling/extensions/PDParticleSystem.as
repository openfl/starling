package starling.extensions {

	import starling.extensions.ParticleSystem;
	import starling.extensions.PDParticle;
	import starling.utils.MathUtil;
	import starling.extensions.ColorArgb;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public class PDParticleSystem extends ParticleSystem {
		public var defaultDuration:Number;
		public var emitAngle:Number;
		public var emitAngleVariance:Number;
		public var emitterType:int;
		public var emitterXVariance:Number;
		public var emitterYVariance:Number;
		public var endColor:ColorArgb;
		public var endColorVariance:ColorArgb;
		public var endRotation:Number;
		public var endRotationVariance:Number;
		public var endSize:Number;
		public var endSizeVariance:Number;
		public var gravityX:Number;
		public var gravityY:Number;
		public var lifespan:Number;
		public var lifespanVariance:Number;
		public var maxRadius:Number;
		public var maxRadiusVariance:Number;
		public var minRadius:Number;
		public var minRadiusVariance:Number;
		public var radialAcceleration:Number;
		public var radialAccelerationVariance:Number;
		public var rotatePerSecond:Number;
		public var rotatePerSecondVariance:Number;
		public var speed:Number;
		public var speedVariance:Number;
		public var startColor:ColorArgb;
		public var startColorVariance:ColorArgb;
		public var startRotation:Number;
		public var startRotationVariance:Number;
		public var startSize:Number;
		public var startSizeVariance:Number;
		public var tangentialAcceleration:Number;
		public var tangentialAccelerationVariance:Number;
		public function PDParticleSystem(config:String, texture:starling.textures.Texture):void {}
	}

}
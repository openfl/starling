package starling.extensions {

	import starling.animation.IAnimatable;
	import starling.display.Mesh;
	import starling.display.BlendMode;
	import starling.extensions.Particle;
	import starling.utils.MatrixUtil;
	import starling.rendering.VertexData;
	import starling.utils.MeshSubset;
	import starling.rendering.IndexData;
	import starling.textures.Texture;
	
	// @:meta(Event(name = "complete", type = "starling.events.Event"))
	
	/**
	 * @externs
	 */
	public class ParticleSystem extends starling.display.Mesh implements starling.animation.IAnimatable {
		public var batchable:Boolean;
		public var blendFactorDestination:String;
		public var blendFactorSource:String;
		public var capacity:int;
		public var emissionRate:Number;
		public var emitterX:Number;
		public var emitterY:Number;
		public function get isEmitting():Boolean { return false; }
		public function get numParticles():int { return 0; }
		public function ParticleSystem(texture:starling.textures.Texture = null):void { super (null, null); }
		public function advanceTime(passedTime:Number):void {}
		public function clear():void {}
		public function populate(count:int):void {}
		public function start(duration:Number = 0):void {}
		public function stop(clearParticles:Boolean = false):void {}
		public static function get MAX_NUM_PARTICLES():int { return 0; }
	}

}
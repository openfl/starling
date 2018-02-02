package starling.extensions;

import starling.animation.IAnimatable;
import starling.display.Mesh;
import starling.display.BlendMode;
import starling.extensions.Particle;
import Std;
import starling.utils.MatrixUtil;
import starling.rendering.VertexData;
import starling.utils.MeshSubset;
import starling.rendering.IndexData;

@:jsRequire("starling/extensions/ParticleSystem", "default")

@:meta(Event(name = "complete", type = "starling.events.Event")) extern class ParticleSystem extends starling.display.Mesh implements starling.animation.IAnimatable {
	var batchable(get,set) : Bool;
	var blendFactorDestination(get,set) : openfl.display3D.Context3DBlendFactor;
	var blendFactorSource(get,set) : openfl.display3D.Context3DBlendFactor;
	var capacity(get,set) : Int;
	var emissionRate(get,set) : Float;
	var emitterX(get,set) : Float;
	var emitterY(get,set) : Float;
	var isEmitting(get,never) : Bool;
	var numParticles(get,never) : Int;
	function new(?texture : starling.textures.Texture) : Void;
	function advanceTime(passedTime : Float) : Void;
	function clear() : Void;
	function populate(count : Int) : Void;
	function start(duration : Float = 0) : Void;
	function stop(clearParticles : Bool = false) : Void;
	static var MAX_NUM_PARTICLES(default,never) : Int;
}

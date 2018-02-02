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

extern class ParticleSystem extends starling.display.Mesh implements Dynamic {

	function new(?texture:Dynamic);
	var _effect:Dynamic;
	var _vertexData:Dynamic;
	var _indexData:Dynamic;
	var _requiresSync:Dynamic;
	var _batchable:Dynamic;
	var _particles:Dynamic;
	var _frameTime:Dynamic;
	var _numParticles:Dynamic;
	var _emissionRate:Dynamic;
	var _emissionTime:Dynamic;
	var _emitterX:Dynamic;
	var _emitterY:Dynamic;
	var _blendFactorSource:Dynamic;
	var _blendFactorDestination:Dynamic;
	override function dispose():Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	function updateBlendMode():Dynamic;
	function createParticle():Dynamic;
	function initParticle(particle:Dynamic):Dynamic;
	function advanceParticle(particle:Dynamic, passedTime:Dynamic):Dynamic;
	function setRequiresSync(?_:Dynamic):Dynamic;
	function syncBuffers():Dynamic;
	function start(?duration:Dynamic):Dynamic;
	function stop(?clearParticles:Dynamic):Dynamic;
	function clear():Dynamic;
	override function getBounds(targetSpace:Dynamic, ?resultRect:Dynamic):Dynamic;
	function advanceTime(passedTime:Dynamic):Dynamic;
	override function render(painter:Dynamic):Dynamic;
	function populate(count:Dynamic):Dynamic;
	var capacity:Dynamic;
	function get_capacity():Dynamic;
	function set_capacity(value:Dynamic):Dynamic;
	var isEmitting:Dynamic;
	function get_isEmitting():Dynamic;
	var numParticles:Dynamic;
	function get_numParticles():Dynamic;
	var emissionRate:Dynamic;
	function get_emissionRate():Dynamic;
	function set_emissionRate(value:Dynamic):Dynamic;
	var emitterX:Dynamic;
	function get_emitterX():Dynamic;
	function set_emitterX(value:Dynamic):Dynamic;
	var emitterY:Dynamic;
	function get_emitterY():Dynamic;
	function set_emitterY(value:Dynamic):Dynamic;
	var blendFactorSource:Dynamic;
	function get_blendFactorSource():Dynamic;
	function set_blendFactorSource(value:Dynamic):Dynamic;
	var blendFactorDestination:Dynamic;
	function get_blendFactorDestination():Dynamic;
	function set_blendFactorDestination(value:Dynamic):Dynamic;
	override function set_texture(value:Dynamic):Dynamic;
	override function setStyle(?meshStyle:Dynamic, ?mergeWithPredecessor:Dynamic):Dynamic;
	var batchable:Dynamic;
	function get_batchable():Dynamic;
	function set_batchable(value:Dynamic):Dynamic;
	static var MAX_NUM_PARTICLES:Dynamic;
	static var sHelperMatrix:Dynamic;
	static var sHelperPoint:Dynamic;
	static var sSubset:Dynamic;


}
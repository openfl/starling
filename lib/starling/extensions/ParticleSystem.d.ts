import starling_animation_IAnimatable from "./../../starling/animation/IAnimatable";
import starling_display_Mesh from "./../../starling/display/Mesh";
import starling_display_BlendMode from "./../../starling/display/BlendMode";
import openfl_display3D__$Context3DBlendFactor_Context3DBlendFactor_$Impl_$ from "./../../openfl/display3D/_Context3DBlendFactor/Context3DBlendFactor_Impl_";
import starling_extensions_Particle from "./../../starling/extensions/Particle";
import Std from "./../../Std";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Point from "openfl/geom/Point";
import starling_utils_MeshSubset from "./../../starling/utils/MeshSubset";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import openfl_Vector from "openfl/Vector";

declare namespace starling.extensions {

export class ParticleSystem extends starling_display_Mesh {

	constructor(texture?:any);
	_effect:any;
	_vertexData:any;
	_indexData:any;
	_requiresSync:any;
	_batchable:any;
	_particles:any;
	_frameTime:any;
	_numParticles:any;
	_emissionRate:any;
	_emissionTime:any;
	_emitterX:any;
	_emitterY:any;
	_blendFactorSource:any;
	_blendFactorDestination:any;
	dispose():any;
	hitTest(localPoint:any):any;
	updateBlendMode():any;
	createParticle():any;
	initParticle(particle:any):any;
	advanceParticle(particle:any, passedTime:any):any;
	setRequiresSync(_?:any):any;
	syncBuffers():any;
	start(duration?:any):any;
	stop(clearParticles?:any):any;
	clear():any;
	getBounds(targetSpace:any, resultRect?:any):any;
	advanceTime(passedTime:any):any;
	render(painter:any):any;
	populate(count:any):any;
	capacity:any;
	get_capacity():any;
	set_capacity(value:any):any;
	isEmitting:any;
	get_isEmitting():any;
	numParticles:any;
	get_numParticles():any;
	emissionRate:any;
	get_emissionRate():any;
	set_emissionRate(value:any):any;
	emitterX:any;
	get_emitterX():any;
	set_emitterX(value:any):any;
	emitterY:any;
	get_emitterY():any;
	set_emitterY(value:any):any;
	blendFactorSource:any;
	get_blendFactorSource():any;
	set_blendFactorSource(value:any):any;
	blendFactorDestination:any;
	get_blendFactorDestination():any;
	set_blendFactorDestination(value:any):any;
	set_texture(value:any):any;
	setStyle(meshStyle?:any, mergeWithPredecessor?:any):any;
	batchable:any;
	get_batchable():any;
	set_batchable(value:any):any;
	static MAX_NUM_PARTICLES:any;
	static sHelperMatrix:any;
	static sHelperPoint:any;
	static sSubset:any;


}

}

export default starling.extensions.ParticleSystem;
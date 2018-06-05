import IAnimatable from "./../../starling/animation/IAnimatable";
import Mesh from "./../../starling/display/Mesh";
import BlendMode from "./../../starling/display/BlendMode";
import Particle from "./../../starling/extensions/Particle";
import Rectangle from "openfl/geom/Rectangle";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import VertexData from "./../../starling/rendering/VertexData";
import Matrix from "openfl/geom/Matrix";
import Point from "openfl/geom/Point";
import MeshSubset from "./../../starling/utils/MeshSubset";
import IndexData from "./../../starling/rendering/IndexData";
import Vector from "openfl/Vector";
import Texture from "./../textures/Texture";

declare namespace starling.extensions
{
	export class ParticleSystem extends Mesh implements IAnimatable {
		batchable:boolean;
		blendFactorDestination:Context3DBlendFactor;
		blendFactorSource:Context3DBlendFactor;
		capacity:number;
		emissionRate:number;
		emitterX:number;
		emitterY:number;
		readonly isEmitting:boolean;
		readonly numParticles:number;
		constructor(texture?:Texture);
		advanceTime(passedTime:number):void;
		clear():void;
		populate(count:number):void;
		start(duration?:number):void;
		stop(clearParticles?:boolean):void;
		static readonly MAX_NUM_PARTICLES:number;
	}
	
}

export default starling.extensions.ParticleSystem;
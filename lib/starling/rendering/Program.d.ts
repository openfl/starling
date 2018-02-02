import starling_core_Starling from "./../../starling/core/Starling";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import starling_errors_MissingContextError from "./../../starling/errors/MissingContextError";
import openfl_utils_AGALMiniAssembler from "openfl/utils/AGALMiniAssembler";
import openfl_display3D__$Context3DProgramType_Context3DProgramType_$Impl_$ from "./../../openfl/display3D/_Context3DProgramType/Context3DProgramType_Impl_";

declare namespace starling.rendering {

export class Program {

	constructor(vertexShader:any, fragmentShader:any);
	_vertexShader:any;
	_fragmentShader:any;
	_program3D:any;
	dispose():any;
	activate(context?:any):any;
	onContextCreated(event:any):any;
	disposeProgram():any;
	static sAssembler:any;
	static fromSource(vertexShader:any, fragmentShader:any, agalVersion?:any):any;


}

}

export default starling.rendering.Program;
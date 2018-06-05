import Starling from "./../../starling/core/Starling";
import MissingContextError from "./../../starling/errors/MissingContextError";
import AGALMiniAssembler from "openfl/utils/AGALMiniAssembler";
import ByteArray from "openfl/utils/ByteArray";
import Context3D from "openfl/display3D/Context3D";

declare namespace starling.rendering
{
	/** A Program represents a pair of a fragment- and vertex-shader.
	 *
	 *  <p>This class is a convenient replacement for Stage3Ds "Program3D" class. Its main
	 *  advantage is that it survives a context loss; furthermore, it makes it simple to
	 *  create a program from AGAL source without having to deal with the assembler.</p>
	 *
	 *  <p>It is recommended to store programs in Starling's "Painter" instance via the methods
	 *  <code>registerProgram</code> and <code>getProgram</code>. That way, your programs may
	 *  be shared among different display objects or even Starling instances.</p>
	 *
	 *  @see Painter
	 */
	export class Program
	{
		/** Creates a program from the given AGAL (Adobe Graphics Assembly Language) bytecode. */
		public constructor(vertexShader:ByteArray, fragmentShader:ByteArray);
	
		/** Disposes the internal Program3D instance. */
		public dispose():void;
	
		/** Creates a new Program instance from AGAL assembly language. */
		public static fromSource(vertexShader:string, fragmentShader:string,
										  agalVersion?:number):Program;
	
		/** Activates the program on the given context. If you don't pass a context, the current
		 *  Starling context will be used. */
		public activate(context?:Context3D):void;
	}
}

export default starling.rendering.Program;
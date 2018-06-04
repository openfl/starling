// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Program3D;
import openfl.events.Event;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;

import starling.core.Starling;
import starling.errors.MissingContextError;

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

@:jsRequire("starling/rendering/Program", "default")

extern class Program
{
    /** Creates a program from the given AGAL (Adobe Graphics Assembly Language) bytecode. */
    public function new(vertexShader:ByteArray, fragmentShader:ByteArray);

    /** Disposes the internal Program3D instance. */
    public function dispose():Void;

    /** Creates a new Program instance from AGAL assembly language. */
    public static function fromSource(vertexShader:String, fragmentShader:String,
                                      agalVersion:UInt=1):Program;

    /** Activates the program on the given context. If you don't pass a context, the current
     *  Starling context will be used. */
    public function activate(context:Context3D=null):Void;
}
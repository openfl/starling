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
#if 0
import com.adobe.utils.AGALMiniAssembler;
#end

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Program3D;
import flash.events.Event;
import flash.utils.ByteArray;

import starling.core.Starling;
import starling.errors.MissingContextError;

import openfl.display3D._shaders.AGLSLShaderUtils;
import openfl.display3D._shaders.Shader;

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
class Program
{
    private var _vertexShader:Shader;
    private var _fragmentShader:Shader;
    private var _program3D:Program3D;

    #if 0
    private static var sAssembler:AGALMiniAssembler = new AGALMiniAssembler();
    #end

    /** Creates a program from the given AGAL (Adobe Graphics Assembly Language) bytecode. */
    public function new(vertexShader:Shader, fragmentShader:Shader)
    {
        _vertexShader = vertexShader;
        _fragmentShader = fragmentShader;

        // Handle lost context (using conventional Flash event for weak listener support)
        Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE,
            onContextCreated, false, 0, true);
    }

    /** Disposes the internal Program3D instance. */
    public function dispose():Void
    {
        Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        disposeProgram();
    }

    /** Creates a new Program instance from AGAL assembly language. */
    public static function fromSource(vertexShader:String, fragmentShader:String,
                                      agalVersion:UInt=1):Program
    {
        #if 0
        return new Program(
            sAssembler.assemble(Context3DProgramType.VERTEX, vertexShader, agalVersion),
            sAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader, agalVersion));
        #else
        return new Program(
            AGLSLShaderUtils.createShader(Context3DProgramType.VERTEX, vertexShader),
            AGLSLShaderUtils.createShader(Context3DProgramType.FRAGMENT, fragmentShader));
        #end
    }

    /** Activates the program on the given context. If you don't pass a context, the current
     *  Starling context will be used. */
    public function activate(context:Context3D=null):Void
    {
        if (context == null)
        {
            context = Starling.sContext;
            if (context == null) throw new MissingContextError();
        }

        if (_program3D == null)
        {
            _program3D = context.createProgram();
            _program3D.upload(_vertexShader, _fragmentShader);
        }

        context.setProgram(_program3D);
    }

    private function onContextCreated(event:Event):Void
    {
        disposeProgram();
    }

    private function disposeProgram():Void
    {
        if (_program3D != null)
        {
            _program3D.dispose();
            _program3D = null;
        }
    }
}

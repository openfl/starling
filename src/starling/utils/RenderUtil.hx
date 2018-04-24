// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import haxe.Constraints.Function;
import haxe.Timer;

import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DRenderMode;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.Context3DWrapMode;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;

import starling.core.Starling;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.Execute.execute;

/** A utility class containing methods related to Stage3D and rendering in general. */
class RenderUtil
{
    /** @private */
    private function new()
    {
    }

    /** Clears the render context with a certain color and alpha value. */
    public static function clear(rgb:UInt=0, alpha:Float=0.0,
                                    depth:Float=1.0, stencil:UInt=0):Void
    {
        Starling.current.context.clear(
                Color.getRed(rgb)   / 255.0,
                Color.getGreen(rgb) / 255.0,
                Color.getBlue(rgb)  / 255.0,
                alpha, depth, stencil
            );
    }

    /** Returns the flags that are required for AGAL texture lookup,
     *  including the '&lt;' and '&gt;' delimiters. */
    public static function getTextureLookupFlags(format:String, mipMapping:Bool,
                                                    repeat:Bool=false,
                                                    smoothing:String="bilinear"):String
    {
        // TODO this method can probably be removed

        var options = ["2d", repeat ? "repeat" : "clamp"];

        if (format == Context3DTextureFormat.COMPRESSED)
            options.push("dxt1");
        else if (format == "compressedAlpha")
            options.push("dxt5");

        if (smoothing == TextureSmoothing.NONE) {
            options.push("nearest");
            options.push(mipMapping ? "mipnearest" : "mipnone");
        }
        else if (smoothing == TextureSmoothing.BILINEAR)
        {
            options.push("linear");
            options.push(mipMapping ? "mipnearest" : "mipnone");
        }
        else
        {
            options.push("linear");
            options.push (mipMapping ? "miplinear" : "mipnone");
        }

        return "<" + options.join(",") + ">";
    }

    /** Returns a bit field uniquely describing texture format and premultiplied alpha,
     *  so that each required AGAL variant will get its unique ID. This method is most
     *  useful when overriding the <code>programVariantName</code> method of custom
     *  effects.
     *
     *  @return a bit field using the 3 least significant bits.
     */
    public static function getTextureVariantBits(texture:Texture):UInt
    {
        if (texture == null) return 0;

        var bitField:UInt = 0;
        var formatBits:UInt = 0;

        switch (texture.format)
        {
            case Context3DTextureFormat.COMPRESSED_ALPHA:
                formatBits = 3;
            case Context3DTextureFormat.COMPRESSED:
                formatBits = 2;
            default:
                formatBits = 1;
        }

        bitField |= formatBits;

        if (!texture.premultipliedAlpha)
            bitField |= 1 << 2;

        return bitField;
    }

    /** Calls <code>setSamplerStateAt</code> at the current context,
     *  converting the given parameters to their low level counterparts. */
    public static function setSamplerStateAt(sampler:Int, mipMapping:Bool,
                                                smoothing:String="bilinear",
                                                repeat:Bool=false):Void
    {
        var wrap:String = repeat ? Context3DWrapMode.REPEAT : Context3DWrapMode.CLAMP;
        var filter:String;
        var mipFilter:String;

        if (smoothing == TextureSmoothing.NONE)
        {
            filter = Context3DTextureFilter.NEAREST;
            mipFilter = mipMapping ? Context3DMipFilter.MIPNEAREST : Context3DMipFilter.MIPNONE;
        }
        else if (smoothing == TextureSmoothing.BILINEAR)
        {
            filter = Context3DTextureFilter.LINEAR;
            mipFilter = mipMapping ? Context3DMipFilter.MIPNEAREST : Context3DMipFilter.MIPNONE;
        }
        else
        {
            filter = Context3DTextureFilter.LINEAR;
            mipFilter = mipMapping ? Context3DMipFilter.MIPLINEAR : Context3DMipFilter.MIPNONE;
        }

        Starling.current.context.setSamplerStateAt(sampler, wrap, filter, mipFilter);
    }

    /** Creates an AGAL source string with a <code>tex</code> operation, including an options
     *  list with the appropriate format flag.
     *
     *  <p>Note that values for <code>repeat/clamp</code>, <code>filter</code> and
     *  <code>mip-filter</code> are not included in the options list, since it's preferred
     *  to set those values at runtime via <code>setSamplerStateAt</code>.</p>
     *
     *  <p>Starling expects every color to have its alpha value premultiplied into
     *  the RGB channels. Thus, if this method encounters a non-PMA texture, it will
     *  (per default) convert the color in the result register to PMA mode, resulting
     *  in an additional <code>mul</code>-operation.</p>
     *
     *  @param resultReg  the register to write the result into.
     *  @param uvReg      the register containing the texture coordinates.
     *  @param sampler    the texture sampler to use.
     *  @param texture    the texture that's active in the given texture sampler.
     *  @param convertToPmaIfRequired  indicates if a non-PMA color should be converted to PMA.
     *  @param tempReg    if 'resultReg' is the output register and PMA conversion is done,
     *                    a temporary register is needed.
     *
     *  @return the AGAL source code, line break(s) included.
     */
    public static function createAGALTexOperation(
            resultReg:String, uvReg:String, sampler:Int, texture:Texture,
            convertToPmaIfRequired:Bool=true, tempReg:String="ft0"):String
    {
        var format = texture.format;
        var formatFlag:String;

        switch (format)
        {
            case Context3DTextureFormat.COMPRESSED:
                formatFlag = "dxt1";
            case Context3DTextureFormat.COMPRESSED_ALPHA:
                formatFlag = "dxt5";
            default:
                formatFlag = "rgba";
        }

        var needsConversion:Bool = convertToPmaIfRequired && !texture.premultipliedAlpha;
        var texReg:String = needsConversion && resultReg == "oc" ? tempReg : resultReg;
        var operation:String = "tex " + texReg + ", " + uvReg + ", fs" + sampler +
                        " <2d, " + formatFlag + ">\n";

        if (needsConversion)
        {
            if (resultReg == "oc") // the output color register cannot use a write mask ...
            {
                operation += "mul " + texReg + ".xyz, " + texReg + ".xyz, " + texReg + ".www\n";
                operation += "mov " + resultReg + ", " + texReg;
            }
            else
            {
                operation += "mul " + resultReg + ".xyz, " + texReg + ".xyz, " + texReg + ".www\n";
            }
        }

        return operation;
    }

    /** Requests a context3D object from the given Stage3D object.
        *
        * @param stage3D    The stage3D object the context needs to be requested from.
        * @param renderMode The 'Context3DRenderMode' to use when requesting the context.
        * @param profile    If you know exactly which 'Context3DProfile' you want to use, simply
        *                   pass a String with that profile.
        *
        *                   <p>If you are unsure which profiles are supported on the current
        *                   device, you can also pass an Array of profiles; they will be
        *                   tried one after the other (starting at index 0), until a working
        *                   profile is found. If none of the given profiles is supported,
        *                   the Stage3D object will dispatch an ERROR event.</p>
        *
        *                   <p>You can also pass the String 'auto' to use the best available
        *                   profile automatically. This will try all known Stage3D profiles,
        *                   beginning with the most powerful.</p>
        */
    public static function requestContext3D(stage3D:Stage3D, renderMode:String, profile:Dynamic):Void
    {
        var profiles:Array<Dynamic>;
        var currentProfile:String;
        var executeFunc:Function->Array<Dynamic>->Void = SystemUtil.isDesktop ?
                execute : SystemUtil.executeWhenApplicationIsActive;

        if (profile == "auto")
            profiles = ["enhanced",
                        "standardExtended", "standard", "standardConstrained",
                        "baselineExtended", "baseline", "baselineConstrained"];
        else if (Std.is(profile, String))
            profiles = [Std.string(profile)];
        else if (Std.is(profile, Array))
            profiles = cast(profile, Array<Dynamic>);
        else
            throw new ArgumentError("Profile must be of type 'String' or 'Array'");

        var requestNextProfile:Void->Void = null;
        var onFinished:Void->Void = null;
        var onError:Event->Void = null;
        var onCreated:Event->Void = null;
        
        requestNextProfile = function():Void
        {
            currentProfile = profiles.shift();

            try 
            {
                executeFunc(stage3D.requestContext3D, [renderMode, currentProfile]);
            }
            catch (error:Error)
            {
                if (profiles.length != 0) Timer.delay(requestNextProfile, 1);
                else throw error;
            }
        }

        onCreated = function(event:Event):Void
        {
            var context:Context3D = stage3D.context3D;

            if (renderMode == Context3DRenderMode.AUTO && profiles.length != 0 &&
                    context.driverInfo.indexOf("Software") != -1)
            {
                onError(event);
            }
            else
            {
                onFinished();
            }
        }

        onError = function(event:Event):Void
        {
            if (profiles.length != 0)
            {
                event.stopImmediatePropagation();
                Timer.delay(requestNextProfile, 1);
            }
            else onFinished();
        }

        onFinished = function():Void
        {
            stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onCreated);
            stage3D.removeEventListener(ErrorEvent.ERROR, onError);
        }
        
        stage3D.addEventListener(Event.CONTEXT3D_CREATE, onCreated, false, 100);
        stage3D.addEventListener(ErrorEvent.ERROR, onError, false, 100);
        
        requestNextProfile();
    }
}
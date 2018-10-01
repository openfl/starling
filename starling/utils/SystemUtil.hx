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

import flash.display3D.Context3D;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.system.Capabilities;
import flash.Lib;

import haxe.Constraints.Function;

import lime.app.Application;

#if (lime < "7.0.0")
import lime.app.Config.WindowConfig;
#end

import openfl.errors.Error;

/** A utility class with methods related to the current platform and runtime. */
class SystemUtil
{
    private static var sInitialized:Bool = false;
    private static var sApplicationActive:Bool = true;
    private static var sWaitingCalls:Array<Array<Dynamic>> = [];
    private static var sPlatform:String;
    private static var sVersion:String;
    private static var sAIR:Bool;
    private static var sSupportsDepthAndStencil:Bool = true;
    
    /** Initializes the <code>ACTIVATE/DEACTIVATE</code> event handlers on the native
     * application. This method is automatically called by the Starling constructor. */
    public static function initialize():Void
    {
        if (sInitialized) return;
        
        sInitialized = true;
        sPlatform = Capabilities.version.substr(0, 3);
        sVersion = Capabilities.version.substr(4);
        
        try
        {
            var nativeApp = Lib.current;

            nativeApp.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
            nativeApp.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);

            #if 0
            var appDescriptor:XML = nativeApp["applicationDescriptor"];
            var ns:Namespace = appDescriptor.namespace();
            var ds:String = appDescriptor.ns::initialWindow.ns::depthAndStencil.toString().toLowerCase();

            sSupportsDepthAndStencil = (ds == "true");
            #elseif flash
            #elseif (lime >= "7.0.0")
            var attributes = Application.current.window.context.attributes;
            sSupportsDepthAndStencil = (attributes.depth && attributes.stencil);
            #elseif lime
            var windowConfig = Application.current.window.config;
            sSupportsDepthAndStencil = windowConfig.depthBuffer && windowConfig.stencilBuffer;
            #else
            sSupportsDepthAndStencil = true;
            #end
            
            #if air
            sAIR = true;
            #end
        }
        catch (e:Error)
        {
            sAIR = false;
        }
    }
    
    private static function onActivate(event:Dynamic):Void
    {
        sApplicationActive = true;
        
        for (call in sWaitingCalls)
        {
            try { Reflect.callMethod(null, call[0], call[1]); }
            catch (e:Error)
            {
                trace("[Starling] Error in 'executeWhenApplicationIsActive' call: " + e.message);
            }
        }

        sWaitingCalls = [];
    }
    
    private static function onDeactivate(event:Dynamic):Void
    {
        sApplicationActive = false;
    }
    
    /** Executes the given function with its arguments the next time the application is active.
     * (If it <em>is</em> active already, the call will be executed right away.) */
    public static function executeWhenApplicationIsActive(call:Function, args:Array<Dynamic>):Void
    {
        initialize();
        
        if (args == null) args = [];
        if (sApplicationActive) Reflect.callMethod(call, call, args);
        else sWaitingCalls.push([call, args]);
    }

    /** Indicates if the application is currently active. On Desktop, this means that it has
     * the focus; on mobile, that it is in the foreground. In the Flash Plugin, always
     * returns true. */
    public static var isApplicationActive(get, never):Bool;
    private static function get_isApplicationActive():Bool
    {
        initialize();
        return sApplicationActive;
    }

    /** Indicates if the code is executed in an Adobe AIR runtime (true)
     * or Flash plugin/projector (false). */
    public static var isAIR(get, never):Bool;
    private static function get_isAIR():Bool
    {
        initialize();
        return sAIR;
    }
    
    /** Indicates if the code is executed on a Desktop computer with Windows, OS X or Linux
     * operating system. If the method returns 'false', it's probably a mobile device
     * or a Smart TV. */
    public static var isDesktop(get, never):Bool;
    private static function get_isDesktop():Bool
    {
        initialize();
        return #if desktop true #else false #end;
        //return ~/(WIN|MAC|LNX)/.match(sPlatform);
    }
    
    /** Returns the three-letter platform string of the current system. These are
     * the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
     * last one, which indicates "Blackberry", all should be self-explanatory. */
    public static var platform(get, never):String;
    private static function get_platform():String
    {
        initialize();
        return sPlatform;
    }

    /** Returns the Flash Player/AIR version string. The format of the version number is:
     * <em>majorVersion,minorVersion,buildNumber,internalBuildNumber</em>. */
    private static function get_version():String
    {
        initialize();
        return sVersion;
    }

    /** Prior to Flash/AIR 15, there was a restriction that the clear function must be
     * called on a render target before drawing. This requirement was removed subsequently,
     * and this property indicates if that's the case in the current runtime. */
    public static var supportsRelaxedTargetClearRequirement(get, never):Bool;
    private static function get_supportsRelaxedTargetClearRequirement():Bool
    {
        #if flash
        var reg = ~/\d+/;
        reg.match(sVersion);
        return Std.parseInt(reg.matched(0)) >= 15;
        #else
        return true;
        #end
    }

    /** Returns the value of the 'initialWindow.depthAndStencil' node of the application
     * descriptor, if this in an AIR app; otherwise always <code>true</code>. */
    public static var supportsDepthAndStencil(get, never):Bool;
    private static function get_supportsDepthAndStencil():Bool
    {
        return sSupportsDepthAndStencil;
    }

    /** Indicates if Context3D supports video textures. At the time of this writing,
     * video textures are only supported on Windows, OS X and iOS, and only in AIR
     * applications (not the Flash Player). */
    public static var supportsVideoTexture(get, never):Bool;
    private static function get_supportsVideoTexture():Bool
    {
        #if flash
        if (Reflect.hasField(Context3D, "supportsVideoTexture"))
        {
			return cast Reflect.getProperty(Context3D, "supportsVideoTexture");
        }
        else
        {
            return false;
        }
        return Reflect.hasField(Context3D, "supportsVideoTexture");
        #else
        return Context3D.supportsVideoTexture;
        #end
    }
}
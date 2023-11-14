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

import openfl.display3D.Context3D;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.system.Capabilities;
import openfl.Lib;

#if lime
import lime.app.Application;
#end

/** A utility class with methods related to the current platform and runtime. */
class SystemUtil
{
    private static var sInitialized:Bool = false;
    private static var sApplicationActive:Bool = true;
    private static var sWaitingCalls:Array<Array<Dynamic>> = [];
    private static var sPlatform:String;
    private static var sVersion:String;
    private static var sAIR:Bool;
    private static var sEmbeddedFonts:Array<Font> = null;
    private static var sSupportsDepthAndStencil:Bool = true;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (SystemUtil, {
            "isApplicationActive": { get: untyped __js__ ("function () { return SystemUtil.get_isApplicationActive (); }") },
            "isAIR": { get: untyped __js__ ("function () { return SystemUtil.get_isAIR (); }") },
            "version": { get: untyped __js__ ("function () { return SystemUtil.get_version (); }") },
            "platform": { get: untyped __js__ ("function () { return SystemUtil.get_platform (); }"), set: untyped __js__ ("function (v) { return SystemUtil.set_platform (v); }") },
            "supportsDepthAndStencil": { get: untyped __js__ ("function () { return SystemUtil.get_supportsDepthAndStencil (); }") },
            "supportsVideoTexture": { get: untyped __js__ ("function () { return SystemUtil.get_supportsVideoTexture (); }") },
            "isIOS": { get: untyped __js__ ("function () { return SystemUtil.get_isIOS (); }") },
            "isAndroid": { get: untyped __js__ ("function () { return SystemUtil.get_isAndroid (); }") },
            "isMac": { get: untyped __js__ ("function () { return SystemUtil.get_isMac (); }") },
            "isWindows": { get: untyped __js__ ("function () { return SystemUtil.get_isWindows (); }") },
            "isDesktop": { get: untyped __js__ ("function () { return SystemUtil.get_isDesktop (); }") },
        });
        
    }
    #end

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
			#if flash
			var nativeAppClass:Dynamic = Type.resolveClass("flash.desktop::NativeApplication");
			if (nativeAppClass == null)
				throw new Error("Not Air");
			#end
			
            //var nativeAppClass:Object = getDefinitionByName("flash.desktop::NativeApplication");
            //var nativeApp:EventDispatcher = nativeAppClass["nativeApplication"] as EventDispatcher;
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
        catch (e:Dynamic)
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
            catch (e:Dynamic)
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
    public static function executeWhenApplicationIsActive(call:Function, args:Array<Dynamic> = null):Void
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
    
    /** Returns the Flash Player/AIR version string. The format of the version number is:
        *  <em>majorVersion,minorVersion,buildNumber,internalBuildNumber</em>. */
    public static var version(get, never):String;
    private static function get_version():String
    {
        initialize();
        return sVersion;
    }

    /** Returns the three-letter platform string of the current system. These are
        * the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
        * last one, which indicates "Blackberry", all should be self-explanatory. */
    public static var platform(get, set):String;
    private static function get_platform():String
    {
        initialize();
        return sPlatform;
    }

    private static function set_platform(value:String):String
    {
        initialize();
        sPlatform = value;
        return value;
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

    // embedded fonts

    /** Updates the list of embedded fonts. To be called when a font is loaded at runtime. */
    public static function updateEmbeddedFonts():Void
    {
        sEmbeddedFonts = null; // will be updated in 'isEmbeddedFont()'
    }

    /** Figures out if an embedded font with the specified style is available.
        *  The fonts are enumerated only once; if you load a font at runtime, be sure to call
        *  'updateEmbeddedFonts' before calling this method.
        *
        *  @param fontName  the name of the font
        *  @param bold      indicates if the font has a bold style
        *  @param italic    indicates if the font has an italic style
        *  @param fontType  the type of the font (one of the constants defined in the FontType class)
        */
    public static function isEmbeddedFont(fontName:String, bold:Bool=false, italic:Bool=false,
                                            fontType:String="embedded"):Bool
    {
        if (sEmbeddedFonts == null)
            sEmbeddedFonts = Font.enumerateFonts(false);

        for (font in sEmbeddedFonts)
        {
            var style:String = font.fontStyle;
            var isBold:Bool = style == FontStyle.BOLD || style == FontStyle.BOLD_ITALIC;
            var isItalic:Bool = style == FontStyle.ITALIC || style == FontStyle.BOLD_ITALIC;

            if (fontName == font.fontName && bold == isBold && italic == isItalic &&
                fontType == font.fontType)
            {
                return true;
            }
        }

        return false;
    }

    // convenience methods

    /** Indicates if the code is executed on an iOS device, based on the <code>platform</code>
        *  string. */
    public static var isIOS(get, never):Bool;
    private static function get_isIOS():Bool
    {
        return platform == "IOS";
    }

    /** Indicates if the code is executed on an Android device, based on the
        *  <code>platform</code> string. */
    public static var isAndroid(get, never):Bool;
    private static function get_isAndroid():Bool
    {
        return platform == "AND";
    }

    /** Indicates if the code is executed on a Macintosh, based on the <code>platform</code>
        *  string. */
    public static var isMac(get, never):Bool;
    private static function get_isMac():Bool
    {
        return platform == "MAC";
    }

    /** Indicates if the code is executed on Windows, based on the <code>platform</code>
        *  string. */
    public static var isWindows(get, never):Bool;
    private static function get_isWindows():Bool
    {
        return platform == "WIN";
    }

    /** Indicates if the code is executed on a Desktop computer with Windows, macOS or Linux
        *  operating system. If the method returns 'false', it's probably a mobile device
        *  or a Smart TV. */
    public static var isDesktop(get, never):Bool;
    private static function get_isDesktop():Bool
    {
        // TODO: It appears this is used as a "not mobile" define, but there should be
        // a way to know whether something is HTML5 as well. For now, returning true in this
        // case seems like the right behavior for Starling
        #if flash
        return platform == "WIN" || platform == "MAC" || platform == "LNX";
        #elseif !mobile
        return true;
        #else
        return false;
        #end
    }
}
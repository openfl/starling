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
import lime.app.Config.WindowConfig;
#end

/** A utility class with methods related to the current platform and runtime. */

@:jsRequire("starling/utils/SystemUtil", "default")

extern class SystemUtil
{
    /** Initializes the <code>ACTIVATE/DEACTIVATE</code> event handlers on the native
        * application. This method is automatically called by the Starling constructor. */
    public static function initialize():Void;

    /** Executes the given function with its arguments the next time the application is active.
        * (If it <em>is</em> active already, the call will be executed right away.) */
    public static function executeWhenApplicationIsActive(call:Function, args:Array<Dynamic> = null):Void;

    /** Indicates if the application is currently active. On Desktop, this means that it has
        * the focus; on mobile, that it is in the foreground. In the Flash Plugin, always
        * returns true. */
    public static var isApplicationActive(get, never):Bool;
    private static function get_isApplicationActive():Bool;

    /** Indicates if the code is executed in an Adobe AIR runtime (true)
        * or Flash plugin/projector (false). */
    public static var isAIR(get, never):Bool;
    private static function get_isAIR():Bool;
    
    /** Returns the Flash Player/AIR version string. The format of the version number is:
        *  <em>majorVersion,minorVersion,buildNumber,internalBuildNumber</em>. */
    public static var version(get, never):String;
    private static function get_version():String;

    /** Returns the three-letter platform string of the current system. These are
        * the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
        * last one, which indicates "Blackberry", all should be self-explanatory. */
    public static var platform(get, set):String;
    private static function get_platform():String;
    private static function set_platform(value:String):String;

    /** Returns the value of the 'initialWindow.depthAndStencil' node of the application
        * descriptor, if this in an AIR app; otherwise always <code>true</code>. */
    public static var supportsDepthAndStencil(get, never):Bool;
    private static function get_supportsDepthAndStencil():Bool;

    /** Indicates if Context3D supports video textures. At the time of this writing,
        * video textures are only supported on Windows, OS X and iOS, and only in AIR
        * applications (not the Flash Player). */
    public static var supportsVideoTexture(get, never):Bool;
    private static function get_supportsVideoTexture():Bool;

    // embedded fonts

    /** Updates the list of embedded fonts. To be called when a font is loaded at runtime. */
    public static function updateEmbeddedFonts():Void;

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
                                            fontType:String="embedded"):Bool;

    // convenience methods

    /** Indicates if the code is executed on an iOS device, based on the <code>platform</code>
        *  string. */
    public static var isIOS(get, never):Bool;
    private static function get_isIOS():Bool;

    /** Indicates if the code is executed on an Android device, based on the
        *  <code>platform</code> string. */
    public static var isAndroid(get, never):Bool;
    private static function get_isAndroid():Bool;

    /** Indicates if the code is executed on a Macintosh, based on the <code>platform</code>
        *  string. */
    public static var isMac(get, never):Bool;
    private static function get_isMac():Bool;

    /** Indicates if the code is executed on Windows, based on the <code>platform</code>
        *  string. */
    public static var isWindows(get, never):Bool;
    private static function get_isWindows():Bool;

    /** Indicates if the code is executed on a Desktop computer with Windows, macOS or Linux
        *  operating system. If the method returns 'false', it's probably a mobile device
        *  or a Smart TV. */
    public static var isDesktop(get, never):Bool;
    private static function get_isDesktop():Bool;
}
// =================================================================================================
//
//	Starling Framework
//	Copyright 2014 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;
import openfl.system.Capabilities;

import starling.errors.AbstractClassError;

/** A utility class with methods related to the current platform and runtime. */
class SystemUtil
{
    private static var sInitialized:Bool = false;
    private static var sApplicationActive:Bool = true;
    private static var sWaitingCalls:Array<Dynamic> = new Array<Dynamic>();
    private static var sAIR:Bool;
    
    /** @private */
    public function SystemUtil() { throw new AbstractClassError(); }
    
    /** Initializes the <code>ACTIVATE/DEACTIVATE</code> event handlers on the native
     *  application. This method is automatically called by the Starling constructor. */
    public static function initialize():Void
    {
        if (sInitialized) return;
        
        sInitialized = true;
        
        try
        {
            Lib.current.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
            Lib.current.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
            
            sAIR = true;
        }
        catch (e:Error)
        {
            sAIR = false;
        }
    }
    
    private static function onActivate(event:Dynamic):Void
    {
        sApplicationActive = true;
        
        for(call in sWaitingCalls)
            Reflect.callMethod(null, call[0], [call[1]]);
        
        sWaitingCalls = [];
    }
    
    private static function onDeactivate(event:Dynamic):Void
    {
        sApplicationActive = false;
    }
    
    /** Executes the given function with its arguments the next time the application is active.
     *  (If it <em>is</em> active already, the call will be executed right away.) */
    public static function executeWhenApplicationIsActive(call:Array<Dynamic>->Void, args:Array<Dynamic>):Void
    {
        initialize();
        
        if (sApplicationActive) call(args);
        else sWaitingCalls.push([call, args]);
    }

    /** Indicates if the application is currently active. On Desktop, this means that it has
     *  the focus; on mobile, that it is in the foreground. In the Flash Plugin, always
     *  returns true. */
    public static var isApplicationActive(get, never):Bool;
    public static function get_isApplicationActive():Bool
    {
        initialize();
        return sApplicationActive;
    }

    /** Indicates if the code is executed in an Adobe AIR runtime (true)
     *  or Flash plugin/projector (false). */
    public static var isAIR(get, never):Bool;
    public static function get_isAIR():Bool
    {
        initialize();
        return sAIR;
    }
    
    /** Indicates if the code is executed on a Desktop computer with Windows, OS X or Linux
     *  operating system. If the method returns 'false', it's probably a mobile device
     *  or a Smart TV. */
    public static var isDesktop(get, never):Bool;
    public static function get_isDesktop():Bool
    {
        initialize();
        #if (cpp || neko)
        return ~/(WIN|MAC|LNX)/.match(Sys.systemName());
        #else
        return true;
        #end
    }
    
    /** Returns the three-letter platform string of the current system. These are
     *  the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
     *  last one, which indicates "Blackberry", all should be self-explanatory. */
    public static var platform(get, never):String;
    public static function get_platform():String
    {
        initialize();
        #if (cpp || neko)
        return Sys.systemName();
        #else
        return "";
        #end
    }
}
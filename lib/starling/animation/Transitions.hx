// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
//
// easing functions thankfully taken from http://dojotoolkit.org
//                                    and http://www.robertpenner.com/easing
//

package starling.animation;

/** The Transitions class contains static methods that define easing functions. 
 *  Those functions are used by the Tween class to execute animations.
 * 
 *  <p>Here is a visual representation of the available transitions:</p> 
 *  <img src="http://gamua.com/img/blog/2010/sparrow-transitions.png"/>
 *  
 *  <p>You can define your own transitions through the "registerTransition" function. A 
 *  transition function must have the following signature, where <code>ratio</code> is 
 *  in the range 0-1:</p>
 *  
 *  <pre>function myTransition(ratio:Float):Float</pre>
 */

@:jsRequire("starling/animation/Transitions", "default")

extern class Transitions
{
    public static var LINEAR:String;
    public static var EASE_IN:String;
    public static var EASE_OUT:String;
    public static var EASE_IN_OUT:String;
    public static var EASE_OUT_IN:String;
    public static var EASE_IN_BACK:String;
    public static var EASE_OUT_BACK:String;
    public static var EASE_IN_OUT_BACK:String;
    public static var EASE_OUT_IN_BACK:String;
    public static var EASE_IN_ELASTIC:String;
    public static var EASE_OUT_ELASTIC:String;
    public static var EASE_IN_OUT_ELASTIC:String;
    public static var EASE_OUT_IN_ELASTIC:String;
    public static var EASE_IN_BOUNCE:String;
    public static var EASE_OUT_BOUNCE:String;
    public static var EASE_IN_OUT_BOUNCE:String;
    public static var EASE_OUT_IN_BOUNCE:String;
    
    /** Returns the transition function that was registered under a certain name. */ 
    public static function getTransition(name:String):Float->Float;
    
    /** Registers a new transition function under a certain name. */
    public static function register(name:String, func:Float->Float):Void;
}
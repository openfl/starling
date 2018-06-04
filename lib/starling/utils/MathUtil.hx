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

import openfl.geom.Point;
import openfl.geom.Vector3D;

/** A utility class containing methods you might need for math problems. */

@:jsRequire("starling/utils/MathUtil", "default")

extern class MathUtil
{
    private static var TWO_PI:Float;

    /** Calculates the intersection point between the xy-plane and an infinite line
     *  that is defined by two 3D points in the same coordinate system. */
    public static function intersectLineWithXYPlane(pointA:Vector3D, pointB:Vector3D,
                                                    out:Point=null):Point;

    /** Calculates if the point <code>p</code> is inside the triangle <code>a-b-c</code>. */
    public static function isPointInTriangle(p:Point, a:Point, b:Point, c:Point):Bool;

    /** Moves a radian angle into the range [-PI, +PI], while keeping the direction intact. */
    public static function normalizeAngle(angle:Float):Float;

    /** Returns the next power of two that is equal to or bigger than the specified number. */
    public static function getNextPowerOfTwo(number:Float):Int;

    /** Indicates if two float (Number) values are equal, give or take <code>epsilon</code>. */
    public static function isEquivalent(a:Float, b:Float, epsilon:Float=0.0001):Bool;

    /** Returns the larger of the two values. Different to the native <code>Math.max</code>,
     *  this doesn't create any temporary objects when using the AOT compiler. */
    public static function max(a:Float, b:Float):Float;

    /** Returns the smaller of the two values. Different to the native <code>Math.min</code>,
     *  this doesn't create any temporary objects when using the AOT compiler. */
    public static function min(a:Float, b:Float):Float;

    /** Moves <code>value</code> into the range between <code>min</code> and <code>max</code>. */
    public static function clamp(value:Float, min:Float, max:Float):Float;
    
    /** Returns the smallest value in an array. */
    public static function minValues(values:Array<Float>):Float;
    
    /** Converts an angle from degrees into radians. */
    public static function deg2rad(deg:Float):Float;
    
    /** Converts an angle from radians into degrees. */
    public static function rad2deg(rad:Float):Float;
    
    public static function toFixed(value:Float, precision:Int):String;
}
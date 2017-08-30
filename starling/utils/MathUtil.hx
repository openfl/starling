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
class MathUtil
{
    private static var TWO_PI:Float = Math.PI * 2.0;

    /** Calculates the intersection point between the xy-plane and an infinite line
     *  that is defined by two 3D points in the same coordinate system. */
    public static function intersectLineWithXYPlane(pointA:Vector3D, pointB:Vector3D,
                                                    out:Point=null):Point
    {
        if (out == null) out = new Point();

        var vectorX:Float = pointB.x - pointA.x;
        var vectorY:Float = pointB.y - pointA.y;
        var vectorZ:Float = pointB.z - pointA.z;
        var lambda:Float = -pointA.z / vectorZ;

        out.x = pointA.x + lambda * vectorX;
        out.y = pointA.y + lambda * vectorY;

        return out;
    }

    /** Calculates if the point <code>p</code> is inside the triangle <code>a-b-c</code>. */
    public static function isPointInTriangle(p:Point, a:Point, b:Point, c:Point):Bool
    {
        // This algorithm is described well in this article:
        // http://www.blackpawn.com/texts/pointinpoly/default.html

        var v0x:Float = c.x - a.x;
        var v0y:Float = c.y - a.y;
        var v1x:Float = b.x - a.x;
        var v1y:Float = b.y - a.y;
        var v2x:Float = p.x - a.x;
        var v2y:Float = p.y - a.y;

        var dot00:Float = v0x * v0x + v0y * v0y;
        var dot01:Float = v0x * v1x + v0y * v1y;
        var dot02:Float = v0x * v2x + v0y * v2y;
        var dot11:Float = v1x * v1x + v1y * v1y;
        var dot12:Float = v1x * v2x + v1y * v2y;

        var invDen:Float = 1.0 / (dot00 * dot11 - dot01 * dot01);
        var u:Float = (dot11 * dot02 - dot01 * dot12) * invDen;
        var v:Float = (dot00 * dot12 - dot01 * dot02) * invDen;

        return (u >= 0) && (v >= 0) && (u + v < 1);
    }

    /** Moves a radian angle into the range [-PI, +PI], while keeping the direction intact. */
    public static function normalizeAngle(angle:Float):Float
    {
        // move to equivalent value in range [0 deg, 360 deg] without a loop
        angle = angle % TWO_PI;

        // move to [-180 deg, +180 deg]
        if (angle < -Math.PI) angle += TWO_PI;
        if (angle >  Math.PI) angle -= TWO_PI;

        return angle;
    }

    /** Returns the next power of two that is equal to or bigger than the specified number. */
    public static function getNextPowerOfTwo(number:Float):Int
    {
        if (Math.round(number) == number && number > 0 && (Std.int(number) & Std.int(number - 1)) == 0) // see: http://goo.gl/D9kPj
            return Std.int(number);
        else
        {
            var result:Int = 1;
            number -= 0.000000001; // avoid floating point rounding errors

            while (result < number) result <<= 1;
            return result;
        }
    }

    /** Indicates if two float (Number) values are equal, give or take <code>epsilon</code>. */
    public static function isEquivalent(a:Float, b:Float, epsilon:Float=0.0001):Bool
    {
        return (a - epsilon < b) && (a + epsilon > b);
    }

    /** Returns the larger of the two values. Different to the native <code>Math.max</code>,
     *  this doesn't create any temporary objects when using the AOT compiler. */
    public static function max(a:Float, b:Float):Float
    {
        return a > b ? a : b;
    }

    /** Returns the smaller of the two values. Different to the native <code>Math.min</code>,
     *  this doesn't create any temporary objects when using the AOT compiler. */
    public static function min(a:Float, b:Float):Float
    {
        return a < b ? a : b;
    }

    /** Moves <code>value</code> into the range between <code>min</code> and <code>max</code>. */
    public static function clamp(value:Float, min:Float, max:Float):Float
    {
        return value < min ? min : (value > max ? max : value);
    }
    
    /** Returns the smallest value in an array. */
    public static function minValues(values:Array<Float>):Float
    {
        if (values.length == 0)
            return 0.0;
        var min:Float = values[0];
        for (i in 1...values.length)
            if (values[i] < min)
                min = values[i];
        return min;
    }
    
    /** Converts an angle from degrees into radians. */
    public static function deg2rad(deg:Float):Float
    {
        return deg / 180.0 * Math.PI;
    }
    
    /** Converts an angle from radians into degrees. */
    public static function rad2deg(rad:Float):Float
    {
        return rad / Math.PI * 180.0;
    }
}
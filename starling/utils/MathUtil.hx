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

import flash.geom.Point;
import flash.geom.Vector3D;

/** A utility class containing methods you might need for maths problems. */
class MathUtil
{
    private static var TWO_PI:Float = Math.PI * 2.0;

    /** Calculates the intersection point between the xy-plane and an infinite line
     * that is defined by two 3D points in the same coordinate system. */
    public static function intersectLineWithXYPlane(pointA:Vector3D, pointB:Vector3D,
                                                    resultPoint:Point=null):Point
    {
        if (resultPoint == null) resultPoint = new Point();

        var vectorX:Float = pointB.x - pointA.x;
        var vectorY:Float = pointB.y - pointA.y;
        var vectorZ:Float = pointB.z - pointA.z;
        var lambda:Float = -pointA.z / vectorZ;

        resultPoint.x = pointA.x + lambda * vectorX;
        resultPoint.y = pointA.y + lambda * vectorY;

        return resultPoint;
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
    
    /** Moves 'value' into the range between 'min' and 'max'. */
    public static function clamp(value:Float, min:Float, max:Float):Float
    {
        return value < min ? min : (value > max ? max : value);
    }
    
    /** Returns the smallest value in an array. */
    public static function min(values:Array<Float>):Float
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
// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.Vector;
import openfl.utils.Float32Array;

import starling.errors.AbstractClassError;

/** A utility class containing methods related to the Matrix class. */
class MatrixUtil
{
    /** Helper object. */
    #if flash
    private static var sRawData:Vector<Float> = Vector.ofArray(
        [1.0, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1]);
    private static var sRawData2:Vector<Float> = Vector.ofArray(
        [0.0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0]);
    #else
    private static var sRawData:Array<Float> = 
        [1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1];
    private static var sRawData2:Array<Float> =
        [0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0];
    #end
    
    /** @private */
    public function new() { throw new AbstractClassError(); }

    /** Converts a 2D matrix to a 3D matrix. If you pass a 'resultMatrix',
     *  the result will be stored in this matrix instead of creating a new object. */
    public static function convertTo3D(matrix:Matrix, resultMatrix:Matrix3D=null):Matrix3D
    {
        if (resultMatrix == null) resultMatrix = new Matrix3D();

        sRawData[ 0] = matrix.a;
        sRawData[ 1] = matrix.b;
        sRawData[ 4] = matrix.c;
        sRawData[ 5] = matrix.d;
        sRawData[12] = matrix.tx;
        sRawData[13] = matrix.ty;

        resultMatrix.copyRawDataFrom(sRawData);
        return resultMatrix;
    }

    /** Converts a 3D matrix to a 2D matrix. Beware that this will work only for a 3D matrix
     *  describing a pure 2D transformation. */
    public static function convertTo2D(matrix3D:Matrix3D, resultMatrix:Matrix=null):Matrix
    {
        if (resultMatrix == null) resultMatrix = new Matrix();

        #if flash
        matrix3D.copyRawDataTo(sRawData2);
        #else
        ArrayUtil.copyVectorToArray(matrix3D.rawData, sRawData2);
        #end
        resultMatrix.a  = sRawData2[ 0];
        resultMatrix.b  = sRawData2[ 1];
        resultMatrix.c  = sRawData2[ 4];
        resultMatrix.d  = sRawData2[ 5];
        resultMatrix.tx = sRawData2[12];
        resultMatrix.ty = sRawData2[13];

        return resultMatrix;
    }

    public static function transformPoint(matrix:Matrix, point:Point,
                                          resultPoint:Point=null):Point
    {
        return transformCoords(matrix, point.x, point.y, resultPoint);
    }

    public static function transformPoint3D(matrix:Matrix3D, point:Vector3D,
                                            resultPoint:Vector3D=null):Vector3D
    {
        return transformCoords3D(matrix, point.x, point.y, point.z, resultPoint);
    }

    /** Uses a matrix to transform 2D coordinates into a different space. If you pass a
     *  'resultPoint', the result will be stored in this point instead of creating a
     *  new object. */
    public static function transformCoords(matrix:Matrix, x:Float, y:Float,
                                           resultPoint:Point=null):Point
    {
        if (resultPoint == null) resultPoint = new Point();

        resultPoint.x = matrix.a * x + matrix.c * y + matrix.tx;
        resultPoint.y = matrix.d * y + matrix.b * x + matrix.ty;

        return resultPoint;
    }

    /** Uses a matrix to transform 3D coordinates into a different space. If you pass a
     *  'resultVector', the result will be stored in this vector3D instead of creating a
     *  new object. */
    public static function transformCoords3D(matrix:Matrix3D, x:Float, y:Float, z:Float,
                                             resultPoint:Vector3D=null):Vector3D
    {
        if (resultPoint == null) resultPoint = new Vector3D();

        #if flash
        matrix.copyRawDataTo(sRawData2);
        #else
        ArrayUtil.copyVectorToArray(matrix.rawData, sRawData2);
        #end
        resultPoint.x = x * sRawData2[0] + y * sRawData2[4] + z * sRawData2[ 8] + sRawData2[12];
        resultPoint.y = x * sRawData2[1] + y * sRawData2[5] + z * sRawData2[ 9] + sRawData2[13];
        resultPoint.z = x * sRawData2[2] + y * sRawData2[6] + z * sRawData2[10] + sRawData2[14];
        resultPoint.w = x * sRawData2[3] + y * sRawData2[7] + z * sRawData2[11] + sRawData2[15];

        return resultPoint;
    }

    /** Appends a skew transformation to a matrix (angles in radians). The skew matrix
     *  has the following form:
     *  <pre>
     *  | cos(skewY)  -sin(skewX)  0 |
     *  | sin(skewY)   cos(skewX)  0 |
     *  |     0            0       1 |
     *  </pre>
     */
    public static function skew(matrix:Matrix, skewX:Float, skewY:Float):Void
    {
        var sinX:Float = Math.sin(skewX);
        var cosX:Float = Math.cos(skewX);
        var sinY:Float = Math.sin(skewY);
        var cosY:Float = Math.cos(skewY);

        matrix.setTo(matrix.a  * cosY - matrix.b  * sinX,
                     matrix.a  * sinY + matrix.b  * cosX,
                     matrix.c  * cosY - matrix.d  * sinX,
                     matrix.c  * sinY + matrix.d  * cosX,
                     matrix.tx * cosY - matrix.ty * sinX,
                     matrix.tx * sinY + matrix.ty * cosX);
    }

    /** Prepends a matrix to 'base' by multiplying it with another matrix. */
    public static function prependMatrix(base:Matrix, prep:Matrix):Void
    {
        base.setTo(base.a * prep.a + base.c * prep.b,
                   base.b * prep.a + base.d * prep.b,
                   base.a * prep.c + base.c * prep.d,
                   base.b * prep.c + base.d * prep.d,
                   base.tx + base.a * prep.tx + base.c * prep.ty,
                   base.ty + base.b * prep.tx + base.d * prep.ty);
    }

    /** Prepends an incremental translation to a Matrix object. */
    public static function prependTranslation(matrix:Matrix, tx:Float, ty:Float):Void
    {
        matrix.tx += matrix.a * tx + matrix.c * ty;
        matrix.ty += matrix.b * tx + matrix.d * ty;
    }

    /** Prepends an incremental scale change to a Matrix object. */
    public static function prependScale(matrix:Matrix, sx:Float, sy:Float):Void
    {
        matrix.setTo(matrix.a * sx, matrix.b * sx,
                     matrix.c * sy, matrix.d * sy,
                     matrix.tx, matrix.ty);
    }

    /** Prepends an incremental rotation to a Matrix object (angle in radians). */
    public static function prependRotation(matrix:Matrix, angle:Float):Void
    {
        var sin:Float = Math.sin(angle);
        var cos:Float = Math.cos(angle);

        matrix.setTo(matrix.a * cos + matrix.c * sin,  matrix.b * cos + matrix.d * sin,
                     matrix.c * cos - matrix.a * sin,  matrix.d * cos - matrix.b * sin,
                     matrix.tx, matrix.ty);
    }

    /** Prepends a skew transformation to a Matrix object (angles in radians). The skew matrix
     *  has the following form:
     *  <pre>
     *  | cos(skewY)  -sin(skewX)  0 |
     *  | sin(skewY)   cos(skewX)  0 |
     *  |     0            0       1 |
     *  </pre>
     */
    public static function prependSkew(matrix:Matrix, skewX:Float, skewY:Float):Void
    {
        var sinX:Float = Math.sin(skewX);
        var cosX:Float = Math.cos(skewX);
        var sinY:Float = Math.sin(skewY);
        var cosY:Float = Math.cos(skewY);

        matrix.setTo(matrix.a * cosY + matrix.c * sinY,
                     matrix.b * cosY + matrix.d * sinY,
                     matrix.c * cosX - matrix.a * sinX,
                     matrix.d * cosX - matrix.b * sinX,
                     matrix.tx, matrix.ty);
    }
}
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

import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Vector3D;

import openfl.Vector;

/** A utility class containing methods related to the Matrix class. */

@:jsRequire("starling/utils/MatrixUtil", "default")

extern class MatrixUtil
{
    /** Converts a 2D matrix to a 3D matrix. If you pass an <code>out</code>-matrix,
     * the result will be stored in this matrix instead of creating a new object. */
    public static function convertTo3D(matrix:Matrix, out:Matrix3D=null):Matrix3D;

    /** Converts a 3D matrix to a 2D matrix. Beware that this will work only for a 3D matrix
     * describing a pure 2D transformation. */
    public static function convertTo2D(matrix3D:Matrix3D, out:Matrix=null):Matrix;

    /** Determines if the matrix is an identity matrix. */
    public static function isIdentity(matrix:Matrix):Bool;

    /** Determines if the 3D matrix is an identity matrix. */
    public static function isIdentity3D(matrix:Matrix3D):Bool;

    /** Transform a point with the given matrix. */
    public static function transformPoint(matrix:Matrix, point:Point,
                                            out:Point=null):Point;

    /** Transforms a 3D point with the given matrix. */
    public static function transformPoint3D(matrix:Matrix3D, point:Vector3D,
                                            out:Vector3D=null):Vector3D;

    /** Uses a matrix to transform 2D coordinates into a different space. If you pass an
     * <code>out</code>-point, the result will be stored in this point instead of creating a
     * new object. */
    public static function transformCoords(matrix:Matrix, x:Float, y:Float,
                                           out:Point=null):Point;

    /** Uses a matrix to transform 3D coordinates into a different space. If you pass a
     * 'resultVector', the result will be stored in this vector3D instead of creating a
     * new object. */
    public static function transformCoords3D(matrix:Matrix3D, x:Float, y:Float, z:Float,
                                             out:Vector3D=null):Vector3D;

    /** Appends a skew transformation to a matrix (angles in radians). The skew matrix
     * has the following form:
     * <pre>
     * | cos(skewY)  -sin(skewX)  0 |
     * | sin(skewY)   cos(skewX)  0 |
     * |     0            0       1 |
     * </pre>
     */
    public static function skew(matrix:Matrix, skewX:Float, skewY:Float):Void;

    /** Prepends a matrix to 'base' by multiplying it with another matrix. */
    public static function prependMatrix(base:Matrix, prep:Matrix):Void;

    /** Prepends an incremental translation to a Matrix object. */
    public static function prependTranslation(matrix:Matrix, tx:Float, ty:Float):Void;

    /** Prepends an incremental scale change to a Matrix object. */
    public static function prependScale(matrix:Matrix, sx:Float, sy:Float):Void;

    /** Prepends an incremental rotation to a Matrix object (angle in radians). */
    public static function prependRotation(matrix:Matrix, angle:Float):Void;

    /** Prepends a skew transformation to a Matrix object (angles in radians). The skew matrix
     * has the following form:
     * <pre>
     * | cos(skewY)  -sin(skewX)  0 |
     * | sin(skewY)   cos(skewX)  0 |
     * |     0            0       1 |
     * </pre>
     */
    public static function prependSkew(matrix:Matrix, skewX:Float, skewY:Float):Void;

    /** Converts a Matrix3D instance to a String, which is useful when debugging. Per default,
        *  the raw data is displayed transposed, so that the columns are displayed vertically. */
    public static function toString3D(matrix:Matrix3D, transpose:Bool=true,
                                        precision:Int=3):String;

    /** Converts a Matrix instance to a String, which is useful when debugging. */
    public static function toString(matrix:Matrix, precision:Int=3):String;

    /** Updates the given matrix so that it points exactly to pixel boundaries. This works
        *  only if the object is unscaled and rotated by a multiple of 90 degrees.
        *
        *  @param matrix    The matrix to manipulate in place (normally the modelview matrix).
        *  @param pixelSize The size (in points) that represents one pixel in the back buffer.
        */
    public static function snapToPixels(matrix:Matrix, pixelSize:Float):Void;

    /** Creates a perspective projection matrix suitable for 2D and 3D rendering.
        *
        *  <p>The first 4 parameters define which area of the stage you want to view (the camera
        *  will 'zoom' to exactly this region). The final 3 parameters determine the perspective
        *  in which you're looking at the stage.</p>
        *
        *  <p>The stage is always on the rectangle that is spawned up between x- and y-axis (with
        *  the given size). All objects that are exactly on that rectangle (z equals zero) will be
        *  rendered in their true size, without any distortion.</p>
        *
        *  <p>If you pass only the first 4 parameters, the camera will be set up above the center
        *  of the stage, with a field of view of 1.0 rad.</p>
        */
    public static function createPerspectiveProjectionMatrix(
            x:Float, y:Float, width:Float, height:Float,
            stageWidth:Float=0, stageHeight:Float=0, cameraPos:Vector3D=null,
            out:Matrix3D=null):Matrix3D;

    /** Creates a orthographic projection matrix suitable for 2D rendering. */
    public static function createOrthographicProjectionMatrix(
            x:Float, y:Float, width:Float, height:Float, out:Matrix=null):Matrix;
}
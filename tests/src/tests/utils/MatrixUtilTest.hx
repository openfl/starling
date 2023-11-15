// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.utils;

import openfl.Vector;
import openfl.geom.Matrix3D;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import starling.utils.MatrixUtil;
import utest.Assert;
import utest.Test;

class MatrixUtilTest extends Test
{
	
	public function testConvertTo3D():Void
	{
		var matrix:Matrix = new Matrix(1, 2, 3, 4, 5, 6);
		var matrix3D:Matrix3D = MatrixUtil.convertTo3D(matrix);
		var rawData:Vector<Float> = matrix3D.rawData;

		Assert.equals(1, rawData[0]);
		Assert.equals(2, rawData[1]);
		Assert.equals(3, rawData[4]);
		Assert.equals(4, rawData[5]);
		Assert.equals(5, rawData[12]);
		Assert.equals(6, rawData[13]);

		for (i in [2, 3, 6, 7, 8, 9, 11, 14])
			Assert.equals(0, rawData[i]);

		for (i in [10, 15])
			Assert.equals(1, rawData[i]);
	}

	
	public function testConvertTo2D():Void
	{
		var matrix:Matrix;
		var matrix3D:Matrix3D = new Matrix3D();
		var rawData:Vector<Float> = matrix3D.rawData;

		rawData[ 0] = 1;
		rawData[ 1] = 2;
		rawData[ 4] = 3;
		rawData[ 5] = 4;
		rawData[12] = 5;
		rawData[13] = 6;
		matrix3D.copyRawDataFrom(rawData);

		matrix = MatrixUtil.convertTo2D(matrix3D);
		Assert.equals(1, matrix.a);
		Assert.equals(2, matrix.b);
		Assert.equals(3, matrix.c);
		Assert.equals(4, matrix.d);
		Assert.equals(5, matrix.tx);
		Assert.equals(6, matrix.ty);
	}

	
	public function testTransformPoint():Void
	{
		var point:Point = new Point(1, 2);
		var matrix:Matrix = new Matrix(1, 2, 3, 4, 5, 6);
		var result1:Point = matrix.transformPoint(point);
		var result2:Point = MatrixUtil.transformPoint(matrix, point);
		Assert.isTrue(result1.equals(result2));
	}

	
	public function testTransformPoint3D():Void
	{
		var point:Vector3D = new Vector3D(1, 2, 3);
		var matrix3D:Matrix3D = new Matrix3D();
		var rawData:Vector<Float> = matrix3D.rawData;

		for (i in 0...16)
			rawData[i] = i+1;

		matrix3D.copyRawDataFrom(rawData);
		var result1:Vector3D = matrix3D.transformVector(point);
		var result2:Vector3D = MatrixUtil.transformPoint3D(matrix3D, point);
		Assert.isTrue(result1.equals(result2));
	}

	
	public function testIsIdentity():Void
	{
		var matrix:Matrix = new Matrix();
		Assert.isTrue(MatrixUtil.isIdentity(matrix));

		matrix.translate(10, 20);
		matrix.rotate(0.5);
		Assert.isFalse(MatrixUtil.isIdentity(matrix));

		matrix.identity();
		Assert.isTrue(MatrixUtil.isIdentity(matrix));
	}

	
	public function testIsIdentity3D():Void
	{
		var matrix:Matrix3D = new Matrix3D();
		Assert.isTrue(MatrixUtil.isIdentity3D(matrix));

		matrix.appendTranslation(10, 20, 30);
		matrix.appendRotation(0.5, Vector3D.X_AXIS);
		Assert.isFalse(MatrixUtil.isIdentity3D(matrix));

		matrix.identity();
		Assert.isTrue(MatrixUtil.isIdentity3D(matrix));
	}
}
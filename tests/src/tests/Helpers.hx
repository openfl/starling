// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests;

import haxe.PosInfos;
import org.hamcrest.Matcher;
import org.hamcrest.AssertionException;
import openfl.errors.Error;
import haxe.Constraints.Function;
import openfl.geom.Matrix;
import openfl.geom.Vector3D;
import openfl.Vector;
import openfl.utils.ByteArray;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import utest.Assert;
import org.hamcrest.Matchers.closeTo;

class Helpers
{
	public static function compareRectangles(rect1:Rectangle, rect2:Rectangle, 
												e:Float=0.0001):Void
	{
		assertThat(rect1.x, closeTo(rect2.x, e));
		assertThat(rect1.y, closeTo(rect2.y, e));
		assertThat(rect1.width, closeTo(rect2.width, e));
		assertThat(rect1.height, closeTo(rect2.height, e));
	}
	
	public static function comparePoints(point1:Point, point2:Point, e:Float=0.0001):Void
	{
		assertThat(point1.x, closeTo(point2.x, e));
		assertThat(point1.y, closeTo(point2.y, e));
	}
	
	public static function compareVector3Ds(v1:Vector3D, v2:Vector3D, e:Float=0.0001):Void
	{
		assertThat(v1.x, closeTo(v2.x, e));
		assertThat(v1.y, closeTo(v2.y, e));
		assertThat(v1.z, closeTo(v2.z, e));
		assertThat(v1.w, closeTo(v2.w, e));
	}

	public static function compareArrays(array1:Array<Dynamic>, array2:Array<Dynamic>):Void
	{
		Assert.equals(array1.length, array2.length);

		for (i in 0...array1.length)
			Assert.equals(array1[i], array2[i]);
	}

	public static function compareVectorsOfNumbers(vector1:Vector<Float>, vector2:Vector<Float>,
											e:Float=0.0001):Void
	{
		Assert.equals(vector1.length, vector2.length);
		
		for (i in 0...vector1.length)
			assertThat(vector1[i], closeTo(vector2[i], e));
	}

	public static function compareVectorsOfUints(vector1:Vector<UInt>, vector2:Vector<UInt>):Void
	{
		Assert.equals(vector1.length, vector2.length);

		for (i in 0...vector1.length)
			Assert.equals(vector1[i], vector2[i]);
	}
	
	public static function compareByteArrays(b1:ByteArray, b2:ByteArray):Void
	{
		Assert.equals(b1.endian, b2.endian);
		Assert.equals(b1.length, b2.length);
		b1.position = b2.position = 0;

		while (b1.bytesAvailable > 0)
			Assert.equals(b1.readByte(), b2.readByte());
	}

	public static function compareByteArraysOfFloats(b1:ByteArray, b2:ByteArray, e:Float=0.0001):Void
	{
		Assert.equals(b1.endian, b2.endian);
		Assert.equals(b1.length, b2.length);
		b1.position = b2.position = 0;

		while (b1.bytesAvailable > 0)
			assertThat(b1.readFloat(), closeTo(b2.readFloat(), e));
	}
	
	public static function compareMatrices(matrix1:Matrix, matrix2:Matrix, e:Float=0.0001):Void
	{
		assertThat(matrix1.a,  closeTo(matrix2.a,  e));
		assertThat(matrix1.b,  closeTo(matrix2.b,  e));
		assertThat(matrix1.c,  closeTo(matrix2.c,  e));
		assertThat(matrix1.d,  closeTo(matrix2.d,  e));
		assertThat(matrix1.tx, closeTo(matrix2.tx, e));
		assertThat(matrix1.ty, closeTo(matrix2.ty, e));
	}

	public static function assertThat<T>(actual:Dynamic, ?matcher:Matcher<T>, ?reason:String, ?info:PosInfos):Void
	{
		try
		{
			org.hamcrest.Matchers.assertThat(actual, matcher, reason, info);
		}
		catch (e:AssertionException)
		{
			Assert.fail(e.message);
			return;
		}
		Assert.pass();
	}
	
	public static function assertDoesNotThrow(block:Function):Void
	{
		try
		{
			block();
		}
		catch (e:Error)
		{
			Assert.fail("Error thrown: " + e.message);
			return;
		}
		catch (e:Dynamic)
		{
			Assert.fail("Error thrown: " + e);
			return;
		}
		Assert.pass();
	}
}
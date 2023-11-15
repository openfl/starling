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

import openfl.geom.Point;
import openfl.geom.Vector3D;
import org.hamcrest.Matchers.closeTo;
import starling.utils.MathUtil;
import utest.Assert;
import utest.Test;

class MathUtilTest extends Test
{
	@:final private static var E:Float = 0.0001;

	
	public function testNormalizeAngle():Void
	{
		Helpers.assertThat(MathUtil.normalizeAngle(-5 * Math.PI), closeTo(-Math.PI, E));
		Helpers.assertThat(MathUtil.normalizeAngle(-3 * Math.PI), closeTo(-Math.PI, E));
		Helpers.assertThat(MathUtil.normalizeAngle(-2 * Math.PI), closeTo(0, E));
		Helpers.assertThat(MathUtil.normalizeAngle(-1 * Math.PI), closeTo(-Math.PI, E));
		Helpers.assertThat(MathUtil.normalizeAngle( 0 * Math.PI), closeTo(0, E));
		Helpers.assertThat(MathUtil.normalizeAngle( 1 * Math.PI), closeTo(Math.PI, E));
		Helpers.assertThat(MathUtil.normalizeAngle( 2 * Math.PI), closeTo(0, E));
		Helpers.assertThat(MathUtil.normalizeAngle( 3 * Math.PI), closeTo(Math.PI, E));
		Helpers.assertThat(MathUtil.normalizeAngle( 5 * Math.PI), closeTo(Math.PI, E));
	}

	
	public function testIntersectLineWithXYPlane():Void
	{
		var pointA:Vector3D = new Vector3D(6, 8, 6);
		var pointB:Vector3D = new Vector3D(18, 23, 24);
		var result:Point = MathUtil.intersectLineWithXYPlane(pointA, pointB);
		Helpers.assertThat(result.x, closeTo(2, E));
		Helpers.assertThat(result.y, closeTo(3, E));
	}

	
	public function testGetNextPowerOfTwo():Void
	{
		Assert.equals(1,   MathUtil.getNextPowerOfTwo(0));
		Assert.equals(1,   MathUtil.getNextPowerOfTwo(1));
		Assert.equals(2,   MathUtil.getNextPowerOfTwo(2));
		Assert.equals(4,   MathUtil.getNextPowerOfTwo(3));
		Assert.equals(4,   MathUtil.getNextPowerOfTwo(4));
		Assert.equals(8,   MathUtil.getNextPowerOfTwo(6));
		Assert.equals(32,  MathUtil.getNextPowerOfTwo(17));
		Assert.equals(64,  MathUtil.getNextPowerOfTwo(63));
		Assert.equals(256, MathUtil.getNextPowerOfTwo(129));
		Assert.equals(256, MathUtil.getNextPowerOfTwo(255));
		Assert.equals(256, MathUtil.getNextPowerOfTwo(256));
	}
}
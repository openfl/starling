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

import starling.utils.Align;
import starling.utils.Execute;
import starling.utils.MathUtil;
import starling.utils.ScaleMode;
import utest.Assert;
import utest.Test;

class UtilsTest extends Test
{
	
	public function testRad2Deg():Void
	{
		Assert.equals(  0.0, MathUtil.rad2deg(0));
		Assert.equals( 90.0, MathUtil.rad2deg(Math.PI / 2.0));
		Assert.equals(180.0, MathUtil.rad2deg(Math.PI));
		Assert.equals(270.0, MathUtil.rad2deg(Math.PI / 2.0 * 3.0));
		Assert.equals(360.0, MathUtil.rad2deg(2 * Math.PI));
	}
	
	
	public function testDeg2Rad():Void
	{
		Assert.equals(0.0, MathUtil.deg2rad(0));
		Assert.equals(Math.PI / 2.0, MathUtil.deg2rad(90.0));
		Assert.equals(Math.PI, MathUtil.deg2rad(180.0));
		Assert.equals(Math.PI / 2.0 * 3.0, MathUtil.deg2rad(270.0));
		Assert.equals(2 * Math.PI, MathUtil.deg2rad(360.0));
	} 

	
	public function testExecute():Void
	{
		function funcOne(a:String, b:String):Void
		{
			Assert.equals("a", a);
			Assert.equals("b", b);
		}

		function funcTwo(a:String, b:String):Void
		{
			Assert.equals("a", a);
			Assert.isNull(b);
		}

		Execute.execute(funcOne, ["a", "b"]);
		Execute.execute(funcOne, ["a", "b", "c"]);
		Execute.execute(funcTwo, ["a"]);
	}
	
	
	public function testAlignIsValid():Void
	{
		Assert.isTrue(Align.isValid(Align.CENTER));
		Assert.isTrue(Align.isValid(Align.LEFT));
		Assert.isTrue(Align.isValid(Align.RIGHT));
		Assert.isTrue(Align.isValid(Align.TOP));
		Assert.isTrue(Align.isValid(Align.BOTTOM));
		Assert.isFalse(Align.isValid("invalid value"));
	}
	
	
	public function testAlignIsValidVertical():Void
	{
		Assert.isTrue(Align.isValidVertical(Align.BOTTOM));
		Assert.isTrue(Align.isValidVertical(Align.CENTER));
		Assert.isTrue(Align.isValidVertical(Align.TOP));
		Assert.isFalse(Align.isValidVertical(Align.LEFT));
		Assert.isFalse(Align.isValidVertical(Align.RIGHT));
	}

	
	public function testAlignIsValidHorizontal():Void
	{
		Assert.isTrue(Align.isValidHorizontal(Align.LEFT));
		Assert.isTrue(Align.isValidHorizontal(Align.CENTER));
		Assert.isTrue(Align.isValidHorizontal(Align.RIGHT));
		Assert.isFalse(Align.isValidHorizontal(Align.TOP));
		Assert.isFalse(Align.isValidHorizontal(Align.BOTTOM));
	}
	
	
	public function testScaleModeIsValid():Void
	{
		Assert.isTrue(ScaleMode.isValid(ScaleMode.NO_BORDER));
		Assert.isTrue(ScaleMode.isValid(ScaleMode.NONE));
		Assert.isTrue(ScaleMode.isValid(ScaleMode.SHOW_ALL));
		Assert.isFalse(ScaleMode.isValid("invalid value"));
	}
}
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
import starling.utils.Color;
import utest.Assert;
import utest.Test;

class ColorTest extends Test
{
	@:final private static var E:Float = 0.004;

	
	public function testGetElement():Void
	{
		var color:UInt = 0xaabbcc;
		Assert.equals(0xaa, Color.getRed(color));
		Assert.equals(0xbb, Color.getGreen(color));
		Assert.equals(0xcc, Color.getBlue(color));
	}

	
	public function testSetElement():Void
	{
		var color:UInt = 0xaabbccdd;
		Assert.equals((0xffbbccdd : UInt), Color.setAlpha(color, 0xff));
		Assert.equals((0xaaffccdd : UInt), Color.setRed(color, 0xff));
		Assert.equals((0xaabbffdd : UInt), Color.setGreen(color, 0xff));
		Assert.equals((0xaabbccff : UInt), Color.setBlue(color, 0xff));
	}

	
	public function testRgb():Void
	{
		var color:UInt = Color.rgb(0xaa, 0xbb, 0xcc);
		Assert.equals(0xaabbcc, color);
	}

	
	public function testArgb():Void
	{
		var color:UInt = Color.argb(0xaa, 0xbb, 0xcc, 0xdd);
		Assert.equals((0xaabbccdd : UInt), color);
	}

	
	public function testHslToRgb():Void
	{
		// Colors from: http://www.rapidtables.com/convert/color/hsl-to-rgb.htm
		Assert.equals(Color.hsl(d2u(0), 0.5, 0), 0x000000);
		Assert.equals(Color.hsl(d2u(0), 0.5, 1.0), 0xFFFFFF);
		Assert.equals(Color.hsl(d2u(0), 1.0, 0.5), 0xFF0000);
		Assert.equals(Color.hsl(d2u(60), 1.0, 0.5), 0xFFFF00);
		Assert.equals(Color.hsl(d2u(120), 1.0, 0.5), 0x00FF00);
		Assert.equals(Color.hsl(d2u(180), 1.0, 0.5), 0x00FFFF);
		Assert.equals(Color.hsl(d2u(240), 1.0, 0.5), 0x0000FF);
		Assert.equals(Color.hsl(d2u(300), 1.0, 0.5), 0xFF00FF);
		Assert.equals(Color.hsl(d2u(0), 0, 0.75), 0xC0C0C0);
		Assert.equals(Color.hsl(d2u(0), 0, 0.5), 0x808080);
		Assert.equals(Color.hsl(d2u(0), 1.0, 0.25), 0x800000);
		Assert.equals(Color.hsl(d2u(60), 1.0, 0.25), 0x808000);
		Assert.equals(Color.hsl(d2u(120), 1.0, 0.25), 0x008000);
		Assert.equals(Color.hsl(d2u(300), 1.0, 0.25), 0x800080);
		Assert.equals(Color.hsl(d2u(180), 1.0, 0.25), 0x008080);
		Assert.equals(Color.hsl(d2u(240), 1.0, 0.25), 0x000080);
	}

	
	public function testRgbToHsl():Void
	{
		// Colors from: http://www.rapidtables.com/convert/color/rgb-to-hsl.htm
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x000000), Vector.ofArray([d2u(0), 0.0, 0.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0xFFFFFF), Vector.ofArray([d2u(0), 0.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0xFF0000), Vector.ofArray([d2u(0), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0xFFFF00), Vector.ofArray([d2u(60), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x00FF00), Vector.ofArray([d2u(120), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x00FFFF), Vector.ofArray([d2u(180), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x0000FF), Vector.ofArray([d2u(240), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0xFF00FF), Vector.ofArray([d2u(300), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0xC0C0C0), Vector.ofArray([d2u(0), 0.0, 0.75]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x808080), Vector.ofArray([d2u(0), 0.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x800000), Vector.ofArray([d2u(0), 1.0, 0.25]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x808000), Vector.ofArray([d2u(60), 1.0, 0.25]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x008000), Vector.ofArray([d2u(120), 1.0, 0.25]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x800080), Vector.ofArray([d2u(300), 1.0, 0.25]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x008080), Vector.ofArray([d2u(180), 1.0, 0.25]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsl(0x000080), Vector.ofArray([d2u(240), 1.0, 0.25]), E);
	}

	
	public function testHsvToRgb():Void
	{
		// Colors from: http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
		Assert.equals(Color.hsv(d2u(0), 0, 0), 0x000000);
		Assert.equals(Color.hsv(d2u(0), 0, 1.0), 0xFFFFFF);
		Assert.equals(Color.hsv(d2u(0), 1.0, 1.0), 0xFF0000);
		Assert.equals(Color.hsv(d2u(60), 1.0, 1.0), 0xFFFF00);
		Assert.equals(Color.hsv(d2u(120), 1.0, 1.0), 0x00FF00);
		Assert.equals(Color.hsv(d2u(180), 1.0, 1.0), 0x00FFFF);
		Assert.equals(Color.hsv(d2u(240), 1.0, 1.0), 0x0000FF);
		Assert.equals(Color.hsv(d2u(300), 1.0, 1.0), 0xFF00FF);
		Assert.equals(Color.hsv(d2u(0), 0, 0.75), 0xC0C0C0);
		Assert.equals(Color.hsv(d2u(0), 0, 0.5), 0x808080);
		Assert.equals(Color.hsv(d2u(0), 1.0, 0.5), 0x800000);
		Assert.equals(Color.hsv(d2u(60), 1.0, 0.5), 0x808000);
		Assert.equals(Color.hsv(d2u(120), 1.0, 0.5), 0x008000);
		Assert.equals(Color.hsv(d2u(300), 1.0, 0.5), 0x800080);
		Assert.equals(Color.hsv(d2u(180), 1.0, 0.5), 0x008080);
		Assert.equals(Color.hsv(d2u(240), 1.0, 0.5), 0x000080);
	}

	
	public function testRgbToHsv():Void
	{
		// Colors from: http://www.rapidtables.com/convert/color/rgb-to-hsv.htm
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x000000), Vector.ofArray([d2u(0), 0.0, 0.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0xFFFFFF), Vector.ofArray([d2u(0), 0.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0xFF0000), Vector.ofArray([d2u(0), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0xFFFF00), Vector.ofArray([d2u(60), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x00FF00), Vector.ofArray([d2u(120), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x00FFFF), Vector.ofArray([d2u(180), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x0000FF), Vector.ofArray([d2u(240), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0xFF00FF), Vector.ofArray([d2u(300), 1.0, 1.0]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0xC0C0C0), Vector.ofArray([d2u(0), 0.0, 0.75]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x808080), Vector.ofArray([d2u(0), 0.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x800000), Vector.ofArray([d2u(0), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x808000), Vector.ofArray([d2u(60), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x008000), Vector.ofArray([d2u(120), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x800080), Vector.ofArray([d2u(300), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x008080), Vector.ofArray([d2u(180), 1.0, 0.5]), E);
		Helpers.compareVectorsOfNumbers(Color.rgbToHsv(0x000080), Vector.ofArray([d2u(240), 1.0, 0.5]), E);
	}
	
	private static function d2u(deg:Float):Float
	{
		return deg / 360.0;
	}
}
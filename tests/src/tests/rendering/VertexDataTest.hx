// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.rendering;

import openfl.geom.Matrix3D;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.utils.ByteArray;
import org.hamcrest.Matchers.closeTo;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.utils.Color;
import utest.Assert;
import utest.Test;

class VertexDataTest extends Test
{
	@:final private static var E:Float = 0.001;
	@:final private static var STD_FORMAT:String = "position:float2, texCoords:float2, color:bytes4";

	
	public function testNumVertices():Void
	{
		var vd:VertexData = new VertexData(STD_FORMAT);
		Assert.equals(0, vd.numVertices);

		vd.setPoint(0, "position", 1, 2);
		vd.setPoint(0, "texCoords", 0.1, 0.2);
		Assert.equals(1, vd.numVertices);
		Assert.equals(1.0, vd.getAlpha(0));
		Assert.equals(0xffffff, vd.getColor(0));
		Helpers.comparePoints(new Point(1, 2), vd.getPoint(0, "position"));
		Helpers.comparePoints(new Point(0.1, 0.2), vd.getPoint(0, "texCoords"));

		vd.setAlpha(2, "color", 0.5);
		Assert.equals(3, vd.numVertices);
		Assert.equals(1.0, vd.getAlpha(1));
		Assert.equals(0xffffff, vd.getColor(1));
		Helpers.assertThat(vd.getAlpha(2), closeTo(0.5, 0.003));

		vd.numVertices = 0;
		Assert.equals(0, vd.numVertices);

		vd.numVertices = 10;
		Assert.equals(10, vd.numVertices);

		for (i in 0...10)
		{
			Assert.equals(1.0, vd.getAlpha(i));
			Assert.equals(0xffffff, vd.getColor(i));
			Helpers.comparePoints(vd.getPoint(i, "position"), new Point());
			Helpers.comparePoints(vd.getPoint(i, "texCoords"), new Point());
		}
	}

	#if !flash
	@Ignored
	public function testBoundsLow():Void
	{
		Assert.raises(function():Void
		{
			var vd:VertexData = new VertexData(STD_FORMAT);
			vd.numVertices = 3;
			vd.getColor(-1, "color");
		}, openfl.errors.Error);
	}
	#end

	public function testBoundsHigh():Void
	{
		Assert.raises(function():Void
		{
			var vd:VertexData = new VertexData(STD_FORMAT);
			vd.numVertices = 3;
			vd.getColor(3, "color");
		}, openfl.errors.Error);
	}

	
	public function testWriteAndReadSimpleAttributes():Void
	{
		var vd:VertexData = new VertexData("pos1D:float1, pos2D:float2, pos3D:float3, pos4D:float4");
		vd.numVertices = 3;

		vd.setFloat(1, "pos1D", 0.5);
		Helpers.assertThat(0.0, closeTo(vd.getFloat(0, "pos1D"), E));
		Helpers.assertThat(0.5, closeTo(vd.getFloat(1, "pos1D"), E));
		Helpers.assertThat(0.0, closeTo(vd.getFloat(2, "pos1D"), E));

		var origin:Point = new Point();
		var point:Point = new Point(20, 40);
		vd.setPoint(1, "pos2D", point.x, point.y);
		Helpers.comparePoints(origin, vd.getPoint(0, "pos2D"));
		Helpers.comparePoints(point,  vd.getPoint(1, "pos2D"));
		Helpers.comparePoints(origin, vd.getPoint(2, "pos2D"));

		var origin3D:Vector3D = new Vector3D();
		var vector3D:Vector3D = new Vector3D(1.0, 2.0, 3.0);
		vd.setPoint3D(1, "pos3D", vector3D.x, vector3D.y, vector3D.z);
		Helpers.compareVector3Ds(origin3D, vd.getPoint3D(0, "pos3D"));
		Helpers.compareVector3Ds(vector3D, vd.getPoint3D(1, "pos3D"));
		Helpers.compareVector3Ds(origin3D, vd.getPoint3D(2, "pos3D"));

		var origin4D:Vector3D = new Vector3D();
		var vector4D:Vector3D = new Vector3D(1.0, 2.0, 3.0, 4.0);
		vd.setPoint4D(1, "pos4D", vector4D.x, vector4D.y, vector4D.z, vector4D.w);
		Helpers.compareVector3Ds(origin4D, vd.getPoint4D(0, "pos4D"));
		Helpers.compareVector3Ds(vector4D, vd.getPoint4D(1, "pos4D"));
		Helpers.compareVector3Ds(origin4D, vd.getPoint4D(2, "pos4D"));
	}

	
	public function testColor():Void
	{
		var vd:VertexData = new VertexData(STD_FORMAT);
		vd.numVertices = 3;
		vd.premultipliedAlpha = true;

		Assert.equals(3, vd.numVertices);
		Assert.isTrue(vd.premultipliedAlpha);

		// per default, colors must be white with full alpha
		for (i in 0...3)
		{
			Assert.equals(1.0, vd.getAlpha(i));
			Assert.equals(0xffffff, vd.getColor(i));
		}

		vd.setColor(0, "color", 0xffaabb);
		vd.setColor(1, "color", 0x112233);

		Assert.equals(0xffaabb, vd.getColor(0, "color"));
		Assert.equals(0x112233, vd.getColor(1, "color"));
		Assert.equals(1.0, vd.getAlpha(0, "color"));

		// check premultiplied alpha

		var alpha:Float = 0.8;
		var red:Int   = 80;
		var green:Int = 60;
		var blue:Int  = 40;
		var rgb:UInt = Color.rgb(red, green, blue);

		vd.setColor(2, "color", rgb);
		vd.setAlpha(2, "color", alpha);
		Assert.equals(rgb, vd.getColor(2, "color"));
		Assert.equals(1.0, vd.getAlpha(1, "color"));
		Assert.equals(alpha, vd.getAlpha(2, "color"));

		var data:ByteArray = vd.rawData;
		var offset:Int = (vd.vertexSize * 2 + vd.getOffset("color"));

		Assert.equals(data[offset  ], Std.int(red   * alpha));
		Assert.equals(data[offset+1], Std.int(green * alpha));
		Assert.equals(data[offset+2], Std.int(blue  * alpha));

		// changing the pma setting should update contents

		vd.setPremultipliedAlpha(false, true);
		Assert.isFalse(vd.premultipliedAlpha);

		Assert.equals(0xffaabb, vd.getColor(0, "color"));
		Assert.equals(0x112233, vd.getColor(1, "color"));
		Assert.equals(1.0, vd.getAlpha(0, "color"));

		vd.setColor(2, "color", rgb);
		vd.setAlpha(2, "color", alpha);
		Assert.equals(rgb, vd.getColor(2, "color"));
		Assert.equals(alpha, vd.getAlpha(2, "color"));

		Assert.equals(data[offset  ], red);
		Assert.equals(data[offset+1], green);
		Assert.equals(data[offset+2], blue);
	}

	
	public function testScaleAlpha():Void
	{
		function makeTest(pma:Bool):Void
		{
			var vd:VertexData = new VertexData(STD_FORMAT);
			vd.numVertices = 3;
			vd.premultipliedAlpha = pma;
			vd.colorize("color", 0xffffff, 0.9);
			vd.scaleAlphas("color", 0.9);

			for (i in 0...3)
			{
				Helpers.assertThat(vd.getAlpha(i), closeTo(0.81, 0.005));
				Assert.equals(0xffffff, vd.getColor(i));
			}
		}
		makeTest(true);
		makeTest(false);
	}

	
	public function testTranslatePoint():Void
	{
		var vd:VertexData = new VertexData("pos:float2");
		vd.setPoint(0, "pos", 10, 20);
		vd.setPoint(1, "pos", 30, 40);
		vd.translatePoints("pos", 5, 6, 0, -1);
		Helpers.comparePoints(new Point(15, 26), vd.getPoint(0, "pos"));
		Helpers.comparePoints(new Point(35, 46), vd.getPoint(1, "pos"));
	}

	
	public function testGetBounds():Void
	{
		var vd:VertexData = new VertexData("position:float2");
		var bounds:Rectangle = vd.getBounds();
		var expectedBounds:Rectangle = new Rectangle();

		Helpers.compareRectangles(expectedBounds, bounds);

		vd.numVertices = 2;
		vd.setPoint(0, "position", -10, -5);
		vd.setPoint(1, "position", 10, 5);

		bounds = vd.getBounds();
		expectedBounds = new Rectangle(-10, -5, 20, 10);

		Helpers.compareRectangles(expectedBounds, bounds);

		var matrix:Matrix = new Matrix();
		matrix.translate(10, 5);
		bounds = vd.getBounds("position", matrix);
		expectedBounds = new Rectangle(0, 0, 20, 10);

		Helpers.compareRectangles(expectedBounds, bounds);
	}

	
	public function testGetBoundsProjected():Void
	{
		var camPos:Vector3D = new Vector3D(0, 0, 10);
		var vd:VertexData = new VertexData("pos:float2");
		var bounds:Rectangle = vd.getBoundsProjected("pos", null, camPos);
		var expectedBounds:Rectangle = new Rectangle();

		Helpers.compareRectangles(expectedBounds, bounds);

		var matrix3D:Matrix3D = new Matrix3D();
		matrix3D.appendTranslation(0, 0, 5);

		vd.numVertices = 3;
		vd.setPoint(0, "pos", 0, 0);
		vd.setPoint(1, "pos", 5, 0);
		vd.setPoint(2, "pos", 0, 5);
		bounds = vd.getBoundsProjected("pos", matrix3D, camPos);
		expectedBounds.setTo(0, 0, 10, 10);

		Helpers.compareRectangles(expectedBounds, bounds);
	}

	
	public function testClone():Void
	{
		var vd1:VertexData = new VertexData(STD_FORMAT, 2);
		vd1.setPoint(0, "position", 1, 2);
		vd1.setColor(0, "color", 0xaabbcc);
		vd1.setPoint(0, "texCoords", 0.1, 0.2);
		vd1.setPoint(1, "position", 3, 4);
		vd1.setColor(1, "color", 0x334455);
		vd1.setPoint(1, "texCoords", 0.3, 0.4);

		var clone:VertexData = vd1.clone();
		Assert.equals(vd1.numVertices, clone.numVertices);
		Helpers.compareByteArrays(vd1.rawData, clone.rawData);
	}

	
	public function testCopyToWithIdenticalFormats():Void
	{
		var vd1:VertexData = new VertexData(STD_FORMAT, 2);
		vd1.setPoint(0, "position", 1, 2);
		vd1.setColor(0, "color", 0xaabbcc);
		vd1.setPoint(0, "texCoords", 0.1, 0.2);
		vd1.setPoint(1, "position", 3, 4);
		vd1.setColor(1, "color", 0x334455);
		vd1.setPoint(1, "texCoords", 0.3, 0.4);

		var vd2:VertexData = new VertexData(STD_FORMAT, 2);
		vd1.copyTo(vd2);

		Helpers.compareByteArrays(vd1.rawData, vd2.rawData);
		Assert.equals(vd1.numVertices, vd2.numVertices);

		vd1.copyTo(vd2, 2);
		Assert.equals(4, vd2.numVertices);

		vd1.rawData.position = 0;
		vd2.rawData.position = vd2.vertexSize * 2;

		for (i in 0...2)
			for (j in 0...vd2.vertexSizeIn32Bits)
				Assert.equals(vd1.rawData.readUnsignedInt(), vd2.rawData.readUnsignedInt());
	}

	
	public function testCopyToWithDifferentFormats():Void
	{
		var vd1:VertexData = new VertexData(STD_FORMAT);
		vd1.setPoint(0, "position", 1, 2);
		vd1.setColor(0, "color", 0xaabbcc);
		vd1.setPoint(0, "texCoords", 0.1, 0.2);
		vd1.setPoint(1, "position", 3, 4);
		vd1.setColor(1, "color", 0x334455);
		vd1.setPoint(1, "texCoords", 0.3, 0.4);

		var vd2:VertexData = new VertexData("texCoords:float2");
		vd1.copyTo(vd2);

		Assert.equals(2, vd2.numVertices);
		Helpers.comparePoints(vd1.getPoint(0, "texCoords"), vd2.getPoint(0, "texCoords"));
		Helpers.comparePoints(vd1.getPoint(1, "texCoords"), vd2.getPoint(1, "texCoords"));

		var origin:Point = new Point();
		var vd3:VertexData = new VertexData(STD_FORMAT);
		vd2.copyTo(vd3);

		Assert.equals(2, vd3.numVertices);
		Helpers.comparePoints(vd1.getPoint(0, "texCoords"), vd3.getPoint(0, "texCoords"));
		Helpers.comparePoints(vd1.getPoint(1, "texCoords"), vd3.getPoint(1, "texCoords"));
		Helpers.comparePoints(origin, vd3.getPoint(0, "position"));
		Helpers.comparePoints(origin, vd3.getPoint(1, "position"));
		Assert.equals(0xffffff, vd3.getColor(0, "color"));
		Assert.equals(0xffffff, vd3.getColor(1, "color"));
		Assert.equals(1.0, vd3.getAlpha(0, "color"));
		Assert.equals(1.0, vd3.getAlpha(1, "color"));
	}

	
	public function testCopyToTransformedWithIdenticalFormats():Void
	{
		var format:String = "pos:float2, color:bytes4";
		var vd1:VertexData = new VertexData(format);
		vd1.setPoint(0, "pos", 10, 20);
		vd1.setColor(0, "color", 0xaabbcc);
		vd1.setPoint(1, "pos", 30, 40);
		vd1.setColor(1, "color", 0x334455);

		var matrix:Matrix = new Matrix();
		matrix.translate(5, 6);

		var vd2:VertexData = new VertexData(format);
		vd1.copyTo(vd2, 0, matrix);

		Assert.equals(0xaabbcc, vd2.getColor(0, "color"));
		Assert.equals(0x334455, vd2.getColor(1, "color"));

		var p1:Point = new Point(15, 26);
		var p2:Point = new Point(35, 46);

		Helpers.comparePoints(p1, vd2.getPoint(0, "pos"));
		Helpers.comparePoints(p2, vd2.getPoint(1, "pos"));
	}

	
	public function testCopyToTransformedWithDifferentFormats():Void
	{
		var format:String = "color:bytes4, position:float2";
		var vd1:VertexData = new VertexData(format);
		vd1.setPoint(0, "position", 10, 20);
		vd1.setColor(0, "color", 0xaabbcc);
		vd1.setPoint(1, "position", 30, 40);
		vd1.setColor(1, "color", 0x334455);

		var matrix:Matrix = new Matrix();
		matrix.translate(5, 6);

		var vd2:VertexData = new VertexData("position:float2, flavor:float1");
		vd1.copyTo(vd2, 0, matrix);

		Assert.equals(0.0, vd2.getFloat(0, "flavor"));
		Assert.equals(0.0, vd2.getFloat(1, "flavor"));

		var p1:Point = new Point(15, 26);
		var p2:Point = new Point(35, 46);

		Helpers.comparePoints(p1, vd2.getPoint(0, "position"));
		Helpers.comparePoints(p2, vd2.getPoint(1, "position"));
	}

	
	public function testTransformPoints():Void
	{
		var vd:VertexData = new VertexData(STD_FORMAT);
		vd.setPoint(0, "position", 10, 20);
		vd.setPoint(1, "position", 30, 40);

		var matrix:Matrix = new Matrix();
		matrix.translate(5, 6);

		var position:Point = new Point();
		vd.transformPoints("position", matrix, 0, 1);
		vd.getPoint(0, "position", position);
		Helpers.comparePoints(position, new Point(15, 26));
		vd.getPoint(1, "position", position);
		Helpers.comparePoints(position, new Point(30, 40));

		matrix.identity();
		matrix.scale(0.5, 0.25);
		vd.transformPoints("position", matrix, 1, 1);
		vd.getPoint(0, "position", position);
		Helpers.comparePoints(position, new Point(15, 26));
		vd.getPoint(1, "position", position);
		Helpers.comparePoints(position, new Point(15, 10));
	}

	
	public function testTinted():Void
	{
		var vd:VertexData = new VertexData(STD_FORMAT);
		Assert.isFalse(vd.tinted);

		vd.numVertices = 1;
		Assert.equals(1.0, vd.getAlpha(0));
		Assert.equals(0xffffff, vd.getColor(0));
		Assert.isFalse(vd.tinted);

		vd.setColor(0, "color", 0xff0000);
		Assert.isTrue(vd.tinted);

		vd.colorize();
		Assert.isFalse(vd.tinted);

		vd.setAlpha(0, "color", 0.5);
		Assert.isTrue(vd.tinted);

		vd.colorize();
		Assert.isFalse(vd.tinted);

		var vd2:VertexData = new VertexData(STD_FORMAT);
		vd2.numVertices = 1;
		vd2.colorize("color", 0xff00ff, 0.8);
		Assert.isTrue(vd2.tinted);

		vd2.copyTo(vd, 1);
		Assert.equals(2, vd.numVertices);
		Assert.isTrue(vd.tinted);

		vd.colorize();
		Assert.isFalse(vd.tinted);

		vd.scaleAlphas("color", 0.5);
		Assert.isTrue(vd.tinted);
	}

	#if flash
	@Ignored
	#end
	public function testChangeFormat():Void
	{
		var vd:VertexData = new VertexData(STD_FORMAT);
		var p0:Point = new Point(10, 20);
		var p1:Point = new Point(30, 40);
		vd.setPoint(0, "position", p0.x, p0.y);
		vd.setPoint(1, "position", p1.x, p1.y);

		vd.format = VertexDataFormat.fromString(
				"newCoords:float2, position:float2, newColor:bytes4");

		Helpers.comparePoints(p0, vd.getPoint(0, "position"));
		Helpers.comparePoints(p1, vd.getPoint(1, "position"));
		Helpers.comparePoints(new Point(), vd.getPoint(0, "newCoords"));
		Helpers.comparePoints(new Point(), vd.getPoint(1, "newCoords"));
		Assert.equals(0xffffff, vd.getColor(0, "newColor"));
		Assert.equals(0xffffff, vd.getColor(1, "newColor"));
		Assert.equals(1.0, vd.getAlpha(0, "newColor"));
		Assert.equals(1.0, vd.getAlpha(1, "newColor"));
	}
}
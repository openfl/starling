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

import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import utest.Assert;
import utest.Test;

class RectangleUtilTest extends Test
{
	
	public function testIntersection():Void
	{
		var expectedRect:Rectangle;
		var rect:Rectangle = new Rectangle(-5, -10, 10, 20);
		
		var overlapRect:Rectangle = new Rectangle(-10, -15, 10, 10);
		var identRect:Rectangle = new Rectangle(-5, -10, 10, 20);
		var outsideRect:Rectangle = new Rectangle(10, 10, 10, 10);
		var touchingRect:Rectangle = new Rectangle(5, 0, 10, 10);
		var insideRect:Rectangle = new Rectangle(0, 0, 1, 2);
		
		expectedRect = new Rectangle(-5, -10, 5, 5);
		Helpers.compareRectangles(expectedRect,
			RectangleUtil.intersect(rect, overlapRect));
		
		expectedRect = rect;
		Helpers.compareRectangles(expectedRect,
			RectangleUtil.intersect(rect, identRect));
		
		expectedRect = new Rectangle();
		Helpers.compareRectangles(expectedRect,
			RectangleUtil.intersect(rect, outsideRect));
		
		expectedRect = new Rectangle(5, 0, 0, 10);
		Helpers.compareRectangles(expectedRect,
			RectangleUtil.intersect(rect, touchingRect));
		
		expectedRect = insideRect;
		Helpers.compareRectangles(expectedRect,
			RectangleUtil.intersect(rect, insideRect));
	}
	
	
	public function testFit():Void
	{
		var into:Rectangle = new Rectangle(50, 50, 200, 100);
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 200, 100), into),
			new Rectangle(50, 50, 200, 100));
				
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 50, 50), into, ScaleMode.NONE),
			new Rectangle(125, 75, 50, 50));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 400, 200), into, ScaleMode.NONE),
			new Rectangle(-50, 0, 400, 200));

		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 50, 50), into, ScaleMode.SHOW_ALL),
			new Rectangle(100, 50, 100, 100));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 400, 200), into, ScaleMode.SHOW_ALL),
			new Rectangle(50, 50, 200, 100));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 800, 400), into, ScaleMode.SHOW_ALL),
			new Rectangle(50, 50, 200, 100));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 400, 200), into, ScaleMode.NO_BORDER),
			new Rectangle(50, 50, 200, 100));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 200, 200), into, ScaleMode.NO_BORDER),
			new Rectangle(50, 0, 200, 200));
		
		Helpers.compareRectangles(
			RectangleUtil.fit(new Rectangle(0, 0, 800, 800), into, ScaleMode.NO_BORDER),
			new Rectangle(50, 0, 200, 200));
	}
	
	
	public function testNormalize():Void
	{
		var rect:Rectangle = new Rectangle(50, 100, -50, -100);
		RectangleUtil.normalize(rect);
		
		Helpers.compareRectangles(rect, new Rectangle(0, 0, 50, 100));
		
		rect = new Rectangle(1, 2, 3, 4);
		RectangleUtil.normalize(rect);
		
		Helpers.compareRectangles(rect, new Rectangle(1, 2, 3, 4));
	}

	
	public function testCompare():Void
	{
		var rect:Rectangle = new Rectangle(1, 2, 3, 4);
		var rect2:Rectangle = new Rectangle(2, 3, 4, 5);

		Assert.isTrue(RectangleUtil.compare(rect, rect));
		Assert.isTrue(RectangleUtil.compare(null, null));
		Assert.isFalse(RectangleUtil.compare(rect, null));
		Assert.isFalse(RectangleUtil.compare(null, rect));
		Assert.isFalse(RectangleUtil.compare(rect, rect2));
	}

	
	public function testGetBoundsProjected():Void
	{
		var camPos:Vector3D = new Vector3D(0, 0, 10);
		var bounds:Rectangle, expected:Rectangle;

		var matrix3D:Matrix3D = new Matrix3D();
		matrix3D.appendTranslation(0, 0, 5);

		var rectangle:Rectangle = new Rectangle(0, 0, 5, 5);
		bounds = RectangleUtil.getBoundsProjected(rectangle, matrix3D, camPos);
		expected = new Rectangle(0, 0, 10, 10);

		Helpers.compareRectangles(expected, bounds);
	}
}
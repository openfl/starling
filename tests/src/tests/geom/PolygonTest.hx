// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.geom;

import openfl.Vector;
import openfl.geom.Point;
import org.hamcrest.Matchers.closeTo;
import starling.geom.Polygon;
import utest.Assert;
import utest.Test;

class PolygonTest extends Test
{
	@:final private static var E:Float = 0.0001;

	
	public function testConstructorWithPoints():Void
	{
		var polygon:Polygon = new Polygon([new Point(0, 1), new Point(2, 3), new Point(4, 5)]);
		Assert.equals(3, polygon.numVertices);
		Helpers.comparePoints(new Point(0, 1), polygon.getVertex(0));
		Helpers.comparePoints(new Point(2, 3), polygon.getVertex(1));
		Helpers.comparePoints(new Point(4, 5), polygon.getVertex(2));
	}

	
	public function testConstructorWithCoords():Void
	{
		var polygon:Polygon = new Polygon([0, 1,  2, 3,  4, 5]);
		Assert.equals(3, polygon.numVertices);
		Helpers.comparePoints(new Point(0, 1), polygon.getVertex(0));
		Helpers.comparePoints(new Point(2, 3), polygon.getVertex(1));
		Helpers.comparePoints(new Point(4, 5), polygon.getVertex(2));
	}

	
	public function testClone():Void
	{
		var polygon:Polygon = new Polygon([0, 1,  2, 3,  4, 5]);
		var clone:Polygon = polygon.clone();
		Assert.equals(3, clone.numVertices);
		Helpers.comparePoints(new Point(0, 1), clone.getVertex(0));
		Helpers.comparePoints(new Point(2, 3), clone.getVertex(1));
		Helpers.comparePoints(new Point(4, 5), clone.getVertex(2));
	}

	
	public function testTriangulate():Void
	{
		// 0-------1
		// |       |
		// 5----4  |
		//      |  |
		//      |  |
		//      3--2

		var p0:Point = new Point(0, 0);
		var p1:Point = new Point(4, 0);
		var p2:Point = new Point(4, 4);
		var p3:Point = new Point(3, 4);
		var p4:Point = new Point(3, 1);
		var p5:Point = new Point(0, 1);

		var polygon:Polygon = new Polygon([p0, p1, p2, p3, p4, p5]);
		var indices:Vector<UInt> = polygon.triangulate().toVector();
		var expected:Vector<UInt> = Vector.ofArray(([1,2,3, 1,3,4, 0,1,4, 0,4,5] : Array<UInt>));

		Helpers.compareVectorsOfUints(indices, expected);
	}

	
	public function testTriangulateFewPoints():Void
	{
		var p0:Point = new Point(0, 0);
		var p1:Point = new Point(1, 0);
		var p2:Point = new Point(0, 1);

		var polygon:Polygon = new Polygon([p0]);
		Assert.equals(0, polygon.triangulate().numIndices);

		polygon.addVertices([p1]);
		Assert.equals(0, polygon.triangulate().numIndices);

		polygon.addVertices([p2]);
		Assert.equals(3, polygon.triangulate().numIndices);
	}

	
	public function testTriangulateNonSimplePolygon():Void
	{
		// 0---1
		//  \ /
		//   X
		//  / \
		// 2---3

		// The triangulation won't be meaningful, but at least it should work.

		var p0:Point = new Point(0, 0);
		var p1:Point = new Point(1, 0);
		var p2:Point = new Point(0, 1);
		var p3:Point = new Point(1, 1);

		var polygon:Polygon = new Polygon([p0, p1, p2, p3]);
		var indices:Vector<UInt> = polygon.triangulate().toVector();
		var expected:Vector<UInt> = Vector.ofArray(([0,1,2, 0,2,3] : Array<UInt>));

		Helpers.compareVectorsOfUints(indices, expected);
	}

	
	public function testInside():Void
	{
		var polygon:Polygon;
		var p0:Point, p1:Point, p2:Point, p3:Point, p4:Point, p5:Point;

		// 0--1
		// | /
		// 2

		p0 = new Point(0, 0);
		p1 = new Point(1, 0);
		p2 = new Point(0, 1);

		polygon = new Polygon([p0, p1, p2]);
		Assert.isTrue(polygon.contains(0.25, 0.25));
		Assert.isFalse(polygon.contains(0.75, 0.75));

		// 0------1
		// |    3 |
		// |   / \|
		// 5--4   2

		p1 = new Point(4, 0);
		p2 = new Point(4, 2);
		p3 = new Point(3, 1);
		p4 = new Point(2, 2);
		p5 = new Point(0, 2);

		polygon = new Polygon([p0, p1, p2, p3, p4, p5]);
		Assert.isTrue(polygon.contains(1, 1));
		Assert.isTrue(polygon.contains(1, 1.5));
		Assert.isTrue(polygon.contains(2.5, 1.25));
		Assert.isTrue(polygon.contains(3.5, 1.25));
		Assert.isFalse(polygon.contains(3, 1.1));
		Assert.isFalse(polygon.contains(-1, -1));
		Assert.isFalse(polygon.contains(2, 3));
		Assert.isFalse(polygon.contains(6, 1));
		Assert.isFalse(polygon.contains(5, 3));
	}

	
	public function testIsConvex():Void
	{
		var polygon:Polygon;
		var p0:Point, p1:Point, p2:Point, p3:Point, p4:Point, p5:Point;

		// 0--1
		// | /
		// 2

		p0 = new Point(0, 0);
		p1 = new Point(1, 0);
		p2 = new Point(0, 1);

		polygon = new Polygon([p0, p1, p2]);
		Assert.isTrue(polygon.isConvex);

		polygon = new Polygon([p0, p2, p1]);
		Assert.isFalse(polygon.isConvex);

		// 0--1
		// |  |
		// 3--2

		p2 = new Point(1, 1);
		p3 = new Point(0, 1);

		polygon = new Polygon([p0, p1, p2, p3]);
		Assert.isTrue(polygon.isConvex);

		polygon = new Polygon([p0, p3, p2, p1]);
		Assert.isFalse(polygon.isConvex);

		// 0------1
		// |    3 |
		// |   / \|
		// 5--4   2

		p1 = new Point(4, 0);
		p2 = new Point(4, 2);
		p3 = new Point(3, 1);
		p4 = new Point(2, 2);
		p5 = new Point(0, 2);

		polygon = new Polygon([p0, p1, p2, p3, p4, p5]);
		Assert.isFalse(polygon.isConvex);
	}

	
	public function testArea():Void
	{
		var polygon:Polygon;
		var p0:Point, p1:Point, p2:Point, p3:Point;

		// 0--1
		// | /
		// 2

		p0 = new Point(0, 0);
		p1 = new Point(1, 0);
		p2 = new Point(0, 1);

		polygon = new Polygon([p0, p1, p2]);
		Helpers.assertThat(polygon.area, closeTo(0.5, E));

		// 0--1
		// |  |
		// 3--2

		p2 = new Point(1, 1);
		p3 = new Point(0, 1);

		polygon = new Polygon([p0, p1, p2, p3]);
		Helpers.assertThat(polygon.area, closeTo(1.0, E));

		// 0--1

		polygon = new Polygon([p0, p1]);
		Helpers.assertThat(polygon.area, closeTo(0.0, E));

		polygon = new Polygon([p0]);
		Helpers.assertThat(polygon.area, closeTo(0.0, E));
	}

	
	public function testReverse():Void
	{
		var p0:Point = new Point(0, 1);
		var p1:Point = new Point(2, 3);
		var p2:Point = new Point(4, 5);

		var polygon:Polygon = new Polygon([p0]);
		polygon.reverse();

		Helpers.comparePoints(polygon.getVertex(0), p0);

		polygon.addVertices([p1, p2]);
		polygon.reverse();

		Helpers.comparePoints(polygon.getVertex(0), p2);
		Helpers.comparePoints(polygon.getVertex(1), p1);
		Helpers.comparePoints(polygon.getVertex(2), p0);
	}

	
	public function testIsSimple():Void
	{
		var polygon:Polygon;
		var p0:Point, p1:Point, p2:Point, p3:Point, p4:Point, p5:Point;

		// 0------1
		// |    3 |
		// |   / \|
		// 5--4   2

		p0 = new Point(0, 0);
		p1 = new Point(4, 0);
		p2 = new Point(4, 2);
		p3 = new Point(3, 1);
		p4 = new Point(2, 2);
		p5 = new Point(0, 2);

		polygon = new Polygon([p0, p1, p2, p3, p4, p5]);
		Assert.isTrue(polygon.isSimple);

		// move point (3) up

		polygon.setVertex(3, 3, -1);
		Assert.isFalse(polygon.isSimple);

		// 0---1
		//  \ /
		//   X
		//  / \
		// 2---3

		p1 = new Point(1, 0);
		p2 = new Point(0, 1);
		p3 = new Point(1, 1);

		polygon = new Polygon([p0, p1, p2, p3]);
		Assert.isFalse(polygon.isSimple);
	}

	
	public function testResize():Void
	{
		var polygon:Polygon = new Polygon([0, 1, 2, 3]);
		Assert.equals(2, polygon.numVertices);

		polygon.numVertices = 1;
		Assert.equals(1, polygon.numVertices);

		polygon.numVertices = 0;
		Assert.equals(0, polygon.numVertices);

		polygon.numVertices = 2;
		Assert.equals(2, polygon.numVertices);

		Assert.equals(0, polygon.getVertex(0).x);
		Assert.equals(0, polygon.getVertex(0).y);
		Assert.equals(0, polygon.getVertex(1).x);
		Assert.equals(0, polygon.getVertex(1).y);
	}

}
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

import openfl.Vector;
import starling.rendering.IndexData;
import utest.Assert;
import utest.Test;

class IndexDataTest extends Test
{
	
	public function testCreate():Void
	{
		var indexData:IndexData = new IndexData();
		Assert.equals(0, indexData.numIndices);
		Assert.isTrue(indexData.useQuadLayout);
	}

	
	public function testClear():Void
	{
		var indexData:IndexData = new IndexData();
		indexData.addTriangle(1, 2, 4);
		indexData.clear();

		Assert.equals(0, indexData.numIndices);
		Assert.isTrue(indexData.useQuadLayout);
	}

	
	public function testSetIndex():Void
	{
		var indexData:IndexData = new IndexData();

		// basic quad data

		indexData.setIndex(0, 0);
		indexData.setIndex(1, 1);
		indexData.setIndex(2, 2);

		Assert.isTrue(indexData.useQuadLayout);
		Assert.equals(0, indexData.getIndex(0));
		Assert.equals(1, indexData.getIndex(1));
		Assert.equals(2, indexData.getIndex(2));
		Assert.equals(3, indexData.numIndices);

		// setting outside the bounds while keeping quad index rules -> fill up with quad data

		indexData.setIndex(5, 2);
		Assert.isTrue(indexData.useQuadLayout);
		Assert.equals(2, indexData.numTriangles);
		Assert.equals(1, indexData.getIndex(3));
		Assert.equals(3, indexData.getIndex(4));
		Assert.equals(2, indexData.getIndex(5));

		// arbitrary data

		indexData.setIndex(6, 5);
		Assert.isFalse(indexData.useQuadLayout);
		Assert.equals(7, indexData.numIndices);
		Assert.equals(5, indexData.getIndex(6));

		// settings outside the bounds -> fill up with zeroes

		indexData.setIndex(9, 1);
		Assert.equals(10, indexData.numIndices);
		Assert.equals(0, indexData.getIndex(7));
		Assert.equals(0, indexData.getIndex(8));
		Assert.equals(1, indexData.getIndex(9));
	}

	
	public function testAppendTriangle():Void
	{
		var indexData:IndexData = new IndexData();

		// basic quad data

		indexData.addTriangle(0, 1, 2);
		indexData.addTriangle(1, 3, 2);

		Assert.isTrue(indexData.useQuadLayout);
		Assert.equals(1, indexData.numQuads);
		Assert.equals(2, indexData.numTriangles);
		Assert.equals(6, indexData.numIndices);

		Assert.equals(0, indexData.getIndex(0));
		Assert.equals(1, indexData.getIndex(1));
		Assert.equals(2, indexData.getIndex(2));
		Assert.equals(1, indexData.getIndex(3));
		Assert.equals(3, indexData.getIndex(4));
		Assert.equals(2, indexData.getIndex(5));

		indexData.numTriangles = 0;
		Assert.equals(0, indexData.numIndices);
		Assert.equals(0, indexData.numTriangles);

		// arbitrary data

		indexData.addTriangle(1, 3, 2);
		Assert.isFalse(indexData.useQuadLayout);
		Assert.equals(1, indexData.numTriangles);
		Assert.equals(3, indexData.numIndices);

		Assert.equals(1, indexData.getIndex(0));
		Assert.equals(3, indexData.getIndex(1));
		Assert.equals(2, indexData.getIndex(2));
	}

	
	public function testAppendQuad():Void
	{
		var indexData:IndexData = new IndexData();

		// basic quad data

		indexData.addQuad(0, 1, 2, 3);
		indexData.addQuad(4, 5, 6, 7);

		Assert.isTrue(indexData.useQuadLayout);
		Assert.equals(2, indexData.numQuads);
		Assert.equals(4, indexData.numTriangles);
		Assert.equals(12, indexData.numIndices);

		Assert.equals(0, indexData.getIndex(0));
		Assert.equals(1, indexData.getIndex(1));
		Assert.equals(2, indexData.getIndex(2));
		Assert.equals(1, indexData.getIndex(3));
		Assert.equals(3, indexData.getIndex(4));
		Assert.equals(2, indexData.getIndex(5));
		Assert.equals(4, indexData.getIndex(6));
		Assert.equals(5, indexData.getIndex(7));
		Assert.equals(6, indexData.getIndex(8));
		Assert.equals(5, indexData.getIndex(9));
		Assert.equals(7, indexData.getIndex(10));
		Assert.equals(6, indexData.getIndex(11));

		indexData.numTriangles = 0;
		Assert.equals(0, indexData.numIndices);
		Assert.equals(0, indexData.numQuads);

		// arbitrary data

		indexData.addQuad(0, 1, 3, 2);
		Assert.isFalse(indexData.useQuadLayout);
		Assert.equals(1, indexData.numQuads);
		Assert.equals(2, indexData.numTriangles);
		Assert.equals(6, indexData.numIndices);

		Assert.equals(0, indexData.getIndex(0));
		Assert.equals(1, indexData.getIndex(1));
		Assert.equals(3, indexData.getIndex(2));
		Assert.equals(1, indexData.getIndex(3));
		Assert.equals(2, indexData.getIndex(4));
		Assert.equals(3, indexData.getIndex(5));
	}

	
	public function testClone():Void
	{
		var indexData:IndexData;
		var clone:IndexData;

		// with basic quad data

		indexData = new IndexData();
		indexData.addTriangle(1, 2, 3);
		indexData.addTriangle(4, 5, 6);

		clone = indexData.clone();
		Assert.equals(2, clone.numTriangles);
		Assert.equals(1, clone.getIndex(0));
		Assert.equals(3, clone.getIndex(2));
		Assert.equals(5, clone.getIndex(4));

		// with arbitrary data

		indexData = new IndexData();
		indexData.addTriangle(0, 1, 2);
		indexData.addTriangle(1, 3, 2);

		clone = indexData.clone();
		Assert.equals(2, clone.numTriangles);
		Assert.equals(1, clone.getIndex(1));
		Assert.equals(2, clone.getIndex(2));
		Assert.equals(3, clone.getIndex(4));
	}

	
	public function testSetNumIndices():Void
	{
		var indexData:IndexData = new IndexData();
		indexData.numIndices = 6;

		Assert.equals(0, indexData.getIndex(0));
		Assert.equals(1, indexData.getIndex(1));
		Assert.equals(2, indexData.getIndex(2));
		Assert.equals(1, indexData.getIndex(3));
		Assert.equals(3, indexData.getIndex(4));
		Assert.equals(2, indexData.getIndex(5));

		indexData.numIndices = 0;
		Assert.equals(0, indexData.numIndices);

		indexData.setIndex(0, 1);
		Assert.isFalse(indexData.useQuadLayout);

		indexData.numIndices = 3;
		Assert.equals(1, indexData.getIndex(0));
		Assert.equals(0, indexData.getIndex(1));
		Assert.equals(0, indexData.getIndex(2));

		indexData.numIndices = 0;
		Assert.equals(0, indexData.numIndices);
		Assert.isTrue(indexData.useQuadLayout);
	}

	
	public function testCopyTo():Void
	{
		// arbitrary data -> arbitrary data

		var source:IndexData = new IndexData();
		source.addTriangle(1, 2, 3);
		source.addTriangle(4, 5, 6);

		var target:IndexData = new IndexData();
		target.addTriangle(7, 8, 9);
		source.copyTo(target, 0, 0, 3, 3);

		Assert.equals(3, target.numIndices);
		Assert.equals(4, target.getIndex(0));
		Assert.equals(5, target.getIndex(1));
		Assert.equals(6, target.getIndex(2));

		source.copyTo(target, 3);
		Assert.equals(9, target.numIndices);

		// quad data -> quad data

		source.clear();
		target.clear();

		source.addTriangle(0, 1, 2);
		target.addQuad(0, 1, 2, 3);
		source.copyTo(target, 6, 4);

		Assert.isTrue(target.useQuadLayout);
		Assert.equals(9, target.numIndices);
		Assert.equals(2, target.getIndex(5));
		Assert.equals(4, target.getIndex(6));
		Assert.equals(5, target.getIndex(7));
		Assert.equals(6, target.getIndex(8));

		// quad data -> arbitrary data

		target.clear();
		target.addQuad(1, 2, 3, 4);
		source.copyTo(target, 6, 4);

		Assert.isTrue(source.useQuadLayout);
		Assert.isFalse(target.useQuadLayout);
		Assert.equals(9, target.numIndices);
		Assert.equals(3, target.getIndex(5));
		Assert.equals(4, target.getIndex(6));
		Assert.equals(5, target.getIndex(7));
		Assert.equals(6, target.getIndex(8));

		// arbitrary data -> quad data

		source.clear();
		source.addTriangle(1, 2, 3);
		target.clear();
		target.addQuad(0, 1, 2, 3);
		source.copyTo(target, 6, 4);

		Assert.isFalse(source.useQuadLayout);
		Assert.isFalse(target.useQuadLayout);
		Assert.equals(9, target.numIndices);
		Assert.equals(2, target.getIndex(5));
		Assert.equals(5, target.getIndex(6));
		Assert.equals(6, target.getIndex(7));
		Assert.equals(7, target.getIndex(8));
	}

	
	public function testCopyToEdgeCases():Void
	{
		var source:IndexData = new IndexData();
		source.numIndices = 6;

		var target:IndexData = new IndexData();
		target.numIndices = 6;

		source.copyTo(target, 1, 1, 0, 1);
		Assert.isTrue(target.useQuadLayout);

		source.copyTo(target, 3, 0, 1, 1);
		Assert.isTrue(target.useQuadLayout);

		source.copyTo(target, 1, 1, 0, 2);
		Assert.isTrue(target.useQuadLayout);

		source.copyTo(target, 10, 5, 2, 2);
		Assert.isTrue(target.useQuadLayout);

		source.copyTo(target, 13, 8, 1, 4);
		Assert.isTrue(target.useQuadLayout);

		source.copyTo(target, 10, 3, 4, 1);
		Assert.isFalse(target.useQuadLayout);
		Assert.equals(6, target.getIndex(10));
	}

	
	public function testCopyToWithOffset():Void
	{
		var source:IndexData = new IndexData();
		source.addTriangle(1, 2, 3);
		source.addTriangle(4, 5, 6);

		var target:IndexData = new IndexData();
		target.addTriangle(7, 8, 9);
		source.copyTo(target, 1, 10, 3, 3);

		Assert.equals(4, target.numIndices);
		Assert.equals(7, target.getIndex(0));
		Assert.equals(14, target.getIndex(1));
		Assert.equals(15, target.getIndex(2));
		Assert.equals(16, target.getIndex(3));
	}

	
	public function testOffsetIndices():Void
	{
		var indexData:IndexData = new IndexData();
		indexData.addTriangle(1, 2, 3);
		indexData.addTriangle(4, 5, 6);

		indexData.offsetIndices(10, 1, 3);
		Assert.equals( 1, indexData.getIndex(0));
		Assert.equals(12, indexData.getIndex(1));
		Assert.equals(13, indexData.getIndex(2));
		Assert.equals(14, indexData.getIndex(3));
		Assert.equals( 5, indexData.getIndex(4));
	}

	
	public function testToVector():Void
	{
		var source:IndexData = new IndexData();
		source.addTriangle(1, 2, 3);
		source.addTriangle(4, 5, 6);

		var expected:Vector<UInt> = Vector.ofArray(([1, 2, 3, 4, 5, 6] : Array<UInt>));
		Helpers.compareVectorsOfUints(source.toVector(), expected);
	}

	
	public function testSetIsBasicQuadData():Void
	{
		var indexData:IndexData = new IndexData();
		indexData.numIndices = 6;
		Assert.isTrue(indexData.useQuadLayout);
		Assert.equals(1, indexData.getIndex(3));

		indexData.setIndex(3, 10);
		Assert.isFalse(indexData.useQuadLayout);

		indexData.useQuadLayout = true;
		Assert.equals(1, indexData.getIndex(3));

		// basic quad data must be sized correctly
		indexData.useQuadLayout = false;
		indexData.numIndices = 12;
		indexData.useQuadLayout = true;
		indexData.useQuadLayout = false;
		Assert.equals(6, indexData.getIndex(11));
	}
}
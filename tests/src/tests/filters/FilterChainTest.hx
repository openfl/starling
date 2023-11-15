// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.filters;

import openfl.Vector;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.filters.FilterChain;
import starling.filters.FragmentFilter;
import tests.StarlingTest;
import utest.Assert;

class FilterChainTest extends StarlingTest
{
	
	public function testConstructor():Void
	{
		var filters:Vector<FragmentFilter> = getTestFilters();
		var chain:FilterChain = new FilterChain([filters[0], filters[1], filters[2]]);

		for (i in 0...filters.length)
			Assert.equals(filters[i], chain.getFilterAt(i));

		Assert.equals(filters.length, chain.numFilters);
	}

	
	public function testAddFilter():Void
	{
		var filters:Vector<FragmentFilter> = getTestFilters();
		var chain:FilterChain = new FilterChain();

		chain.addFilter(filters[0]);
		chain.addFilter(filters[2]);
		chain.addFilterAt(filters[1], 1);

		for (i in 0...filters.length)
			Assert.equals(filters[i], chain.getFilterAt(i));

		Assert.equals(filters.length, chain.numFilters);
	}

	
	public function testRemoveFilter():Void
	{
		var filters:Vector<FragmentFilter> = getTestFilters();
		var chain:FilterChain = new FilterChain([filters[0], filters[1], filters[2]]);
		var removedFilter:FragmentFilter = chain.removeFilter(filters[1]);

		Assert.equals(removedFilter, filters[1]);
		Assert.equals(filters.length - 1, chain.numFilters);

		removedFilter = chain.removeFilterAt(0);
		Assert.equals(removedFilter, filters[0]);
		Assert.equals(filters.length - 2, chain.numFilters);
		Assert.equals(filters[2], chain.getFilterAt(0));
	}

	
	public function testGetFilterAt():Void
	{
		var filters:Vector<FragmentFilter> = getTestFilters();
		var chain:FilterChain = new FilterChain([filters[0], filters[1], filters[2]]);

		Assert.equals(filters[2], chain.getFilterAt(2));
		Assert.equals(filters[2], chain.getFilterAt(-1));
		Assert.equals(filters[0], chain.getFilterAt(-3));
	}

	
	public function testDispatchEvent():Void
	{
		var changeCount:Int = 0;

		function onChange():Void
		{
			changeCount++;
		}

		var chain:FilterChain = new FilterChain();
		var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();

		chain.addEventListener(Event.CHANGE, onChange);
		chain.addFilter(colorFilter);
		Assert.equals(1, changeCount);

		colorFilter.invert();
		Assert.equals(2, changeCount);
	}

	private function getTestFilters():Vector<FragmentFilter>
	{
		return Vector.ofArray([
			new FragmentFilter(), new ColorMatrixFilter(), new BlurFilter()]);
	}
}
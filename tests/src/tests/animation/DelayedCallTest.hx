// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.animation;

import starling.animation.DelayedCall;
import utest.Assert;
import utest.Test;

class DelayedCallTest extends Test
{		
	public function testSimple():Void
	{
		var sum:Int = 0;
		
		function raiseSum(by:Int):Void
		{
			sum += by;
		}

		var dc:DelayedCall = new DelayedCall(raiseSum, 1.0, [5]);
		
		dc.advanceTime(0.5);
		Assert.equals(0, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(0.25);
		Assert.equals(0, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(0.25);
		Assert.equals(5, sum);
		Assert.isTrue(dc.isComplete);
	}
	
	
	public function testRepeated():Void
	{
		var sum:Int = 0;
		
		function raiseSum(by:Int):Void
		{
			sum += by;
		}

		var dc:DelayedCall = new DelayedCall(raiseSum, 1.0, [5]);
		dc.repeatCount = 3;
		
		dc.advanceTime(0.5);
		Assert.equals(0, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(1.0);
		Assert.equals(5, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(1.0);
		Assert.equals(10, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(0.5);
		Assert.equals(15, sum);
		Assert.isTrue(dc.isComplete);
		
		dc.advanceTime(20);
		Assert.equals(15, sum);
	}
	
	
	public function testIndefinitive():Void
	{
		var sum:Int = 0;
		
		function raiseSum(by:Int):Void
		{
			sum += by;
		}

		var dc:DelayedCall = new DelayedCall(raiseSum, 1.0, [5]);
		dc.repeatCount = 0;
		
		dc.advanceTime(1.5);
		Assert.equals(5, sum);
		Assert.isFalse(dc.isComplete);
		
		dc.advanceTime(10.0);
		Assert.equals(55, sum);
		Assert.isFalse(dc.isComplete);
	}

	
	public function testComplete():Void
	{
		var sum:Int = 0;

		function raiseSum():Void
		{
			sum += 1;
		}

		var dc:DelayedCall = new DelayedCall(raiseSum, 1.0);

		dc.advanceTime(0.5);
		Assert.equals(0, sum);

		dc.complete();
		Assert.equals(1, sum);
		Assert.isTrue(dc.isComplete);

		dc.complete();
		Assert.equals(1, sum);

		dc.advanceTime(10);
		Assert.equals(1, sum);

		dc = new DelayedCall(raiseSum, 1.0);
		dc.repeatCount = 3;

		sum = 0;
		dc.complete();
		Assert.equals(1, sum);
		Assert.isFalse(dc.isComplete);

		for (i in 0...10)
			dc.complete();

		Assert.equals(3, sum);
		Assert.isTrue(dc.isComplete);
	}
}
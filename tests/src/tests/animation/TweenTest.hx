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

import openfl.display.Shape;
import org.hamcrest.Matchers.closeTo;
import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Quad;
import starling.utils.MathUtil;
import utest.Assert;
import utest.Test;

class TweenTest extends Test
{
	@:final private var E:Float = 0.0001;
	
	public function testBasicTween():Void
	{
		var startX:Float = 10.0;
		var startY:Float = 20.0;
		var endX:Float = 100.0;
		var endY:Float = 200.0;
		var startAlpha:Float = 1.0;
		var endAlpha:Float = 0.0;
		var totalTime:Float = 2.0;
		
		var startCount:Int = 0;
		var updateCount:Int = 0;
		var completeCount:Int = 0;
		
		var quad:Quad = new Quad(100, 100);
		quad.x = startX;
		quad.y = startY;
		quad.alpha = startAlpha;
		
		var tween:Tween = new Tween(quad, totalTime, Transitions.LINEAR);
		tween.moveTo(endX, endY);
		tween.animate("alpha", endAlpha);
		tween.onStart    = function():Void { startCount++; };
		tween.onUpdate   = function():Void { updateCount++; };
		tween.onComplete = function():Void { completeCount++; };
		
		tween.advanceTime(totalTime / 3.0);
		Helpers.assertThat(quad.x, closeTo(startX + (endX-startX)/3.0, E));
		Helpers.assertThat(quad.y, closeTo(startY + (endY-startY)/3.0, E));
		Helpers.assertThat(quad.alpha, closeTo(startAlpha + (endAlpha-startAlpha)/3.0, E));
		Assert.equals(1, startCount);
		Assert.equals(1, updateCount);
		Assert.equals(0, completeCount);
		Assert.isFalse(tween.isComplete);
		
		tween.advanceTime(totalTime / 3.0);
		Helpers.assertThat(quad.x, closeTo(startX + 2*(endX-startX)/3.0, E));
		Helpers.assertThat(quad.y, closeTo(startY + 2*(endY-startY)/3.0, E));
		Helpers.assertThat(quad.alpha, closeTo(startAlpha + 2*(endAlpha-startAlpha)/3.0, E));
		Assert.equals(1, startCount);
		Assert.equals(2, updateCount);
		Assert.equals(0, completeCount);
		Assert.isFalse(tween.isComplete);
		
		tween.advanceTime(totalTime / 3.0);
		Helpers.assertThat(quad.x, closeTo(endX, E));
		Helpers.assertThat(quad.y, closeTo(endY, E));
		Helpers.assertThat(quad.alpha, closeTo(endAlpha, E));
		Assert.equals(1, startCount);
		Assert.equals(3, updateCount);
		Assert.equals(1, completeCount);
		Assert.isTrue(tween.isComplete);
	}
	
	
	public function testSequentialTweens():Void
	{
		var startPos:Float  = 0.0;
		var targetPos:Float = 50.0;
		var quad:Quad = new Quad(100, 100);
		
		// 2 tweens should move object up, then down
		var tween1:Tween = new Tween(quad, 1.0);
		tween1.animate("y", targetPos);
		
		var tween2:Tween = new Tween(quad, 1.0);
		tween2.animate("y", startPos);
		tween2.delay = tween1.totalTime;
		
		tween1.advanceTime(1.0);
		Helpers.assertThat(quad.y, closeTo(targetPos, E));
		
		tween2.advanceTime(1.0);
		Helpers.assertThat(quad.y, closeTo(targetPos, E));
		
		tween2.advanceTime(0.5);
		Helpers.assertThat(quad.y, closeTo((targetPos - startPos)/2.0, E));
		
		tween2.advanceTime(0.5);
		Helpers.assertThat(quad.y, closeTo(startPos, E));
	}
	
	
	public function testTweenFromZero():Void
	{
		var quad:Quad = new Quad(100, 100);
		quad.scaleX = 0.0;
		
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("scaleX", 1.0);
		
		tween.advanceTime(0.0);
		Helpers.assertThat(quad.width, closeTo(0.0, E));
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.width, closeTo(50.0, E));
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.width, closeTo(100.0, E));
	}
	
	
	public function testResetTween():Void
	{
		var quad:Quad = new Quad(100, 100);
		
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("x", 100);
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(50, E));
		
		tween.reset(this, 1.0);
		tween.advanceTime(0.5);
		
		// tween should no longer change quad.x
		Helpers.assertThat(quad.x, closeTo(50, E));
	}
	
	
	public function testResetTweenInOnComplete():Void
	{
		var quad:Quad = new Quad(100, 100);
		var juggler:Juggler = new Juggler();
		
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("x", 100);
		tween.onComplete = function():Void
		{
			tween.reset(quad, 1.0);
			tween.animate("x", 0);
			juggler.add(tween);
		};
		
		juggler.add(tween);
		
		juggler.advanceTime(1.1);
		Helpers.assertThat(quad.x, closeTo(100, E));
		Helpers.assertThat(tween.currentTime, closeTo(0, E));
		
		juggler.advanceTime(1.0);
		Helpers.assertThat(quad.x, closeTo(0, E));
		Assert.isTrue(tween.isComplete);
	}
	
	
	public function testShortTween():Void
	{
		executeTween(0.1, 0.1);
	}
	
	
	public function testZeroTween():Void
	{
		executeTween(0.0, 0.1);
	}
	
	
	public function testCustomTween():Void
	{		
		function transition(ratio:Float):Float
		{
			return ratio;
		}

		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0, transition);
		tween.animate("x", 100);
		
		tween.advanceTime(0.1);
		Helpers.assertThat(quad.x, closeTo(10, E));
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(60, E));
		
		tween.advanceTime(0.4);
		Helpers.assertThat(quad.x, closeTo(100, E));
		
		Assert.equals("custom", tween.transition);
	}
	
	
	public function testRepeatedTween():Void
	{
		var startCount:Int = 0;
		var repeatCount:Int = 0;
		var completeCount:Int = 0;
		
		function onStart():Void { startCount++; }
		function onRepeat():Void { repeatCount++; }
		function onComplete():Void { completeCount++; }
		
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		tween.repeatCount = 3;
		tween.onStart = onStart;
		tween.onRepeat = onRepeat;
		tween.onComplete = onComplete;
		tween.animate("x", 100);
		
		tween.advanceTime(1.5);
		Helpers.assertThat(quad.x, closeTo(50, E));
		Assert.equals(tween.repeatCount, 2);
		Assert.equals(startCount, 1);
		Assert.equals(repeatCount, 1);
		Assert.equals(completeCount, 0);
		
		tween.advanceTime(0.75);
		Helpers.assertThat(quad.x, closeTo(25, E));
		Assert.equals(tween.repeatCount, 1);
		Assert.equals(startCount, 1);
		Assert.equals(repeatCount, 2);
		Assert.equals(completeCount, 0);
		Assert.isFalse(tween.isComplete);
		
		tween.advanceTime(1.0);
		Helpers.assertThat(quad.x, closeTo(100, E));
		Assert.equals(tween.repeatCount, 1);
		Assert.equals(startCount, 1);
		Assert.equals(repeatCount, 2);
		Assert.equals(completeCount, 1);
		Assert.isTrue(tween.isComplete);
	}
	
	
	public function testReverseTween():Void
	{
		var startCount:Int = 0;
		var completeCount:Int = 0;
		
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		tween.repeatCount = 4;
		tween.reverse = true;
		tween.animate("x", 100);
		
		tween.advanceTime(0.75);
		Helpers.assertThat(quad.x, closeTo(75, E));            
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(75, E));
		
		tween.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(25, E));
		Assert.isFalse(tween.isComplete);

		tween.advanceTime(1.25);
		Helpers.assertThat(quad.x, closeTo(100, E));
		Assert.isFalse(tween.isComplete);
		
		tween.advanceTime(10);
		Helpers.assertThat(quad.x, closeTo(0, E));
		Assert.isTrue(tween.isComplete);
	}
	
	
	public function testInfiniteTween():Void
	{
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("x", 100);
		tween.repeatCount = 0;
		
		tween.advanceTime(30.5);
		Helpers.assertThat(quad.x, closeTo(50, E));

		tween.advanceTime(100.5);
		Helpers.assertThat(quad.x, closeTo(100, E));
		Assert.isFalse(tween.isComplete);
	}
	
	
	public function testGetEndValue():Void
	{
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("x", 100);
		tween.fadeTo(0);
		tween.scaleTo(1.5);
		
		Assert.equals(100, tween.getEndValue("x"));
		Assert.equals(0, tween.getEndValue("alpha"));
		Assert.equals(1.5, tween.getEndValue("scaleX"));
		Assert.equals(1.5, tween.getEndValue("scaleY"));
	}
	
	
	public function testProgress():Void
	{		
		function easeIn(ratio:Float):Float
		{
			return ratio * ratio * ratio;
		}

		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0, easeIn);
		Assert.equals(0.0, tween.progress);
		
		tween.advanceTime(0.5);
		Helpers.assertThat(tween.progress, closeTo(easeIn(0.5), E));
		
		tween.advanceTime(0.25);
		Helpers.assertThat(tween.progress, closeTo(easeIn(0.75), E));
		
		tween.advanceTime(1.0);
		Helpers.assertThat(tween.progress, closeTo(easeIn(1.0), E));
	}

	
	public function testColor():Void
	{
		var quad:Quad = new Quad(100, 100, 0xff00ff);
		var tween:Tween = new Tween(quad, 1.0);
		tween.animate("color", 0x00ff00);
		tween.advanceTime(0.5);
		Assert.equals(quad.color, 0x7f7f7f);
	}

	
	public function testRotationRad():Void
	{
		var quad:Quad = new Quad(100, 100);
		quad.rotation = MathUtil.deg2rad(-170);

		var tween:Tween = new Tween(quad, 1.0);
		tween.rotateTo(MathUtil.deg2rad(170));
		tween.advanceTime(0.5);

		Helpers.assertThat(quad.rotation, closeTo(-Math.PI, E));

		tween.advanceTime(0.5);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(170), E));
	}

	
	public function testRotationDeg():Void
	{
		var shape:Shape = new Shape();
		shape.rotation = -170;

		var tween:Tween = new Tween(shape, 1.0);
		tween.rotateTo(170, "deg");
		tween.advanceTime(0.5);

		Helpers.assertThat(shape.rotation, closeTo(-180, E));

		tween.advanceTime(0.5);
		// Flash normalizes the angle, but OpenFL might not
		Helpers.assertThat(MathUtil.normalizeAngle(shape.rotation * Math.PI / 180.0) * 180.0 / Math.PI, closeTo(170, E));
	}

	
	public function testAnimatesProperty():Void
	{
		var shape:Shape = new Shape();
		var tween:Tween = new Tween(shape, 1.0);
		tween.animate("x", 5.0);
		tween.animate("rotation", 0.5);

		Assert.isTrue(tween.animatesProperty("x"));
		Assert.isTrue(tween.animatesProperty("rotation"));
		Assert.isFalse(tween.animatesProperty("y"));
		Assert.isFalse(tween.animatesProperty("alpha"));
	}

	private function executeTween(time:Float, advanceTime:Float):Void
	{
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, time);
		tween.animate("x", 100);
		
		var startCount:Int = 0;
		var updateCount:Int = 0;
		var completeCount:Int = 0;
		
		tween.onStart    = function():Void { startCount++; };
		tween.onUpdate   = function():Void { updateCount++; };
		tween.onComplete = function():Void { completeCount++; };
		
		tween.advanceTime(advanceTime);
		
		Assert.equals(1, updateCount);
		Assert.equals(1, startCount);
		Assert.equals(advanceTime >= time ? 1 : 0, completeCount);
	}
}
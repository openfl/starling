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

import starling.animation.Juggler;
import starling.animation.Tween;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import utest.Assert;
import utest.Test;
import org.hamcrest.Matchers.closeTo;

class JugglerTest extends Test
{
	@:final private var E:Float = 0.0001;
	
	public function testModificationWithinCallback():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		var startReached:Bool = false;
		juggler.add(tween);
		
		tween.onComplete = function():Void 
		{
			var otherTween:Tween = new Tween(quad, 1.0);
			otherTween.onStart = function():Void 
			{ 
				startReached = true; 
			};
			juggler.add(otherTween);
		};
		
		juggler.advanceTime(0.4); // -> 0.4 (start)
		juggler.advanceTime(0.4); // -> 0.8 (update)
		juggler.advanceTime(0.4); // -> 1.2 (complete)
		juggler.advanceTime(0.4); // -> 1.6 (start of new tween)
		
		Assert.isTrue(startReached);
	}
	
	
	public function testContains():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		
		Assert.isFalse(juggler.contains(tween));
		juggler.add(tween);
		Assert.isTrue(juggler.contains(tween));
	}
	
	
	public function testPurge():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		
		var tween1:Tween = new Tween(quad, 1.0);
		var tween2:Tween = new Tween(quad, 2.0);
		
		juggler.add(tween1);
		juggler.add(tween2);
		
		tween1.animate("x", 100);
		tween2.animate("y", 100);
		
		Assert.isTrue(tween1.hasEventListener(Event.REMOVE_FROM_JUGGLER));
		Assert.isTrue(tween2.hasEventListener(Event.REMOVE_FROM_JUGGLER));
		
		juggler.purge();
		
		Assert.isFalse(tween1.hasEventListener(Event.REMOVE_FROM_JUGGLER));
		Assert.isFalse(tween2.hasEventListener(Event.REMOVE_FROM_JUGGLER));
		
		juggler.advanceTime(10);
		
		Assert.equals(0, quad.x);
		Assert.equals(0, quad.y);
	}
	
	
	public function testPurgeFromAdvanceTime():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		
		var tween1:Tween = new Tween(quad, 1.0);
		var tween2:Tween = new Tween(quad, 1.0);
		var tween3:Tween = new Tween(quad, 1.0);
		
		juggler.add(tween1);
		juggler.add(tween2);
		juggler.add(tween3);
		
		tween2.onUpdate = juggler.purge;
		
		// if this doesn't crash, we're fine =)
		juggler.advanceTime(0.5);

		Assert.pass();
	}
	
	
	public function testRemoveTweensWithTarget():Void
	{
		var juggler:Juggler = new Juggler();
		
		var quad1:Quad = new Quad(100, 100);
		var quad2:Quad = new Quad(100, 100);
		
		var tween1:Tween = new Tween(quad1, 1.0);
		var tween2:Tween = new Tween(quad2, 1.0);
		
		tween1.animate("rotation", 1.0);
		tween2.animate("rotation", 1.0);
		
		juggler.add(tween1);
		juggler.add(tween2);
		
		juggler.removeTweens(quad1);
		juggler.advanceTime(1.0);
		
		Helpers.assertThat(quad1.rotation, closeTo(0.0, E));
		Helpers.assertThat(quad2.rotation, closeTo(1.0, E));   
	}
	
	
	public function testContainsTweens():Void
	{
		var juggler:Juggler = new Juggler();
		var quad1:Quad = new Quad(100, 100);
		var quad2:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad1, 1.0);
		
		juggler.add(tween);
		
		Assert.isTrue(juggler.containsTweens(quad1));
		Assert.isFalse(juggler.containsTweens(quad2));
	}
	
	
	public function testAddTwice():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		var tween:Tween = new Tween(quad, 1.0);
		
		juggler.add(tween);
		juggler.add(tween);
		
		Helpers.assertThat(tween.currentTime, closeTo(0.0, E));
		juggler.advanceTime(0.5);
		Helpers.assertThat(tween.currentTime, closeTo(0.5, E));
	}
	
	
	public function testModifyJugglerInCallback():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		
		var tween1:Tween = new Tween(quad, 1.0);
		tween1.animate("x", 100);
		
		var tween2:Tween = new Tween(quad, 0.5);
		tween2.animate("y", 100);
		
		var tween3:Tween = new Tween(quad, 0.5);
		tween3.animate("scaleX", 0.5);
		
		tween2.onComplete = function():Void {
			juggler.remove(tween1);
			juggler.add(tween3);
		};
		
		juggler.add(tween1);
		juggler.add(tween2);
		
		juggler.advanceTime(0.5);
		juggler.advanceTime(0.5);
		
		Helpers.assertThat(quad.x, closeTo(50.0, E));
		Helpers.assertThat(quad.y, closeTo(100.0, E));
		Helpers.assertThat(quad.scaleX, closeTo(0.5, E));
	}
	
	
	public function testModifyJugglerTwiceInCallback():Void
	{
		// https://github.com/PrimaryFeather/Starling-Framework/issues/155
		
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		
		var tween1:Tween = new Tween(quad, 1.0);
		var tween2:Tween = new Tween(quad, 1.0);
		tween2.fadeTo(0);
		
		juggler.add(tween1);
		juggler.add(tween2);
		
		juggler.remove(tween1); // sets slot in array to null
		tween2.onUpdate = juggler.remove;
		tween2.onUpdateArgs = [tween2];
		
		juggler.advanceTime(0.5);
		juggler.advanceTime(0.5);
		
		Helpers.assertThat(quad.alpha, closeTo(0.5, E));
	}
	
	
	public function testTweenConvenienceMethod():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);
		
		var completeCount:Int = 0;
		var startCount:Int = 0;
			
		function onComplete():Void { completeCount++; }
		function onStart():Void { startCount++; }
		
		juggler.tween(quad, 1.0, {
			x: 100,
			onStart: onStart,
			onComplete: onComplete
		});
			
		juggler.advanceTime(0.5);
		Assert.equals(1, startCount);
		Assert.equals(0, completeCount);
		Helpers.assertThat(quad.x, closeTo(50, E));
		
		juggler.advanceTime(0.5);
		Assert.equals(1, startCount);
		Assert.equals(1, completeCount);
		Helpers.assertThat(quad.x, closeTo(100, E));
	}
	
	
	public function testDelayedCallConvenienceMethod():Void
	{
		var juggler:Juggler = new Juggler();
		var counter:Int = 0;
		
		function raiseCounter(byValue:Int=1):Void
		{
			counter += byValue;
		}
		
		juggler.delayCall(raiseCounter, 1.0);
		juggler.delayCall(raiseCounter, 2.0, [2]);
		
		juggler.advanceTime(0.5);
		Assert.equals(0, counter);
		
		juggler.advanceTime(1.0);
		Assert.equals(1, counter);
		
		juggler.advanceTime(1.0);
		Assert.equals(3, counter);
		
		juggler.delayCall(raiseCounter, 1.0, [3]);
		
		juggler.advanceTime(1.0);
		Assert.equals(6, counter);
	}
	
	
	public function testRepeatCall():Void
	{
		var juggler:Juggler = new Juggler();
		var counter:Int = 0;
		
		function raiseCounter(byValue:Int=1):Void
		{
			counter += byValue;
		}
		
		juggler.repeatCall(raiseCounter, 0.25, 4, [1]);
		Assert.equals(0, counter);
		
		juggler.advanceTime(0.25);
		Assert.equals(1, counter);
		
		juggler.advanceTime(0.5);
		Assert.equals(3, counter);
		
		juggler.advanceTime(10);
		Assert.equals(4, counter);
	}
	
	
	public function testEndlessRepeatCall():Void
	{
		var juggler:Juggler = new Juggler();
		var counter:Int = 0;
		
		function raiseCounter():Void
		{
			counter += 1;
		}
		
		var id:UInt = juggler.repeatCall(raiseCounter, 1.0);
		Assert.equals(0, counter);
		
		juggler.advanceTime(50);
		Assert.equals(50, counter);
		
		juggler.removeByID(id);
		
		juggler.advanceTime(50);
		Assert.equals(50, counter);
	}

	
	public function testRemoveByID():Void
	{
		var juggler:Juggler = new Juggler();
		var counter:Int = 0;

		function raiseCounter():Void
		{
			counter += 1;
		}

		var id:UInt = juggler.delayCall(raiseCounter, 1.0);
		Assert.isTrue(id > 0);

		juggler.advanceTime(0.5);
		var outID:UInt = juggler.removeByID(id);
		juggler.advanceTime(1.0);

		Assert.equals(outID, id);
		Assert.equals(0, counter);

		var quad:Quad = new Quad(100, 100);

		id = juggler.tween(quad, 1.0, { x: 100 });
		Assert.isTrue(id > 0);

		juggler.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(50, E));

		outID = juggler.removeByID(id);
		Assert.isFalse(juggler.containsTweens(quad));
		Assert.equals(id, outID);

		juggler.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(50, E));

		id = juggler.removeByID(id);
		Assert.equals(0, id);
	}

	
	public function testRemoveNextTweenByID():Void
	{
		var juggler:Juggler = new Juggler();
		var quad:Quad = new Quad(100, 100);

		var tween:Tween = new Tween(quad, 1.0);
		tween.moveTo(1.0, 0.0);

		var tween2:Tween = new Tween(quad, 1.0);
		tween2.moveTo(1.0, 1.0);
		tween.nextTween = tween2;

		var id:UInt = juggler.add(tween);
		juggler.advanceTime(1.0);
		juggler.advanceTime(0.5);
		id = juggler.removeByID(id);
		Assert.isFalse(juggler.containsTweens(quad));
		Assert.isTrue(id != 0);

		id = juggler.removeByID(id);
		Assert.equals(0, id);

		juggler.advanceTime(0.5);
		Helpers.assertThat(quad.x, closeTo(1.0, E));
		Helpers.assertThat(quad.y, closeTo(0.5, E));
	}

	
	public function testRemoveDelayedCall():Void
	{
		var counter:Int = 0;

		function raiseCounter():Void
		{
			counter += 1;
		}

		var juggler:Juggler = new Juggler();

		juggler.repeatCall(raiseCounter, 1.0, 0);
		juggler.advanceTime(3.0);

		Assert.equals(3, counter);
		Assert.isTrue(juggler.containsDelayedCalls(raiseCounter));

		juggler.removeDelayedCalls(raiseCounter);
		juggler.advanceTime(10.0);

		Assert.isFalse(juggler.containsDelayedCalls(raiseCounter));
		Assert.equals(3, counter);
	}

	
	public function testElapsed():Void
	{
		var juggler:Juggler = new Juggler();
		Helpers.assertThat(juggler.elapsedTime, closeTo(0.0, E));
		juggler.advanceTime(0.25);
		juggler.advanceTime(0.5);
		Helpers.assertThat(juggler.elapsedTime, closeTo(0.75, E));
	}

	
	public function testTimeScale():Void
	{
		var juggler:Juggler = new Juggler();
		var sprite:Sprite = new Sprite();
		var tween:Tween = new Tween(sprite, 1.0);
		tween.animate("x", 100);

		juggler.add(tween);
		juggler.timeScale = 0.5;
		juggler.advanceTime(1.0);

		Helpers.assertThat(tween.currentTime, closeTo(0.5, E));
		Helpers.assertThat(sprite.x, closeTo(50, E));

		juggler.timeScale = 2.0;
		juggler.advanceTime(0.25);

		Helpers.assertThat(tween.currentTime, closeTo(1.0, E));
		Helpers.assertThat(sprite.x, closeTo(100, E));
	}
}
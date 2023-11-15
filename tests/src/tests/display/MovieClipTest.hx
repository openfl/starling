// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.display;

import openfl.Vector;
import org.hamcrest.Matchers.closeTo;
import starling.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;
import tests.utils.MockTexture;
import utest.Assert;
import utest.Test;

class MovieClipTest extends Test
{
	@:final private var E:Float = 0.0001;
	
	
	public function testFrameManipulation():Void
	{
		var fps:Float = 4.0;
		var frameDuration:Float = 1.0 / fps;

		var texture0:Texture = new MockTexture();
		var texture1:Texture = new MockTexture();
		var texture2:Texture = new MockTexture();
		var texture3:Texture = new MockTexture();
		
		var movie:MovieClip = new MovieClip(Vector.ofArray([texture0]), fps);

		Helpers.assertThat(movie.width, closeTo(texture0.width, E));
		Helpers.assertThat(movie.height, closeTo(texture0.height, E));
		Helpers.assertThat(movie.totalTime, closeTo(frameDuration, E));
		Assert.equals(1, movie.numFrames);
		Assert.equals(0, movie.currentFrame);

		movie.loop = true;
		Assert.isTrue(movie.loop);

		movie.play();
		Assert.isTrue(movie.isPlaying);
		
		movie.addFrame(texture1);
		Assert.equals(2, movie.numFrames);
		Assert.equals(texture0, movie.getFrameTexture(0));
		Assert.equals(texture1, movie.getFrameTexture(1));
		Assert.isNull(movie.getFrameSound(0));
		Assert.isNull(movie.getFrameSound(1));
		Helpers.assertThat(movie.getFrameDuration(0), closeTo(frameDuration, E));
		Helpers.assertThat(movie.getFrameDuration(1), closeTo(frameDuration, E));
		
		movie.addFrame(texture2, null, 0.5);
		Helpers.assertThat(movie.getFrameDuration(2), closeTo(0.5, E));
		Helpers.assertThat(movie.totalTime, closeTo(1.0, E));
		
		movie.addFrameAt(2, texture3); // -> 0, 1, 3, 2
		Assert.equals(4, movie.numFrames);
		Assert.equals(texture1, movie.getFrameTexture(1));
		Assert.equals(texture3, movie.getFrameTexture(2));
		Assert.equals(texture2, movie.getFrameTexture(3));
		Helpers.assertThat(movie.totalTime, closeTo(1.0 + frameDuration, E));
		
		movie.removeFrameAt(0); // -> 1, 3, 2
		Assert.equals(3, movie.numFrames);
		Assert.equals(texture1, movie.getFrameTexture(0));
		Helpers.assertThat(movie.totalTime, closeTo(1.0, E));
		
		movie.removeFrameAt(1); // -> 1, 2
		Assert.equals(2, movie.numFrames);
		Assert.equals(texture1, movie.getFrameTexture(0));
		Assert.equals(texture2, movie.getFrameTexture(1));
		Helpers.assertThat(movie.totalTime, closeTo(0.75, E));
		
		movie.setFrameTexture(1, texture3);
		Assert.equals(texture3, movie.getFrameTexture(1));
		
		movie.setFrameDuration(1, 0.75);
		Helpers.assertThat(movie.totalTime, closeTo(1.0, E));
		
		movie.addFrameAt(2, texture3);
		Assert.equals(texture3, movie.getFrameTexture(2));
	}
	
	
	public function testAdvanceTime():Void
	{
		var fps:Float = 4.0;
		var frameDuration:Float = 1.0 / fps;

		var texture0:Texture = new MockTexture();
		var texture1:Texture = new MockTexture();
		var texture2:Texture = new MockTexture();
		var texture3:Texture = new MockTexture();
		
		var movie:MovieClip = new MovieClip(Vector.ofArray([texture0]), fps);
		movie.addFrame(texture2, null, 0.5);
		movie.addFrame(texture3);
		movie.addFrameAt(0, texture1);
		movie.play();
		movie.loop = true;
		
		Assert.equals(0, movie.currentFrame);
		movie.advanceTime(frameDuration / 2.0);
		Assert.equals(0, movie.currentFrame);
		movie.advanceTime(frameDuration);
		Assert.equals(1, movie.currentFrame);
		movie.advanceTime(frameDuration);
		Assert.equals(2, movie.currentFrame);
		movie.advanceTime(frameDuration);
		Assert.equals(2, movie.currentFrame);
		movie.advanceTime(frameDuration);
		Assert.equals(3, movie.currentFrame);
		movie.advanceTime(frameDuration);
		Assert.equals(0, movie.currentFrame);
		Assert.isFalse(movie.isComplete);
		
		movie.loop = false;
		movie.advanceTime(movie.totalTime + frameDuration);
		Assert.equals(3, movie.currentFrame);
		Assert.isFalse(movie.isPlaying);
		Assert.isTrue(movie.isComplete);
		
		movie.currentFrame = 0;
		Assert.equals(0, movie.currentFrame);
		movie.advanceTime(frameDuration * 1.1);
		Assert.equals(1, movie.currentFrame);
		
		movie.stop();
		Assert.isFalse(movie.isPlaying);
		Assert.isFalse(movie.isComplete);
		Assert.equals(0, movie.currentFrame);
	}
		
	
	public function testChangeFps():Void
	{
		var frames:Vector<Texture> = createFrames(3);
		var movie:MovieClip = new MovieClip(frames, 4.0);
		
		Helpers.assertThat(movie.fps, closeTo(4.0, E));
		
		movie.fps = 3.0;
		Helpers.assertThat(movie.fps, closeTo(3.0, E));
		Helpers.assertThat(movie.getFrameDuration(0), closeTo(1.0 / 3.0, E));
		Helpers.assertThat(movie.getFrameDuration(1), closeTo(1.0 / 3.0, E));
		Helpers.assertThat(movie.getFrameDuration(2), closeTo(1.0 / 3.0, E));
		
		movie.setFrameDuration(1, 1.0);
		Helpers.assertThat(movie.getFrameDuration(1), closeTo(1.0, E));
		
		movie.fps = 6.0;
		Helpers.assertThat(movie.getFrameDuration(1), closeTo(0.5, E));
		Helpers.assertThat(movie.getFrameDuration(0), closeTo(1.0 / 6.0, E));
	}
	
	
	public function testCompletedEvent():Void
	{
		var fps:Float = 4.0;
		var frameDuration:Float = 1.0 / fps;
		var completedCount:Int = 0;
		
		function onMovieCompleted(event:Event):Void
		{
			completedCount++;
		}
		
		var frames:Vector<Texture> = createFrames(4);
		var movie:MovieClip = new MovieClip(frames, fps);
		movie.addEventListener(Event.COMPLETE, onMovieCompleted);
		movie.loop = false;
		movie.play();
		
		Assert.isFalse(movie.isComplete);
		movie.advanceTime(frameDuration);
		Assert.equals(1, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration);
		Assert.equals(2, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration);
		Assert.equals(3, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration * 0.5);
		movie.advanceTime(frameDuration * 0.5);
		Assert.equals(3, movie.currentFrame);
		Assert.equals(1, completedCount);
		Assert.isTrue(movie.isComplete);
		movie.advanceTime(movie.numFrames * 2 * frameDuration);
		Assert.equals(3, movie.currentFrame);
		Assert.equals(1, completedCount);
		Assert.isTrue(movie.isComplete);
		
		movie.loop = true;
		completedCount = 0;
		
		Assert.isFalse(movie.isComplete);
		movie.advanceTime(frameDuration);
		Assert.equals(1, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration);
		Assert.equals(2, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration);
		Assert.equals(3, movie.currentFrame);
		Assert.equals(0, completedCount);
		movie.advanceTime(frameDuration);
		Assert.equals(0, movie.currentFrame);
		Assert.equals(1, completedCount);
		movie.advanceTime(movie.numFrames * 2 * frameDuration);
		Assert.equals(3, completedCount);
	}
	
	
	public function testChangeCurrentFrameInCompletedEvent():Void
	{
		var fps:Float = 4.0;
		var frameDuration:Float = 1.0 / fps;
		var completedCount:Int = 0;
		
		var frames:Vector<Texture> = createFrames(4);
		var movie:MovieClip = new MovieClip(frames, fps);

		function onMovieCompleted(event:Event):Void
		{
			movie.pause();
			movie.currentFrame = 0;
		}

		movie.loop = true;
		movie.addEventListener(Event.COMPLETE, onMovieCompleted);
		movie.play();
		movie.advanceTime(1.75);
		
		Assert.isFalse(movie.isPlaying);
		Assert.equals(0, movie.currentFrame);
	}
	
	
	public function testRemoveAllFrames():Void
	{
		var frames:Vector<Texture> = createFrames(2);
		var movie:MovieClip = new MovieClip(frames);
		
		// it must not be allowed to remove the last frame 
		movie.removeFrameAt(0);
		var throwsError:Bool = false;
		
		try
		{
			movie.removeFrameAt(0);
		}
		catch (error:Dynamic)
		{
			throwsError = true;
		}
		
		Assert.isTrue(throwsError);
	}
	
	
	public function testLastTextureInFastPlayback():Void
	{
		var fps:Float = 20.0;
		var frames:Vector<Texture> = createFrames(3);
		var movie:MovieClip = new MovieClip(frames, fps);
		
		function onMovieCompleted():Void
		{
			Assert.equals(frames[2], movie.texture);
		}

		movie.addEventListener(Event.COMPLETE, onMovieCompleted);
		movie.play();
		movie.advanceTime(1.0);
	}
	
	
	public function testAssignedTextureWithCompleteHandler():Void
	{
		// https://github.com/PrimaryFeather/Starling-Framework/issues/232
		
		var frames:Vector<Texture> = createFrames(2);
		var movie:MovieClip = new MovieClip(frames, 2);
		movie.loop = true;
		movie.play();
		
		function onComplete():Void { /* does not have to do anything */ }
		
		movie.addEventListener(Event.COMPLETE, onComplete);
		Assert.equals(frames[0], movie.texture);
		
		movie.advanceTime(0.5);
		Assert.equals(frames[1], movie.texture);
		
		movie.advanceTime(0.5);
		Assert.equals(frames[0], movie.texture);
		
		movie.advanceTime(0.5);
		Assert.equals(frames[1], movie.texture);
	}
	
	
	public function testStopMovieInCompleteHandler():Void
	{
		var frames:Vector<Texture> = createFrames(5);
		var movie:MovieClip = new MovieClip(frames, 5);
		
		function onComplete():Void { movie.stop(); }

		movie.play();
		movie.addEventListener(Event.COMPLETE, onComplete);
		movie.advanceTime(1.3);
		
		Assert.isFalse(movie.isPlaying);
		Helpers.assertThat(movie.currentTime, closeTo(0.0, E));
		Assert.equals(frames[0], movie.texture);
		
		movie.play();
		movie.advanceTime(0.3);
		Helpers.assertThat(movie.currentTime, closeTo(0.3, E));
		Assert.equals(frames[1], movie.texture);
	}

	
	public function testReverseFrames():Void
	{
		var numFrames:Int = 4;
		var frames:Vector<Texture> = createFrames(numFrames);
		var movie:MovieClip = new MovieClip(frames, 5);
		movie.setFrameDuration(0, 0.4);
		movie.play();

		for (i in 0...numFrames)
			Assert.equals(movie.getFrameTexture(i), frames[i]);

		movie.advanceTime(0.5);
		movie.reverseFrames();

		for (i in 0...numFrames)
			Assert.equals(movie.getFrameTexture(i), frames[numFrames - i - 1]);

		Assert.equals(movie.currentFrame, 2);
		// TODO: how to translate this assert?
		// Helpers.assertThat(movie.currentTime, 0.5);
		Helpers.assertThat(movie.getFrameDuration(0), closeTo(0.2, E));
		Helpers.assertThat(movie.getFrameDuration(3), closeTo(0.4, E));
	}

	
	public function testSetCurrentTime():Void
	{
		var actionCount:Int = 0;

		function onAction():Void { ++actionCount; }

		var numFrames:Int = 4;
		var frames:Vector<Texture> = createFrames(numFrames);
		var movie:MovieClip = new MovieClip(frames, numFrames);
		movie.setFrameAction(1, onAction);
		movie.play();

		movie.currentTime = 0.1;
		Assert.equals(0, movie.currentFrame);
		Helpers.assertThat(movie.currentTime, closeTo(0.1, E));
		Assert.equals(0, actionCount);

		movie.currentTime = 0.25;
		Assert.equals(1, movie.currentFrame);
		Helpers.assertThat(movie.currentTime, closeTo(0.25, E));
		Assert.equals(0, actionCount);

		// 'advanceTime' should now get that action executed
		movie.advanceTime(0.01);
		Assert.equals(1, actionCount);
		movie.advanceTime(0.01);
		Assert.equals(1, actionCount);

		movie.currentTime = 0.3;
		Assert.equals(1, movie.currentFrame);
		Helpers.assertThat(movie.currentTime, closeTo(0.3, E));

		movie.currentTime = 1.0;
		Assert.equals(3, movie.currentFrame);
		Helpers.assertThat(movie.currentTime, closeTo(1.0, E));
	}

	
	public function testBasicFrameActions():Void
	{
		var actionCount:Int = 0;
		var completeCount:Int = 0;

		var numFrames:Int = 4;
		var frames:Vector<Texture> = createFrames(numFrames);
		var movie:MovieClip = new MovieClip(frames, numFrames);


		function onFrame(movieParam:MovieClip, frameID:Int):Void
		{
			actionCount++;
			Assert.equals(movie, movieParam);
			Assert.equals(frameID, movie.currentFrame);
			Helpers.assertThat(movie.currentTime, closeTo(frameID / numFrames, E));
		}

		function pauseMovie():Void
		{
			movie.pause();
		}

		function onComplete():Void
		{
			Helpers.assertThat(movie.currentTime, closeTo(movie.totalTime, E));
			completeCount++;
		}

		movie.setFrameAction(1, onFrame);
		movie.setFrameAction(3, onFrame);
		movie.loop = false;
		movie.play();

		// simple test of two actions
		movie.advanceTime(1.0);
		Assert.equals(2, actionCount);

		// now pause movie in action
		movie.loop = true;
		movie.setFrameAction(2, pauseMovie);
		movie.advanceTime(1.0);
		Assert.equals(3, actionCount);
		Helpers.assertThat(movie.currentTime, closeTo(0.5, E));
		Assert.isFalse(movie.isPlaying);

		// restarting the clip should execute the action at the current frame
		movie.advanceTime(1.0);
		Assert.isFalse(movie.isPlaying);
		Assert.equals(3, actionCount);

		// remove that action
		movie.play();
		movie.setFrameAction(2, null);
		movie.currentFrame = 0;
		movie.advanceTime(1.0);
		Assert.isTrue(movie.isPlaying);
		Assert.equals(5, actionCount);

		// add a COMPLETE event handler as well
		movie.addEventListener(Event.COMPLETE, onComplete);
		movie.advanceTime(1.0);
		Assert.equals(7, actionCount);
		Assert.equals(1, completeCount);

		// frame action should be executed before COMPLETE action, so we can pause the movie
		movie.setFrameAction(3, pauseMovie);
		movie.advanceTime(1.0);
		Assert.equals(8, actionCount);
		Assert.isFalse(movie.isPlaying);
		Assert.equals(1, completeCount);

		// adding a frame action while we're in the first frame and then moving on -> no action
		movie.currentFrame = 0;
		Assert.equals(0, movie.currentFrame);
		movie.setFrameAction(0, onFrame);
		movie.play();
		movie.advanceTime(0.1);
		Assert.equals(8, actionCount);
		movie.advanceTime(0.1);
		Assert.equals(8, actionCount);

		// but after stopping the clip, the action should be executed
		movie.stop();
		movie.play();
		movie.advanceTime(0.1);
		Assert.equals(9, actionCount);
		movie.advanceTime(0.1);
		Assert.equals(9, actionCount);
	}

	
	public function testFloatingPointIssue():Void
	{
		// -> https://github.com/Gamua/Starling-Framework/issues/851

		var completeCount:Int = 0;
		
		function onComplete():Void { completeCount++; }
		
		var numFrames:Int = 30;
		var frames:Vector<Texture> = createFrames(numFrames);
		var movie:MovieClip = new MovieClip(frames, numFrames);

		movie.loop = false;
		movie.addEventListener(Event.COMPLETE, onComplete);
		movie.currentTime = 0.9649999999999999;
		movie.advanceTime(0.03500000000000014);
		movie.advanceTime(0.1);

		Assert.equals(1, completeCount);
	}
	
	private function createFrames(count:Int):Vector<Texture>
	{
		var frames:Vector<Texture> = new Vector<Texture>();

		for (i in 0...count)
			frames.push(new MockTexture());
		
		return frames;
	}
}
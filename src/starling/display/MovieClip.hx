// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import haxe.Constraints.Function;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import openfl.Vector;

import starling.animation.IAnimatable;
import starling.events.Event;
import starling.textures.Texture;

/** Dispatched whenever the movie has displayed its last frame. */
@:meta(Event(name="complete", type="starling.events.Event"))

/** A MovieClip is a simple way to display an animation depicted by a list of textures.
 *  
 *  <p>Pass the frames of the movie in a vector of textures to the constructor. The movie clip 
 *  will have the width and height of the first frame. If you group your frames with the help 
 *  of a texture atlas (which is recommended), use the <code>getTextures</code>-method of the 
 *  atlas to receive the textures in the correct (alphabetic) order.</p> 
 *  
 *  <p>You can specify the desired framerate via the constructor. You can, however, manually 
 *  give each frame a custom duration. You can also play a sound whenever a certain frame 
 *  appears, or execute a callback (a "frame action").</p>
 *  
 *  <p>The methods <code>play</code> and <code>pause</code> control playback of the movie. You
 *  will receive an event of type <code>Event.COMPLETE</code> when the movie finished
 *  playback. If the movie is looping, the event is dispatched once per loop.</p>
 *  
 *  <p>As any animated object, a movie clip has to be added to a juggler (or have its 
 *  <code>advanceTime</code> method called regularly) to run. The movie will dispatch 
 *  an event of type "Event.COMPLETE" whenever it has displayed its last frame.</p>
 *  
 *  @see starling.textures.TextureAtlas
 */    
class MovieClip extends Image implements IAnimatable
{
    @:noCompletion private var __frames:Vector<MovieClipFrame>;
    @:noCompletion private var __defaultFrameDuration:Float;
    @:noCompletion private var __currentTime:Float;
    @:noCompletion private var __currentFrameID:Int;
    @:noCompletion private var __loop:Bool;
    @:noCompletion private var __playing:Bool;
    @:noCompletion private var __muted:Bool;
    @:noCompletion private var __wasStopped:Bool;
    @:noCompletion private var __soundTransform:SoundTransform = null;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (MovieClip.prototype, {
            "numFrames": { get: untyped __js__ ("function () { return this.get_numFrames (); }") },
            "totalTime": { get: untyped __js__ ("function () { return this.get_totalTime (); }") },
            "currentTime": { get: untyped __js__ ("function () { return this.get_currentTime (); }"), set: untyped __js__ ("function (v) { return this.set_currentTime (v); }") },
            "loop": { get: untyped __js__ ("function () { return this.get_loop (); }"), set: untyped __js__ ("function (v) { return this.set_loop (v); }") },
            "muted": { get: untyped __js__ ("function () { return this.get_muted (); }"), set: untyped __js__ ("function (v) { return this.set_muted (v); }") },
            "soundTransform": { get: untyped __js__ ("function () { return this.get_soundTransform (); }"), set: untyped __js__ ("function (v) { return this.set_soundTransform (v); }") },
            "currentFrame": { get: untyped __js__ ("function () { return this.get_currentFrame (); }"), set: untyped __js__ ("function (v) { return this.set_currentFrame (v); }") },
            "fps": { get: untyped __js__ ("function () { return this.get_fps (); }"), set: untyped __js__ ("function (v) { return this.set_fps (v); }") },
            "isPlaying": { get: untyped __js__ ("function () { return this.get_isPlaying (); }") },
            "isComplete": { get: untyped __js__ ("function () { return this.get_isComplete (); }") },
        });
        
    }
    #end
    
    /** Creates a movie clip from the provided textures and with the specified default framerate.
     * The movie will have the size of the first frame. */  
    public function new(textures:Vector<Texture>, fps:Float=12)
    {
        if (textures.length > 0)
        {
            super(textures[0]);
            init(textures, fps);
        }
        else
        {
            throw new ArgumentError("Empty texture array");
        }
    }
    
    private function init(textures:Vector<Texture>, fps:Float):Void
    {
        if (fps <= 0) throw new ArgumentError("Invalid fps: " + fps);
        var numFrames:Int = textures.length;
        
        __defaultFrameDuration = 1.0 / fps;
        __loop = true;
        __playing = true;
        __currentTime = 0.0;
        __currentFrameID = 0;
        __wasStopped = true;
        __frames = new Vector<MovieClipFrame>();
        
        for (i in 0...numFrames)
            __frames[i] = new MovieClipFrame(
                     textures[i], __defaultFrameDuration, __defaultFrameDuration * i);
    }
    
    // frame manipulation
    
    /** Adds an additional frame, optionally with a sound and a custom duration. If the 
     * duration is omitted, the default framerate is used (as specified in the constructor). */   
    public function addFrame(texture:Texture, sound:Sound=null, duration:Float=-1):Void
    {
        addFrameAt(numFrames, texture, sound, duration);
    }
    
    /** Adds a frame at a certain index, optionally with a sound and a custom duration. */
    public function addFrameAt(frameID:Int, texture:Texture, sound:Sound=null, 
                               duration:Float=-1):Void
    {
        if (frameID < 0 || frameID > numFrames) throw new ArgumentError("Invalid frame id");
        if (duration < 0) duration = __defaultFrameDuration;

        var frame:MovieClipFrame = new MovieClipFrame(texture, duration);
        frame.sound = sound;
        __frames.insertAt(frameID, frame);

        if (frameID == numFrames)
        {
            var prevStartTime:Float = frameID > 0 ? __frames[frameID - 1].startTime : 0.0;
            var prevDuration:Float  = frameID > 0 ? __frames[frameID - 1].duration  : 0.0;
            frame.startTime = prevStartTime + prevDuration;
        }
        else
            updateStartTimes();
    }
    
    /** Removes the frame at a certain ID. The successors will move down. */
    public function removeFrameAt(frameID:Int):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        if (numFrames == 1) throw new IllegalOperationError("Movie clip must not be empty");

        __frames.removeAt(frameID);

        if (frameID != numFrames)
            updateStartTimes();
    }
    
    /** Returns the texture of a certain frame. */
    public function getFrameTexture(frameID:Int):Texture
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return __frames[frameID].texture;
    }
    
    /** Sets the texture of a certain frame. */
    public function setFrameTexture(frameID:Int, texture:Texture):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        __frames[frameID].texture = texture;
    }
    
    /** Returns the sound of a certain frame. */
    public function getFrameSound(frameID:Int):Sound
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return __frames[frameID].sound;
    }
    
    /** Sets the sound of a certain frame. The sound will be played whenever the frame 
     * is displayed. */
    public function setFrameSound(frameID:Int, sound:Sound):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        __frames[frameID].sound = sound;
    }

    /** Returns the method that is executed at a certain frame. */
    public function getFrameAction(frameID:Int):Function
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return __frames[frameID].action;
    }

    /** Sets an action that will be executed whenever a certain frame is reached.
     *
     * @param frameID   The frame at which the action will be executed.
     * @param action    A callback with two optional parameters:
     *                  <code>function(movie:MovieClip, frameID:int):void;</code>
     */
    public function setFrameAction(frameID:Int, action:Function):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        __frames[frameID].action = action;
    }
    
    /** Returns the duration of a certain frame (in seconds). */
    public function getFrameDuration(frameID:Int):Float
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return __frames[frameID].duration;
    }
    
    /** Sets the duration of a certain frame (in seconds). */
    public function setFrameDuration(frameID:Int, duration:Float):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        __frames[frameID].duration = duration;
        updateStartTimes();
    }

    /** Reverses the order of all frames, making the clip run from end to start.
     * Makes sure that the currently visible frame stays the same. */
    public function reverseFrames():Void
    {
        __frames.reverse();
        __currentTime = totalTime - __currentTime;
        __currentFrameID = numFrames - __currentFrameID - 1;
        updateStartTimes();
    }
    
    // playback methods
    
    /** Starts playback. Beware that the clip has to be added to a juggler, too! */
    public function play():Void
    {
        __playing = true;
    }
    
    /** Pauses playback. */
    public function pause():Void
    {
        __playing = false;
    }
    
    /** Stops playback, resetting "currentFrame" to zero. */
    public function stop():Void
    {
        __playing = false;
        __wasStopped = true;
        currentFrame = 0;
    }

    // helpers
    
    private function updateStartTimes():Void
    {
        var numFrames:Int = this.numFrames;
        var prevFrame:MovieClipFrame = __frames[0];
        prevFrame.startTime = 0;
        
        for (i in 1...numFrames)
        {
            __frames[i].startTime = prevFrame.startTime + prevFrame.duration;
            prevFrame = __frames[i];
        }
    }

    // IAnimatable

    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void
    {
        if (!__playing) return;

        // The tricky part in this method is that whenever a callback is executed
        // (a frame action or a 'COMPLETE' event handler), that callback might modify the clip.
        // Thus, we have to start over with the remaining time whenever that happens.

        var frame:MovieClipFrame = __frames[__currentFrameID];

        if (__wasStopped)
        {
            // if the clip was stopped and started again,
            // sound and action of this frame need to be repeated.

            __wasStopped = false;
            frame.playSound(__soundTransform);

            if (frame.action != null)
            {
                frame.executeAction(this, __currentFrameID);
                advanceTime(passedTime);
                return;
            }
        }

        if (__currentTime == totalTime)
        {
            if (__loop)
            {
                __currentTime = 0.0;
                __currentFrameID = 0;
                frame = __frames[0];
                frame.playSound(__soundTransform);
                texture = frame.texture;

                if (frame.action != null)
                {
                    frame.executeAction(this, __currentFrameID);
                    advanceTime(passedTime);
                    return;
                }
            }
            else return;
        }

        var finalFrameID:Int = __frames.length - 1;
        var dispatchCompleteEvent:Bool = false;
        var frameAction:Function = null;
        var previousFrameID:Int = __currentFrameID;
        var restTimeInFrame:Float = 0;
        var changedFrame:Bool;

        while (__currentTime + passedTime >= frame.endTime)
        {
            changedFrame = false;
            restTimeInFrame = frame.duration - __currentTime + frame.startTime;
            passedTime -= restTimeInFrame;
            __currentTime = frame.startTime + frame.duration;

            if (__currentFrameID == finalFrameID)
            {
                if (hasEventListener(Event.COMPLETE))
                {
                    dispatchCompleteEvent = true;
                }
                else if (__loop)
                {
                    __currentTime = 0;
                    __currentFrameID = 0;
                    changedFrame = true;
                }
                else return;
            }
            else
            {
                __currentFrameID += 1;
                changedFrame = true;
            }

            frame = __frames[__currentFrameID];
            frameAction = frame.action;

            if (changedFrame)
                frame.playSound(__soundTransform);

            if (dispatchCompleteEvent)
            {
                texture = frame.texture;
                dispatchEventWith(Event.COMPLETE);
                advanceTime(passedTime);
                return;
            }
            else if (frameAction != null)
            {
                texture = frame.texture;
                frame.executeAction(this, __currentFrameID);
                advanceTime(passedTime);
                return;
            }
        }

        if (previousFrameID != __currentFrameID)
            texture = __frames[__currentFrameID].texture;

        __currentTime += passedTime;
    }
    
    // properties

    /** The total number of frames. */
    public var numFrames(get, never):Int;
    private function get_numFrames():Int { return __frames.length; }
    
    /** The total duration of the clip in seconds. */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float 
    {
        var lastFrame:MovieClipFrame = __frames[__frames.length-1];
        return lastFrame.startTime + lastFrame.duration;
    }
    
    /** The time that has passed since the clip was started (each loop starts at zero). */
    public var currentTime(get, set):Float;
    private function get_currentTime():Float { return __currentTime; }
    private function set_currentTime(value:Float):Float
    {
        if (value < 0 || value > totalTime) throw new ArgumentError("Invalid time: " + value);

        var lastFrameID:Int = __frames.length - 1;
        __currentTime = value;
        __currentFrameID = 0;

        while (__currentFrameID < lastFrameID && __frames[__currentFrameID + 1].startTime <= value)
            ++__currentFrameID;

        var frame:MovieClipFrame = __frames[__currentFrameID];
        texture = frame.texture;
        return value;
    }

    /** Indicates if the clip should loop. @default true */
    public var loop(get, set):Bool;
    private function get_loop():Bool { return __loop; }
    private function set_loop(value:Bool):Bool { return __loop = value; }
    
    /** If enabled, no new sounds will be started during playback. Sounds that are already
     * playing are not affected. */
    public var muted(get, set):Bool;
    private function get_muted():Bool { return __muted; }
    private function set_muted(value:Bool):Bool { return __muted = value; }

    /** The SoundTransform object used for playback of all frame sounds. @default null */
    public var soundTransform(get, set):SoundTransform;
    private function get_soundTransform():SoundTransform { return __soundTransform; }
    private function set_soundTransform(value:SoundTransform):SoundTransform { return __soundTransform = value; }

    /** The index of the frame that is currently displayed. */
    public var currentFrame(get, set):Int;
    private function get_currentFrame():Int { return __currentFrameID; }
    private function set_currentFrame(value:Int):Int
    {
        if (value < 0 || value >= numFrames) throw new ArgumentError("Invalid frame id");
        currentTime = __frames[value].startTime;
        return value;
    }
    
    /** The default number of frames per second. Individual frames can have different 
     * durations. If you change the fps, the durations of all frames will be scaled 
     * relatively to the previous value. */
    public var fps(get, set):Float;
    private function get_fps():Float { return 1.0 / __defaultFrameDuration; }
    private function set_fps(value:Float):Float
    {
        if (value <= 0) throw new ArgumentError("Invalid fps: " + value);
        
        var newFrameDuration:Float = 1.0 / value;
        var acceleration:Float = newFrameDuration / __defaultFrameDuration;
        __currentTime *= acceleration;
        __defaultFrameDuration = newFrameDuration;
        
        for (i in 0...numFrames) 
            __frames[i].duration *= acceleration;

        updateStartTimes();
        return value;
    }
    
    /** Indicates if the clip is still playing. Returns <code>false</code> when the end 
     * is reached. */
    public var isPlaying(get, never):Bool;
    private function get_isPlaying():Bool 
    {
        if (__playing)
            return __loop || __currentTime < totalTime;
        else
            return false;
    }

    /** Indicates if a (non-looping) movie has come to its end. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool
    {
        return !__loop && __currentTime >= totalTime;
    }
}


private class MovieClipFrame
{
    public function new(texture:Texture, duration:Float=0.1,  startTime:Float=0)
    {
        this.texture = texture;
        this.duration = duration;
        this.startTime = startTime;
    }

    public var texture:Texture;
    public var sound:Sound;
    public var duration:Float;
    public var startTime:Float;
    public var action:Function;

    public function playSound(transform:SoundTransform):Void
    {
        if (sound != null) sound.play(0, 0, transform);
    }

    public function executeAction(movie:MovieClip, frameID:Int):Void
    {
        if (action != null)
        {
            #if flash
            var numArgs:Int = untyped action.length;
            #elseif neko
            var numArgs:Int = untyped ($nargs)(action);
            #elseif cpp
            var numArgs:Int = untyped action.__ArgCount();
            #else
            var numArgs:Int = 2;
            #end

            if (numArgs == 0) action();
            else if (numArgs == 1) action(movie);
            else if (numArgs == 2) action(movie, frameID);
            else throw new Error("Frame actions support zero, one or two parameters: " +
                    "movie:MovieClip, frameID:int");
        }
    }
    
    public var endTime(get, never):Float;
    private function get_endTime():Float { return startTime + duration; }
}
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
//import away3d.utils.ArrayUtils;
import flash.errors.ArgumentError;
import flash.errors.IllegalOperationError;
import flash.media.Sound;
import flash.media.SoundTransform;
import haxe.Constraints.Function;
import openfl.errors.Error;
import starling.utils.ArrayUtil;

import starling.animation.IAnimatable;
import starling.events.Event;
import starling.textures.Texture;

import flash.media.Sound;
import flash.media.SoundTransform;

import starling.display.MovieClip;
import starling.textures.Texture;

/** Dispatched whenever the movie has displayed its last frame. */
//[Event(name="complete", type="starling.events.Event")]

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
    private var _frames:Array<MovieClipFrame>;
    private var _defaultFrameDuration:Float;
    private var _currentTime:Float;
    private var _currentFrameID:Int;
    private var _loop:Bool;
    private var _playing:Bool;
    private var _muted:Bool;
    private var _wasStopped:Bool;
    private var _soundTransform:SoundTransform;

    /** Creates a movie clip from the provided textures and with the specified default framerate.
     *  The movie will have the size of the first frame. */  
    public function new(textures:Array<Texture>, fps:Float=12)
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
    
    private function init(textures:Array<Texture>, fps:Float):Void
    {
        if (fps <= 0) throw new ArgumentError("Invalid fps: " + fps);
        var numFrames:Int = textures.length;
        
        _defaultFrameDuration = 1.0 / fps;
        _loop = true;
        _playing = true;
        _currentTime = 0.0;
        _currentFrameID = 0;
        _wasStopped = true;
        _frames = new Array<MovieClipFrame>();

        for (i in 0 ... numFrames)
            _frames[i] = new MovieClipFrame(
                    textures[i], _defaultFrameDuration, _defaultFrameDuration * i);
    }
    
    // frame manipulation
    
    /** Adds an additional frame, optionally with a sound and a custom duration. If the 
     *  duration is omitted, the default framerate is used (as specified in the constructor). */   
    public function addFrame(texture:Texture, sound:Sound=null, duration:Float=-1):Void
    {
        addFrameAt(numFrames, texture, sound, duration);
    }
    
    /** Adds a frame at a certain index, optionally with a sound and a custom duration. */
    public function addFrameAt(frameID:Int, texture:Texture, sound:Sound=null, 
                               duration:Float=-1):Void
    {
        if (frameID < 0 || frameID > numFrames) throw new ArgumentError("Invalid frame id");
        if (duration < 0) duration = _defaultFrameDuration;

        var frame:MovieClipFrame = new MovieClipFrame(texture, duration);
        frame.sound = sound;
        _frames.insert(frameID, frame);

        if (frameID == numFrames)
        {
            var prevStartTime:Float = frameID > 0 ? _frames[frameID - 1].startTime : 0.0;
            var prevDuration:Float  = frameID > 0 ? _frames[frameID - 1].duration  : 0.0;
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

        _frames.splice(frameID, 1);

        if (frameID != numFrames)
            updateStartTimes();
    }
    
    /** Returns the texture of a certain frame. */
    public function getFrameTexture(frameID:Int):Texture
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return _frames[frameID].texture;
    }
    
    /** Sets the texture of a certain frame. */
    public function setFrameTexture(frameID:Int, texture:Texture):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        _frames[frameID].texture = texture;
    }
    
    /** Returns the sound of a certain frame. */
    public function getFrameSound(frameID:Int):Sound
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return _frames[frameID].sound;
    }
    
    /** Sets the sound of a certain frame. The sound will be played whenever the frame 
     *  is displayed. */
    public function setFrameSound(frameID:Int, sound:Sound):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        _frames[frameID].sound = sound;
    }

    /** Returns the method that is executed at a certain frame. */
    public function getFrameAction(frameID:Int):Function
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return _frames[frameID].action;
    }

    /** Sets an action that will be executed whenever a certain frame is reached. */
    public function setFrameAction(frameID:Int, action:Function):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        _frames[frameID].action = action;
    }
    
    /** Returns the duration of a certain frame (in seconds). */
    public function getFrameDuration(frameID:Int):Float
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        return _frames[frameID].duration;
    }
    
    /** Sets the duration of a certain frame (in seconds). */
    public function setFrameDuration(frameID:Int, duration:Float):Void
    {
        if (frameID < 0 || frameID >= numFrames) throw new ArgumentError("Invalid frame id");
        _frames[frameID].duration = duration;
        updateStartTimes();
    }

    /** Reverses the order of all frames, making the clip run from end to start.
     *  Makes sure that the currently visible frame stays the same. */
    public function reverseFrames():Void
    {
        _frames.reverse();
        _currentTime = totalTime - _currentTime;
        _currentFrameID = numFrames - _currentFrameID - 1;
        updateStartTimes();
    }
    
    // playback methods
    
    /** Starts playback. Beware that the clip has to be added to a juggler, too! */
    public function play():Void
    {
        _playing = true;
    }
    
    /** Pauses playback. */
    public function pause():Void
    {
        _playing = false;
    }
    
    /** Stops playback, resetting "currentFrame" to zero. */
    public function stop():Void
    {
        _playing = false;
        _wasStopped = true;
        currentFrame = 0;
    }

    // helpers
    
    private function updateStartTimes():Void
    {
        var numFrames:Int = this.numFrames;
        var prevFrame:MovieClipFrame = _frames[0];
        prevFrame.startTime = 0;
        
        for (i in 1 ... numFrames)
        {
            _frames[i].startTime = prevFrame.startTime + prevFrame.duration;
            prevFrame = _frames[i];
        }
    }

    // IAnimatable

    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void
    {
        if (!_playing) return;

        // The tricky part in this method is that whenever a callback is executed
        // (a frame action or a 'COMPLETE' event handler), that callback might modify the clip.
        // Thus, we have to start over with the remaining time whenever that happens.

        var frame:MovieClipFrame = _frames[_currentFrameID];

        if (_wasStopped)
        {
            // if the clip was stopped and started again,
            // sound and action of this frame need to be repeated.

            _wasStopped = false;
            frame.playSound(_soundTransform);

            if (frame.action != null)
            {
                frame.executeAction(this, _currentFrameID);
                advanceTime(passedTime);
                return;
            }
        }

        if (_currentTime == totalTime)
        {
            if (_loop)
            {
                _currentTime = 0.0;
                _currentFrameID = 0;
                frame = _frames[0];
                frame.playSound(_soundTransform);
                texture = frame.texture;

                if (frame.action != null)
                {
                    frame.executeAction(this, _currentFrameID);
                    advanceTime(passedTime);
                    return;
                }
            }
            else return;
        }

        var finalFrameID:Int = _frames.length - 1;
        var restTimeInFrame:Float = frame.duration - _currentTime + frame.startTime;
        var dispatchCompleteEvent:Bool = false;
        var frameAction:Function = null;
        var previousFrameID:Int = _currentFrameID;
        var changedFrame:Bool;

        while (passedTime >= restTimeInFrame)
        {
            changedFrame = false;
            passedTime -= restTimeInFrame;
            _currentTime = frame.startTime + frame.duration;

            if (_currentFrameID == finalFrameID)
            {
                if (hasEventListener(Event.COMPLETE))
                {
                    dispatchCompleteEvent = true;
                }
                else if (_loop)
                {
                    _currentTime = 0;
                    _currentFrameID = 0;
                    changedFrame = true;
                }
                else return;
            }
            else
            {
                _currentFrameID += 1;
                changedFrame = true;
            }

            frame = _frames[_currentFrameID];
            frameAction = frame.action;

            if (changedFrame)
                frame.playSound(_soundTransform);

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
                frame.executeAction(this, _currentFrameID);
                advanceTime(passedTime);
                return;
            }

            restTimeInFrame = frame.duration;

            // prevent a mean floating point problem (issue #851)
            if (passedTime + 0.0001 > restTimeInFrame && passedTime - 0.0001 < restTimeInFrame)
                passedTime = restTimeInFrame;
        }

        if (previousFrameID != _currentFrameID)
            texture = _frames[_currentFrameID].texture;

        _currentTime += passedTime;
    }
    
    // properties

    /** The total number of frames. */
    public var numFrames(get, never):Int;
    @:noCompletion private function get_numFrames():Int { return _frames.length; }
    
    /** The total duration of the clip in seconds. */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float 
    {
        var lastFrame:MovieClipFrame = _frames[_frames.length-1];
        return lastFrame.startTime + lastFrame.duration;
    }
    
    /** The time that has passed since the clip was started (each loop starts at zero). */
    public var currentTime(get, set):Float;
    @:noCompletion private function get_currentTime():Float { return _currentTime; }
    @:noCompletion private function set_currentTime(value:Float):Float
    {
        if (value < 0 || value > totalTime) throw new ArgumentError("Invalid time: " + value);

        var lastFrameID:Int = _frames.length - 1;
        _currentTime = value;
        _currentFrameID = 0;

        while (_currentFrameID < lastFrameID && _frames[_currentFrameID + 1].startTime <= value)
            ++_currentFrameID;

        var frame:MovieClipFrame = _frames[_currentFrameID];
        texture = frame.texture;
        return value;
    }

    /** Indicates if the clip should loop. @default true */
    public var loop(get, set):Bool;
    @:noCompletion private function get_loop():Bool { return _loop; }
    @:noCompletion private function set_loop(value:Bool):Bool { return _loop = value; }
    
    /** If enabled, no new sounds will be started during playback. Sounds that are already
     *  playing are not affected. */
    public var muted(get, set):Bool;
    @:noCompletion private function get_muted():Bool { return _muted; }
    @:noCompletion private function set_muted(value:Bool):Bool { return _muted = value; }

    /** The SoundTransform object used for playback of all frame sounds. @default null */
    public var soundTransform(get, set):SoundTransform;
    @:noCompletion private function get_soundTransform():SoundTransform { return _soundTransform; }
    @:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform { return _soundTransform = value; }

    /** The index of the frame that is currently displayed. */
    public var currentFrame(get, set):Int;
    @:noCompletion private function get_currentFrame():Int { return _currentFrameID; }
    @:noCompletion private function set_currentFrame(value:Int):Int
    {
        if (value < 0 || value >= numFrames) throw new ArgumentError("Invalid frame id");
        currentTime = _frames[value].startTime;
        return value;
    }
    
    /** The default number of frames per second. Individual frames can have different 
     *  durations. If you change the fps, the durations of all frames will be scaled 
     *  relatively to the previous value. */
    public var fps(get, set):Float;
    @:noCompletion private function get_fps():Float { return 1.0 / _defaultFrameDuration; }
    @:noCompletion private function set_fps(value:Float):Float
    {
        if (value <= 0) throw new ArgumentError("Invalid fps: " + value);
        
        var newFrameDuration:Float = 1.0 / value;
        var acceleration:Float = newFrameDuration / _defaultFrameDuration;
        _currentTime *= acceleration;
        _defaultFrameDuration = newFrameDuration;
        
        for (i in 0 ... numFrames)
            _frames[i].duration *= acceleration;

        updateStartTimes();
        return value;
    }
    
    /** Indicates if the clip is still playing. Returns <code>false</code> when the end 
     *  is reached. */
    public var isPlaying(get, never):Bool;
    private function get_isPlaying():Bool 
    {
        if (_playing)
            return _loop || _currentTime < totalTime;
        else
            return false;
    }

    /** Indicates if a (non-looping) movie has come to its end. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool
    {
        return !_loop && _currentTime >= totalTime;
    }
}

class MovieClipFrame
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
            #if 0
            var numArgs:Int = action.length;
            
            if (numArgs == 0) action();
            else if (numArgs == 1) action(movie);
            else if (numArgs == 2) action(movie, frameID);
            else throw new Error("Frame actions support zero, one or two parameters: " +
                    "movie:MovieClip, frameID:int");
            #else
            Reflect.callMethod (null, action, [movie, frameID]);
            #end
        }
    }
}
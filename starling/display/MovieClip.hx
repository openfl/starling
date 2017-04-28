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

import flash.errors.ArgumentError;
import flash.errors.IllegalOperationError;
import flash.media.Sound;
import flash.media.SoundTransform;

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
 *  appears.</p>
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
    private var __textures:Vector<Texture>;
    private var mSounds:Vector<Sound>;
    private var mDurations:Vector<Float>;
    private var __startTimes:Vector<Float>;

    private var mDefaultFrameDuration:Float;
    private var __currentTime:Float;
    private var __currentFrame:Int;
    private var mLoop:Bool;
    private var mPlaying:Bool;
    private var mMuted:Bool;
    private var mWasStopped:Bool;
    private var mSoundTransform:SoundTransform = null;
    
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
        var nu__frames:Int = textures.length;
        
        mDefaultFrameDuration = 1.0 / fps;
        mLoop = true;
        mPlaying = true;
        __currentTime = 0.0;
        __currentFrame = 0;
        mWasStopped = true;
        __textures = textures.concat();
        mSounds = new Vector<Sound>(nu__frames);
        mDurations = new Vector<Float>(nu__frames);
        __startTimes = new Vector<Float>(nu__frames);
        
        for (i in 0...nu__frames)
        {
            mDurations[i] = mDefaultFrameDuration;
            __startTimes[i] = i * mDefaultFrameDuration;
        }
    }
    
    // frame manipulation
    
    /** Adds an additional frame, optionally with a sound and a custom duration. If the 
     * duration is omitted, the default framerate is used (as specified in the constructor). */   
    public function addFrame(texture:Texture, sound:Sound=null, duration:Float=-1):Void
    {
        addFrameAt(nu__frames, texture, sound, duration);
    }
    
    /** Adds a frame at a certain index, optionally with a sound and a custom duration. */
    public function addFrameAt(frameID:Int, texture:Texture, sound:Sound=null, 
                               duration:Float=-1):Void
    {
        if (frameID < 0 || frameID > nu__frames) throw new ArgumentError("Invalid frame id");
        if (duration < 0) duration = mDefaultFrameDuration;
        
        __textures.insertAt(frameID, texture);
        mSounds.insertAt(frameID, sound);
        mDurations.insertAt(frameID, duration);
        
        if (frameID > 0 && frameID == nu__frames) 
            __startTimes[frameID] = __startTimes[frameID-1] + mDurations[frameID-1];
        else
            updateStartTimes();
    }
    
    /** Removes the frame at a certain ID. The successors will move down. */
    public function removeFrameAt(frameID:Int):Void
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        if (nu__frames == 1) throw new IllegalOperationError("Movie clip must not be empty");
        
        __textures.splice(frameID, 1);
        mSounds.splice(frameID, 1);
        mDurations.splice(frameID, 1);
        
        updateStartTimes();
    }
    
    /** Returns the texture of a certain frame. */
    public function getFrameTexture(frameID:Int):Texture
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        return __textures[frameID];
    }
    
    /** Sets the texture of a certain frame. */
    public function setFrameTexture(frameID:Int, texture:Texture):Void
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        __textures[frameID] = texture;
    }
    
    /** Returns the sound of a certain frame. */
    public function getFrameSound(frameID:Int):Sound
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        return mSounds[frameID];
    }
    
    /** Sets the sound of a certain frame. The sound will be played whenever the frame 
     * is displayed. */
    public function setFrameSound(frameID:Int, sound:Sound):Void
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        mSounds[frameID] = sound;
    }
    
    /** Returns the duration of a certain frame (in seconds). */
    public function getFrameDuration(frameID:Int):Float
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        return mDurations[frameID];
    }
    
    /** Sets the duration of a certain frame (in seconds). */
    public function setFrameDuration(frameID:Int, duration:Float):Void
    {
        if (frameID < 0 || frameID >= nu__frames) throw new ArgumentError("Invalid frame id");
        mDurations[frameID] = duration;
        updateStartTimes();
    }

    /** Reverses the order of all frames, making the clip run from end to start.
     * Makes sure that the currently visible frame stays the same. */
    public function reverseFrames():Void
    {
        __textures.reverse();
        mSounds.reverse();
        mDurations.reverse();

        updateStartTimes();

        __currentTime = totalTime - __currentTime;
        __currentFrame = nu__frames - __currentFrame - 1;
    }
    
    // playback methods
    
    /** Starts playback. Beware that the clip has to be added to a juggler, too! */
    public function play():Void
    {
        mPlaying = true;
    }
    
    /** Pauses playback. */
    public function pause():Void
    {
        mPlaying = false;
    }
    
    /** Stops playback, resetting "currentFrame" to zero. */
    public function stop():Void
    {
        mPlaying = false;
        mWasStopped = true;
        currentFrame = 0;
    }

    // helpers
    
    private function updateStartTimes():Void
    {
        var nu__frames:Int = this.nu__frames;
        
        __startTimes.length = 0;
        __startTimes[0] = 0;
        
        for (i in 1...nu__frames)
            __startTimes[i] = __startTimes[i-1] + mDurations[i-1];
    }

    private function playSound(frame:Int):Void
    {
        if (!mMuted && mSounds[frame] != null)
            mSounds[frame].play(0, 0, mSoundTransform);
    }
    
    // IAnimatable
    
    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void
    {
        if (!mPlaying || passedTime <= 0.0) return;

        var finalFrame:Int;
        var previousFrame:Int = __currentFrame;
        var restTime:Float = 0.0;
        var dispatchCompleteEvent:Bool = false;
        var totalTime:Float = this.totalTime;

        if (mWasStopped)
        {
            // if the clip was stopped and started again,
            // we need to play the frame's sound manually.

            mWasStopped = false;
            playSound(__currentFrame);
        }

        if (mLoop && __currentTime >= totalTime)
        { 
            __currentTime = 0.0; 
            __currentFrame = 0; 
        }
        
        if (__currentTime < totalTime)
        {
            __currentTime += passedTime;
            finalFrame = __textures.length - 1;
            
            while (__currentTime > __startTimes[__currentFrame] + mDurations[__currentFrame])
            {
                if (__currentFrame == finalFrame)
                {
                    if (mLoop && !hasEventListener(Event.COMPLETE))
                    {
                        __currentTime -= totalTime;
                        __currentFrame = 0;
                    }
                    else
                    {
                        restTime = __currentTime - totalTime;
                        dispatchCompleteEvent = true;
                        __currentFrame = finalFrame;
                        __currentTime = totalTime;
                        break;
                    }
                }
                else
                {
                    __currentFrame++;
                }

                if (mSounds[__currentFrame] != null) playSound(__currentFrame);
            }
            
            // special case when we reach *exactly* the total time.
            if (__currentFrame == finalFrame && __currentTime == totalTime)
                dispatchCompleteEvent = true;
        }
        
        if (__currentFrame != previousFrame)
            texture = __textures[__currentFrame];
        
        if (dispatchCompleteEvent)
            dispatchEventWith(Event.COMPLETE);
        
        if (mLoop && restTime > 0.0)
            advanceTime(restTime);
    }
    
    // properties  
    
    /** The total duration of the clip in seconds. */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float 
    {
        var nu__frames:Int = __textures.length;
        return __startTimes[nu__frames-1] + mDurations[nu__frames-1];
    }
    
    /** The time that has passed since the clip was started (each loop starts at zero). */
    public var currentTime(get, never):Float;
    private function get_currentTime():Float { return __currentTime; }
    
    /** The total Float of frames. */
    public var nu__frames(get, never):Int;
    private function get_nu__frames():Int { return __textures.length; }
    
    /** Indicates if the clip should loop. */
    public var loop(get, set):Bool;
    private function get_loop():Bool { return mLoop; }
    private function set_loop(value:Bool):Bool { return mLoop = value; }
    
    /** If enabled, no new sounds will be started during playback. Sounds that are already
     * playing are not affected. */
    public var muted(get, set):Bool;
    private function get_muted():Bool { return mMuted; }
    private function set_muted(value:Bool):Bool { return mMuted = value; }

    /** The SoundTransform object used for playback of all frame sounds. @default null */
    public var soundTransform(get, set):SoundTransform;
    private function get_soundTransform():SoundTransform { return mSoundTransform; }
    private function set_soundTransform(value:SoundTransform):SoundTransform { return mSoundTransform = value; }

    /** The index of the frame that is currently displayed. */
    public var currentFrame(get, set):Int;
    private function get_currentFrame():Int { return __currentFrame; }
    private function set_currentFrame(value:Int):Int
    {
        __currentFrame = value;
        __currentTime = 0.0;
        
        for (i in 0...value)
            __currentTime += getFrameDuration(i);
        
        texture = __textures[__currentFrame];
        if (mPlaying && !mWasStopped) playSound(__currentFrame);
        return value;
    }
    
    /** The default number of frames per second. Individual frames can have different 
     * durations. If you change the fps, the durations of all frames will be scaled 
     * relatively to the previous value. */
    public var fps(get, set):Float;
    private function get_fps():Float { return 1.0 / mDefaultFrameDuration; }
    private function set_fps(value:Float):Float
    {
        if (value <= 0) throw new ArgumentError("Invalid fps: " + value);
        
        var newFrameDuration:Float = 1.0 / value;
        var acceleration:Float = newFrameDuration / mDefaultFrameDuration;
        __currentTime *= acceleration;
        mDefaultFrameDuration = newFrameDuration;
        
        for (i in 0...nu__frames) 
            mDurations[i] *= acceleration;

        updateStartTimes();
        return value;
    }
    
    /** Indicates if the clip is still playing. Returns <code>false</code> when the end 
     * is reached. */
    public var isPlaying(get, never):Bool;
    private function get_isPlaying():Bool 
    {
        if (mPlaying)
            return mLoop || __currentTime < totalTime;
        else
            return false;
    }

    /** Indicates if a (non-looping) movie has come to its end. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool
    {
        return !mLoop && __currentTime >= totalTime;
    }
}
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

@:jsRequire("starling/display/MovieClip", "default")

extern class MovieClip extends Image implements IAnimatable
{
    /** Creates a movie clip from the provided textures and with the specified default framerate.
     * The movie will have the size of the first frame. */  
    public function new(textures:Vector<Texture>, fps:Float=12);
    
    // frame manipulation
    
    /** Adds an additional frame, optionally with a sound and a custom duration. If the 
     * duration is omitted, the default framerate is used (as specified in the constructor). */   
    public function addFrame(texture:Texture, sound:Sound=null, duration:Float=-1):Void;
    
    /** Adds a frame at a certain index, optionally with a sound and a custom duration. */
    public function addFrameAt(frameID:Int, texture:Texture, sound:Sound=null, 
                               duration:Float=-1):Void;
    
    /** Removes the frame at a certain ID. The successors will move down. */
    public function removeFrameAt(frameID:Int):Void;
    
    /** Returns the texture of a certain frame. */
    public function getFrameTexture(frameID:Int):Texture;
    
    /** Sets the texture of a certain frame. */
    public function setFrameTexture(frameID:Int, texture:Texture):Void;
    
    /** Returns the sound of a certain frame. */
    public function getFrameSound(frameID:Int):Sound;
    
    /** Sets the sound of a certain frame. The sound will be played whenever the frame 
     * is displayed. */
    public function setFrameSound(frameID:Int, sound:Sound):Void;

    /** Returns the method that is executed at a certain frame. */
    public function getFrameAction(frameID:Int):Function;

    /** Sets an action that will be executed whenever a certain frame is reached.
     *
     * @param frameID   The frame at which the action will be executed.
     * @param action    A callback with two optional parameters:
     *                  <code>function(movie:MovieClip, frameID:int):void;</code>
     */
    public function setFrameAction(frameID:Int, action:Function):Void;
    
    /** Returns the duration of a certain frame (in seconds). */
    public function getFrameDuration(frameID:Int):Float;
    
    /** Sets the duration of a certain frame (in seconds). */
    public function setFrameDuration(frameID:Int, duration:Float):Void;

    /** Reverses the order of all frames, making the clip run from end to start.
     * Makes sure that the currently visible frame stays the same. */
    public function reverseFrames():Void;
    
    // playback methods
    
    /** Starts playback. Beware that the clip has to be added to a juggler, too! */
    public function play():Void;
    
    /** Pauses playback. */
    public function pause():Void;
    
    /** Stops playback, resetting "currentFrame" to zero. */
    public function stop():Void;

    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void;
    
    // properties

    /** The total number of frames. */
    public var numFrames(get, never):Int;
    private function get_numFrames():Int;
    
    /** The total duration of the clip in seconds. */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float;
    
    /** The time that has passed since the clip was started (each loop starts at zero). */
    public var currentTime(get, set):Float;
    private function get_currentTime():Float;
    private function set_currentTime(value:Float):Float;

    /** Indicates if the clip should loop. @default true */
    public var loop(get, set):Bool;
    private function get_loop():Bool;
    private function set_loop(value:Bool):Bool;
    
    /** If enabled, no new sounds will be started during playback. Sounds that are already
     * playing are not affected. */
    public var muted(get, set):Bool;
    private function get_muted():Bool;
    private function set_muted(value:Bool):Bool;

    /** The SoundTransform object used for playback of all frame sounds. @default null */
    public var soundTransform(get, set):SoundTransform;
    private function get_soundTransform():SoundTransform;
    private function set_soundTransform(value:SoundTransform):SoundTransform;

    /** The index of the frame that is currently displayed. */
    public var currentFrame(get, set):Int;
    private function get_currentFrame():Int;
    private function set_currentFrame(value:Int):Int;
    
    /** The default number of frames per second. Individual frames can have different 
     * durations. If you change the fps, the durations of all frames will be scaled 
     * relatively to the previous value. */
    public var fps(get, set):Float;
    private function get_fps():Float;
    private function set_fps(value:Float):Float;
    
    /** Indicates if the clip is still playing. Returns <code>false</code> when the end 
     * is reached. */
    public var isPlaying(get, never):Bool;
    private function get_isPlaying():Bool;

    /** Indicates if a (non-looping) movie has come to its end. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool;
}
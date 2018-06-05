import IAnimatable from "./../../starling/animation/IAnimatable";
import Image from "./../../starling/display/Image";
import ArgumentError from "openfl/errors/ArgumentError";
import Vector from "openfl/Vector";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import Texture from "./../textures/Texture";
import Sound from " openfl/media/Sound";
import SoundTransform from " openfl/media/SoundTransform";

declare namespace starling.display
{
	/** Dispatched whenever the movie has displayed its last frame. */
	// @:meta(Event(name="complete", type="starling.events.Event"))
	
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
	export class MovieClip extends Image implements IAnimatable
	{
		/** Creates a movie clip from the provided textures and with the specified default framerate.
		 * The movie will have the size of the first frame. */  
		public constructor(textures:Vector<Texture>, fps?:number);
		
		// frame manipulation
		
		/** Adds an additional frame, optionally with a sound and a custom duration. If the 
		 * duration is omitted, the default framerate is used (as specified in the constructor). */   
		public addFrame(texture:Texture, sound?:Sound, duration?:number):void;
		
		/** Adds a frame at a certain index, optionally with a sound and a custom duration. */
		public addFrameAt(frameID:number, texture:Texture, sound?:Sound, 
								   duration?:number):void;
		
		/** Removes the frame at a certain ID. The successors will move down. */
		public removeFrameAt(frameID:number):void;
		
		/** Returns the texture of a certain frame. */
		public getFrameTexture(frameID:number):Texture;
		
		/** Sets the texture of a certain frame. */
		public setFrameTexture(frameID:number, texture:Texture):void;
		
		/** Returns the sound of a certain frame. */
		public getFrameSound(frameID:number):Sound;
		
		/** Sets the sound of a certain frame. The sound will be played whenever the frame 
		 * is displayed. */
		public setFrameSound(frameID:number, sound:Sound):void;
	
		/** Returns the method that is executed at a certain frame. */
		public getFrameAction(frameID:number):Function;
	
		/** Sets an action that will be executed whenever a certain frame is reached.
		 *
		 * @param frameID   The frame at which the action will be executed.
		 * @param action    A callback with two optional parameters:
		 *                  <code>function(movie:MovieClip, frameID:number):void;</code>
		 */
		public setFrameAction(frameID:number, action:Function):void;
		
		/** Returns the duration of a certain frame (in seconds). */
		public getFrameDuration(frameID:number):number;
		
		/** Sets the duration of a certain frame (in seconds). */
		public setFrameDuration(frameID:number, duration:number):void;
	
		/** Reverses the order of all frames, making the clip run from end to start.
		 * Makes sure that the currently visible frame stays the same. */
		public reverseFrames():void;
		
		// playback methods
		
		/** Starts playback. Beware that the clip has to be added to a juggler, too! */
		public play():void;
		
		/** Pauses playback. */
		public pause():void;
		
		/** Stops playback, resetting "currentFrame" to zero. */
		public stop():void;
	
		/** @inheritDoc */
		public advanceTime(passedTime:number):void;
		
		// properties
	
		/** The total number of frames. */
		public readonly numFrames:number;
		protected get_numFrames():number;
		
		/** The total duration of the clip in seconds. */
		public readonly totalTime:number;
		protected get_totalTime():number;
		
		/** The time that has passed since the clip was started (each loop starts at zero). */
		public currentTime:number;
		protected get_currentTime():number;
		protected set_currentTime(value:number):number;
	
		/** Indicates if the clip should loop. @default true */
		public loop:boolean;
		protected get_loop():boolean;
		protected set_loop(value:boolean):boolean;
		
		/** If enabled, no new sounds will be started during playback. Sounds that are already
		 * playing are not affected. */
		public muted:boolean;
		protected get_muted():boolean;
		protected set_muted(value:boolean):boolean;
	
		/** The SoundTransform object used for playback of all frame sounds. @default null */
		public soundTransform:SoundTransform;
		protected get_soundTransform():SoundTransform;
		protected set_soundTransform(value:SoundTransform):SoundTransform;
	
		/** The index of the frame that is currently displayed. */
		public currentFrame:number;
		protected get_currentFrame():number;
		protected set_currentFrame(value:number):number;
		
		/** The default number of frames per second. Individual frames can have different 
		 * durations. If you change the fps, the durations of all frames will be scaled 
		 * relatively to the previous value. */
		public fps:number;
		protected get_fps():number;
		protected set_fps(value:number):number;
		
		/** Indicates if the clip is still playing. Returns <code>false</code> when the end 
		 * is reached. */
		public readonly isPlaying:boolean;
		protected get_isPlaying():boolean;
	
		/** Indicates if a (non-looping) movie has come to its end. */
		public readonly isComplete:boolean;
		protected get_isComplete():boolean;
	}
}

export default starling.display.MovieClip;
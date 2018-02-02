package starling.display;

import starling.animation.IAnimatable;
import starling.display.Image;

@:jsRequire("starling/display/MovieClip", "default")

@:meta(Event(name = "complete", type = "starling.events.Event")) extern class MovieClip extends Image implements starling.animation.IAnimatable {
	var currentFrame(get,set) : Int;
	var currentTime(get,set) : Float;
	var fps(get,set) : Float;
	var isComplete(get,never) : Bool;
	var isPlaying(get,never) : Bool;
	var loop(get,set) : Bool;
	var muted(get,set) : Bool;
	var numFrames(get,never) : Int;
	var soundTransform(get,set) : openfl.media.SoundTransform;
	var totalTime(get,never) : Float;
	function new(textures : openfl.Vector<starling.textures.Texture>, fps : Float = 0) : Void;
	function addFrame(texture : starling.textures.Texture, ?sound : openfl.media.Sound, duration : Float = 0) : Void;
	function addFrameAt(frameID : Int, texture : starling.textures.Texture, ?sound : openfl.media.Sound, duration : Float = 0) : Void;
	function advanceTime(passedTime : Float) : Void;
	function getFrameAction(frameID : Int) : haxe.Constraints.Function;
	function getFrameDuration(frameID : Int) : Float;
	function getFrameSound(frameID : Int) : openfl.media.Sound;
	function getFrameTexture(frameID : Int) : starling.textures.Texture;
	function pause() : Void;
	function play() : Void;
	function removeFrameAt(frameID : Int) : Void;
	function reverseFrames() : Void;
	function setFrameAction(frameID : Int, action : haxe.Constraints.Function) : Void;
	function setFrameDuration(frameID : Int, duration : Float) : Void;
	function setFrameSound(frameID : Int, sound : openfl.media.Sound) : Void;
	function setFrameTexture(frameID : Int, texture : starling.textures.Texture) : Void;
	function stop() : Void;
}

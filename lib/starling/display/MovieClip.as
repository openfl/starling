package starling.display {
	
	import openfl.media.Sound;
	import openfl.media.SoundTransform;
	// import openfl.Vector;
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.textures.Texture;
	
	// @:meta(Event(name = "complete", type = "starling.events.Event"))
	
	/**
	 * @externs
	 */
	public class MovieClip extends Image implements starling.animation.IAnimatable {
		public var currentFrame:int;
		public var currentTime:Number;
		public var fps:Number;
		public function get isComplete():Boolean { return false; }
		public function get isPlaying():Boolean { return false; }
		public var loop:Boolean;
		public var muted:Boolean;
		public function get numFrames():int { return 0; }
		public var soundTransform:openfl.media.SoundTransform;
		public function get totalTime():Number { return 0; }
		public function MovieClip(textures:Vector.<starling.textures.Texture>, fps:Number = 0):void { super (null); }
		public function addFrame(texture:starling.textures.Texture, sound:openfl.media.Sound = null, duration:Number = 0):void {}
		public function addFrameAt(frameID:int, texture:starling.textures.Texture, sound:openfl.media.Sound = null, duration:Number = 0):void {}
		public function advanceTime(passedTime:Number):void {}
		public function getFrameAction(frameID:int):Function { return null; }
		public function getFrameDuration(frameID:int):Number { return 0; }
		public function getFrameSound(frameID:int):openfl.media.Sound { return null; }
		public function getFrameTexture(frameID:int):starling.textures.Texture { return null; }
		public function pause():void {}
		public function play():void {}
		public function removeFrameAt(frameID:int):void {}
		public function reverseFrames():void {}
		public function setFrameAction(frameID:int, action:Function):void {}
		public function setFrameDuration(frameID:int, duration:Number):void {}
		public function setFrameSound(frameID:int, sound:openfl.media.Sound):void {}
		public function setFrameTexture(frameID:int, texture:starling.textures.Texture):void {}
		public function stop():void {}
	}
	
}
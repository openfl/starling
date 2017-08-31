package;


import openfl.ui.Keyboard;
import openfl.Assets;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.PDParticleSystem;
import starling.extensions.ParticleSystem;
import starling.textures.Texture;


class Demo extends Sprite
{
	// member variables
	
	private var _particleSystems:Array<ParticleSystem>;
	private var _particleSystem:ParticleSystem;
	
	public function new()
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init():Void
	{
		stage.color = 0xff000000;
		
		var drugsConfig = Assets.getText("assets/drugs.pex");
		var drugsTexture = Texture.fromBitmapData(Assets.getBitmapData("assets/drugs_particle.png"));
		
		var fireConfig = Assets.getText("assets/fire.pex");
		var fireTexture = Texture.fromBitmapData(Assets.getBitmapData("assets/fire_particle.png"));
		
		var sunConfig = Assets.getText("assets/sun.pex");
		var sunTexture = Texture.fromBitmapData(Assets.getBitmapData ("assets/sun_particle.png"));
		
		var jellyConfig = Assets.getText("assets/jellyfish.pex");
		var jellyTexture = Texture.fromBitmapData(Assets.getBitmapData("assets/jellyfish_particle.png"));
		
		_particleSystems = [
			new PDParticleSystem (drugsConfig, drugsTexture),
			new PDParticleSystem (fireConfig, fireTexture),
			new PDParticleSystem (sunConfig, sunTexture),
			new PDParticleSystem (jellyConfig, jellyTexture)
		];
		
		// add event handlers for touch and keyboard
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		stage.addEventListener(TouchEvent.TOUCH, onTouch);
		
		startNextParticleSystem();
	}
	
	private function startNextParticleSystem():Void
	{
		if (_particleSystem != null)
		{
			_particleSystem.stop();
			_particleSystem.removeFromParent();
			Starling.current.juggler.remove(_particleSystem);
		}
		
		_particleSystem = _particleSystems.shift();
		_particleSystems.push(_particleSystem);

		_particleSystem.emitterX = 320;
		_particleSystem.emitterY = 240;
		_particleSystem.start();
		
		addChild(_particleSystem);
		Starling.current.juggler.add(_particleSystem);
	}
	
	private function onKey(event:Event, keyCode:Int):Void
	{
		if (keyCode == Keyboard.SPACE)
			startNextParticleSystem();
	}
	
	private function onTouch(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(stage);
		if (touch != null && touch.phase != TouchPhase.HOVER)
		{
			_particleSystem.emitterX = touch.globalX;
			_particleSystem.emitterY = touch.globalY;
		}
	}
}
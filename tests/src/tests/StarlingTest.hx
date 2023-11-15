// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests;

import utest.Test;
import utest.Async;
import starling.core.Starling;
import starling.display.Sprite;

class StarlingTest extends Test {
	
	private var _starling:Starling;
	private var _flashEventAdapter:openfl.events.EventDispatcher;
	private var _eventListenerTargets:Array<starling.events.EventDispatcher>;

	@:timeout(7500)
	public function setup(async:Async):Void
	{
		_eventListenerTargets = [];
		_flashEventAdapter = new openfl.events.EventDispatcher();
		_starling = new Starling(TestGame, openfl.Lib.current.stage);
		_starling.addEventListener(starling.events.Event.ROOT_CREATED, function(event:starling.events.Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			async.done();
		});
		_starling.start();
	}

	public function teardown():Void
	{
		removeEventListeners();
		_starling.dispose();
		_starling = null;
	}
        
	private function removeEventListeners():Void
	{
		for (i in 0..._eventListenerTargets.length) {
			_eventListenerTargets[i].removeEventListeners();
		}
		_eventListenerTargets = null;
	}
}

class TestGame extends Sprite {}
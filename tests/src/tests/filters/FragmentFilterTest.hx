// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.filters;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.FragmentFilter;
import tests.StarlingTest;
import utest.Assert;

class FragmentFilterTest extends StarlingTest
{
	
	public function testEnterFrameEvent():Void
	{
		var eventCount:Int = 0;

		function onEvent(event:EnterFrameEvent):Void
		{
			++eventCount;
		}

		var event:EnterFrameEvent = new EnterFrameEvent(Event.ENTER_FRAME, 0.1);
		var filter:FragmentFilter = new FragmentFilter();
		var sprite:Sprite = new Sprite();
		var sprite2:Sprite = new Sprite();

		filter.addEventListener(Event.ENTER_FRAME, onEvent);
		sprite.dispatchEvent(event);
		Assert.equals(0, eventCount);

		sprite.filter = filter;
		sprite.dispatchEvent(event);
		Assert.equals(1, eventCount);

		sprite.dispatchEvent(event);
		Assert.equals(2, eventCount);

		sprite2.filter = filter;
		sprite.dispatchEvent(event);
		Assert.equals(2, eventCount);

		sprite.filter = filter;
		sprite.dispatchEvent(event);
		Assert.equals(3, eventCount);

		filter.removeEventListener(Event.ENTER_FRAME, onEvent);
		sprite.dispatchEvent(event);
		Assert.equals(3, eventCount);
	}
}
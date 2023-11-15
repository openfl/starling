// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.events;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.EventDispatcher;
import utest.Assert;
import utest.Test;

class EventTest extends Test {
	public function testBubbling():Void
	{
		var eventType:String = "test";
		
		var grandParent:Sprite = new Sprite();
		var parent:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		
		grandParent.addChild(parent);
		parent.addChild(child);
		
		var grandParentEventHandlerHit:Bool = false;
		var parentEventHandlerHit:Bool = false;
		var childEventHandlerHit:Bool = false;
		var hitCount:Int = 0;            
		
		function onGrandParentEvent(event:Event):Void
		{
			grandParentEventHandlerHit = true;                
			Assert.equals(child, event.target);
			Assert.equals(grandParent, event.currentTarget);
			hitCount++;
		}
		
		function onParentEvent(event:Event):Void
		{
			parentEventHandlerHit = true;                
			Assert.equals(child, event.target);
			Assert.equals(parent, event.currentTarget);
			hitCount++;
		}
		
		function onChildEvent(event:Event):Void
		{
			childEventHandlerHit = true;                               
			Assert.equals(child, event.target);
			Assert.equals(child, event.currentTarget);
			hitCount++;
		}
		
		// bubble up
		
		grandParent.addEventListener(eventType, onGrandParentEvent);
		parent.addEventListener(eventType, onParentEvent);
		child.addEventListener(eventType, onChildEvent);
		
		var event:Event = new Event(eventType, true);
		child.dispatchEvent(event);
		
		Assert.isTrue(grandParentEventHandlerHit);
		Assert.isTrue(parentEventHandlerHit);
		Assert.isTrue(childEventHandlerHit);
		
		Assert.equals(3, hitCount);
		
		// remove event handler
		
		parentEventHandlerHit = false;
		parent.removeEventListener(eventType, onParentEvent);
		child.dispatchEvent(event);
		
		Assert.isFalse(parentEventHandlerHit);
		Assert.equals(5, hitCount);
		
		// don't bubble
		
		event = new Event(eventType);
		
		grandParentEventHandlerHit = parentEventHandlerHit = childEventHandlerHit = false;
		parent.addEventListener(eventType, onParentEvent);
		child.dispatchEvent(event);
		
		Assert.equals(6, hitCount);
		Assert.isTrue(childEventHandlerHit);
		Assert.isFalse(parentEventHandlerHit);
		Assert.isFalse(grandParentEventHandlerHit);
	}
	
	
	public function testStopPropagation():Void
	{
		var eventType:String = "test";
		
		var grandParent:Sprite = new Sprite();
		var parent:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		
		grandParent.addChild(parent);
		parent.addChild(child);
		
		var hitCount:Int = 0;
		
		function onEvent(event:Event):Void
		{
			hitCount++;
		}
		
		function onEvent_StopPropagation(event:Event):Void
		{
			event.stopPropagation();
			hitCount++;
		}
		
		function onEvent_StopImmediatePropagation(event:Event):Void
		{
			event.stopImmediatePropagation();
			hitCount++;
		}
		
		// stop propagation at parent
		
		child.addEventListener(eventType, onEvent);
		parent.addEventListener(eventType, onEvent_StopPropagation);
		parent.addEventListener(eventType, onEvent);
		grandParent.addEventListener(eventType, onEvent);
		
		child.dispatchEvent(new Event(eventType, true));
		
		Assert.equals(3, hitCount);
		
		// stop immediate propagation at parent
		
		parent.removeEventListener(eventType, onEvent_StopPropagation);
		parent.removeEventListener(eventType, onEvent);
		
		parent.addEventListener(eventType, onEvent_StopImmediatePropagation);
		parent.addEventListener(eventType, onEvent);
		
		child.dispatchEvent(new Event(eventType, true));
		
		Assert.equals(5, hitCount);
	}
	
	
	public function testRemoveEventListeners():Void
	{
		var hitCount:Int = 0;
		var dispatcher:EventDispatcher = new EventDispatcher();
		
		function onEvent(event:Event):Void
		{
			++hitCount;
		}
		
		dispatcher.addEventListener("Type1", onEvent);
		dispatcher.addEventListener("Type2", onEvent);
		dispatcher.addEventListener("Type3", onEvent);
		
		hitCount = 0;
		dispatcher.dispatchEvent(new Event("Type1"));
		Assert.equals(1, hitCount);
		
		dispatcher.dispatchEvent(new Event("Type2"));
		Assert.equals(2, hitCount);
		
		dispatcher.dispatchEvent(new Event("Type3"));
		Assert.equals(3, hitCount);
		
		hitCount = 0;
		dispatcher.removeEventListener("Type1", onEvent);
		dispatcher.dispatchEvent(new Event("Type1"));
		Assert.equals(0, hitCount);
		
		dispatcher.dispatchEvent(new Event("Type3"));
		Assert.equals(1, hitCount);
		
		hitCount = 0;
		dispatcher.removeEventListeners();
		dispatcher.dispatchEvent(new Event("Type1"));
		dispatcher.dispatchEvent(new Event("Type2"));
		dispatcher.dispatchEvent(new Event("Type3"));
		Assert.equals(0, hitCount);
	}
	
	
	public function testBlankEventDispatcher():Void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		
		Helpers.assertDoesNotThrow(function():Void
		{
			dispatcher.removeEventListener("Test", null);
		});
		
		Helpers.assertDoesNotThrow(function():Void
		{
			dispatcher.removeEventListeners("Test");
		});
	}
	
	
	public function testDuplicateEventHandler():Void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		var callCount:Int = 0;
		
		function onEvent(event:Event):Void
		{
			callCount++;
		}
		
		dispatcher.addEventListener("test", onEvent);
		dispatcher.addEventListener("test", onEvent);
		
		dispatcher.dispatchEvent(new Event("test"));
		Assert.equals(1, callCount);
	}
	
	
	public function testBubbleWithModifiedChain():Void
	{
		var eventType:String = "test";
		
		var grandParent:Sprite = new Sprite();
		var parent:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		
		grandParent.addChild(parent);
		parent.addChild(child);
		
		var hitCount:Int = 0;
		
		function onEvent():Void
		{
			hitCount++;
		}
		
		function onEvent_removeFromParent():Void
		{
			parent.removeFromParent();
		}
		
		// listener on 'child' changes display list; bubbling must not be affected.
		
		grandParent.addEventListener(eventType, onEvent);
		parent.addEventListener(eventType, onEvent);
		child.addEventListener(eventType, onEvent);
		child.addEventListener(eventType, onEvent_removeFromParent);
		
		child.dispatchEvent(new Event(eventType, true));
		
		Assert.isNull(parent.parent);
		Assert.equals(3, hitCount);
	}
	
	
	public function testRedispatch():Void
	{
		var eventType:String = "test";
		
		var grandParent:Sprite = new Sprite();
		var parent:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		
		grandParent.addChild(parent);
		parent.addChild(child);
		
		var targets:Array<Dynamic> = [];
		var currentTargets:Array<Dynamic> = [];
		
		function onEvent(event:Event):Void
		{
			targets.push(event.target);
			currentTargets.push(event.currentTarget);
		}
		
		function onEvent_redispatch(event:Event):Void
		{
			parent.removeEventListener(eventType, onEvent_redispatch);
			parent.dispatchEvent(event);
		}
		
		grandParent.addEventListener(eventType, onEvent);
		parent.addEventListener(eventType, onEvent);
		child.addEventListener(eventType, onEvent);
		parent.addEventListener(eventType, onEvent_redispatch);
		
		child.dispatchEventWith(eventType, true);
		
		// main bubble
		Assert.equals(targets[0], child);
		Assert.equals(currentTargets[0], child);
		
		// main bubble
		Assert.equals(targets[1], child);
		Assert.equals(currentTargets[1], parent);
		
		// inner bubble
		Assert.equals(targets[2], parent);
		Assert.equals(currentTargets[2], parent);
		
		// inner bubble
		Assert.equals(targets[3], parent);
		Assert.equals(currentTargets[3], grandParent);
		
		// main bubble
		Assert.equals(targets[4], child);
		Assert.equals(currentTargets[4], grandParent);
	}
	
	public function testHasEventListener():Void
	{
		var eventType:String = "event";
		var dispatcher:EventDispatcher = new EventDispatcher();

		function onEvent():Void {}
		function onSomethingElse():Void {}

		Assert.isFalse(dispatcher.hasEventListener(eventType));
		Assert.isFalse(dispatcher.hasEventListener(eventType, onEvent));

		dispatcher.addEventListener(eventType, onEvent);

		Assert.isTrue(dispatcher.hasEventListener(eventType));
		Assert.isTrue(dispatcher.hasEventListener(eventType, onEvent));
		Assert.isFalse(dispatcher.hasEventListener(eventType, onSomethingElse));

		dispatcher.removeEventListener(eventType, onEvent);

		Assert.isFalse(dispatcher.hasEventListener(eventType));
		Assert.isFalse(dispatcher.hasEventListener(eventType, onEvent));
	}
}
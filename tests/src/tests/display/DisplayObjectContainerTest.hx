// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.display;

import openfl.errors.ArgumentError;
import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import utest.Assert;
import utest.Test;

class DisplayObjectContainerTest extends Test
{
	@:final private static var E:Float = 0.0001;
	
	private var _added:Int;
	private var _addedToStage:Int;
	private var _addedChild:Int;
	private var _removed:Int;
	private var _removedFromStage:Int;
	private var _removedChild:Int;
	
	public function setup():Void 
	{
		_added = _addedToStage = _addedChild =
		_removed = _removedFromStage = _removedChild = 0;
	}
	
	public function teardown():Void { }
	
	
	public function testChildParentHandling():Void
	{
		var parent:Sprite = new Sprite();
		var child1:Sprite = new Sprite();
		var child2:Sprite = new Sprite();
		var returnValue:DisplayObject;
		
		Assert.equals(0, parent.numChildren);
		Assert.isNull(child1.parent);
		
		returnValue = parent.addChild(child1);
		Assert.equals(child1, returnValue);
		Assert.equals(1, parent.numChildren);
		Assert.equals(parent, child1.parent);
		
		returnValue = parent.addChild(child2);
		Assert.equals(child2, returnValue);
		Assert.equals(2, parent.numChildren);
		Assert.equals(parent, child2.parent);
		Assert.equals(child1, parent.getChildAt(0));
		Assert.equals(child2, parent.getChildAt(1));
		
		returnValue = parent.removeChild(child1);
		Assert.equals(child1, returnValue);
		Assert.isNull(child1.parent);
		Assert.equals(child2, parent.getChildAt(0));
		returnValue = parent.removeChild(child1);
		Assert.isNull(returnValue);
		child1.removeFromParent(); // should *not* throw an exception
		
		returnValue = child2.addChild(child1);
		Assert.equals(child1, returnValue);
		Assert.isTrue(parent.contains(child1));
		Assert.isTrue(parent.contains(child2));
		Assert.equals(child2, child1.parent);
		
		returnValue = parent.addChildAt(child1, 0);
		Assert.equals(child1, returnValue);
		Assert.equals(parent, child1.parent);
		Assert.isFalse(child2.contains(child1));
		Assert.equals(child1, parent.getChildAt(0));
		Assert.equals(child2, parent.getChildAt(1));
		
		returnValue = parent.removeChildAt(0);
		Assert.equals(child1, returnValue);
		Assert.equals(child2, parent.getChildAt(0));
		Assert.equals(1, parent.numChildren);
	}
	
	
	public function testRemoveChildren():Void
	{
		var parent:Sprite;
		var numChildren:Int = 10;

		function createSprite(numChildren:Int):Sprite
		{
			var sprite:Sprite = new Sprite();                
			for (i in 0...numChildren)
			{
				var child:Sprite = new Sprite();
				child.name = Std.string(i);
				sprite.addChild(child);
			}
			return sprite;
		}
		
		// removing all children
		
		parent = createSprite(numChildren);
		Assert.equals(10, parent.numChildren);
		
		parent.removeChildren();
		Assert.equals(0, parent.numChildren);
		
		// removing a subset
		
		parent = createSprite(numChildren);
		parent.removeChildren(3, 5);
		Assert.equals(7, parent.numChildren);
		Assert.equals("2", parent.getChildAt(2).name);
		Assert.equals("6", parent.getChildAt(3).name);
		
		// remove beginning from an id
		
		parent = createSprite(numChildren);
		parent.removeChildren(5);
		Assert.equals(5, parent.numChildren);
		Assert.equals("4", parent.getChildAt(4).name);
	}
	
	
	public function testGetChildByName():Void
	{
		var parent:Sprite = new Sprite();
		var child1:Sprite = new Sprite();
		var child2:Sprite = new Sprite();
		var child3:Sprite = new Sprite();
		
		parent.addChild(child1);
		parent.addChild(child2);
		parent.addChild(child3);
		
		child1.name = "child1";
		child2.name = "child2";
		child3.name = "child3";
		
		Assert.equals(child1, parent.getChildByName("child1"));
		Assert.equals(child2, parent.getChildByName("child2"));
		Assert.equals(child3, parent.getChildByName("child3"));
		Assert.isNull(parent.getChildByName("non-existing"));
		
		child2.name = "child3";
		Assert.equals(child2, parent.getChildByName("child3"));
	}
	
	
	public function testSetChildIndex():Void
	{
		var parent:Sprite = new Sprite();
		var childA:Sprite = new Sprite();
		var childB:Sprite = new Sprite();
		var childC:Sprite = new Sprite();
		
		parent.addChild(childA);
		parent.addChild(childB);
		parent.addChild(childC);
		
		parent.setChildIndex(childB, 0);
		Assert.equals(parent.getChildAt(0), childB);
		Assert.equals(parent.getChildAt(1), childA);
		Assert.equals(parent.getChildAt(2), childC);
		
		parent.setChildIndex(childB, 1);
		Assert.equals(parent.getChildAt(0), childA);
		Assert.equals(parent.getChildAt(1), childB);
		Assert.equals(parent.getChildAt(2), childC);
		
		parent.setChildIndex(childB, 2);
		Assert.equals(parent.getChildAt(0), childA);
		Assert.equals(parent.getChildAt(1), childC);
		Assert.equals(parent.getChildAt(2), childB);
		
		Assert.equals(3, parent.numChildren);
	}

	
	public function testGetChildAtWithNegativeIndices():Void
	{
		var parent:Sprite = new Sprite();
		var childA:Sprite = new Sprite();
		var childB:Sprite = new Sprite();
		var childC:Sprite = new Sprite();

		parent.addChild(childA);
		parent.addChild(childB);
		parent.addChild(childC);

		Assert.equals(parent.getChildAt(-3), childA);
		Assert.equals(parent.getChildAt(-2), childB);
		Assert.equals(parent.getChildAt(-1), childC);
	}
	
	
	public function testSwapChildren():Void
	{
		var parent:Sprite = new Sprite();
		var childA:Sprite = new Sprite();
		var childB:Sprite = new Sprite();
		var childC:Sprite = new Sprite();
		
		parent.addChild(childA);
		parent.addChild(childB);
		parent.addChild(childC);
		
		parent.swapChildren(childA, childC);            
		Assert.equals(parent.getChildAt(0), childC);
		Assert.equals(parent.getChildAt(1), childB);
		Assert.equals(parent.getChildAt(2), childA);
		
		parent.swapChildren(childB, childB); // should change nothing
		Assert.equals(parent.getChildAt(0), childC);
		Assert.equals(parent.getChildAt(1), childB);
		Assert.equals(parent.getChildAt(2), childA);
		
		Assert.equals(3, parent.numChildren);
	}
	
	
	public function testWidthAndHeight():Void
	{
		var sprite:Sprite = new Sprite();
		
		var quad1:Quad = new Quad(10, 20);
		quad1.x = -10;
		quad1.y = -15;
		
		var quad2:Quad = new Quad(15, 25);
		quad2.x = 30;
		quad2.y = 25;
		
		sprite.addChild(quad1);
		sprite.addChild(quad2);
		
		Helpers.assertThat(sprite.width, closeTo(55, E));
		Helpers.assertThat(sprite.height, closeTo(65, E));
		
		quad1.rotation = Math.PI / 2;
		Helpers.assertThat(sprite.width, closeTo(75, E));
		Helpers.assertThat(sprite.height, closeTo(65, E));
		
		quad1.rotation = Math.PI;
		Helpers.assertThat(sprite.width, closeTo(65, E));
		Helpers.assertThat(sprite.height, closeTo(85, E));
	}
	
	
	public function testBounds():Void
	{
		var quad:Quad = new Quad(10, 20);
		quad.x = -10;
		quad.y = 10;
		quad.rotation = Math.PI / 2;
		
		var sprite:Sprite = new Sprite();
		sprite.addChild(quad);
		
		var bounds:Rectangle = sprite.bounds;
		Helpers.assertThat(bounds.x, closeTo(-30, E));
		Helpers.assertThat(bounds.y, closeTo(10, E));
		Helpers.assertThat(bounds.width, closeTo(20, E));
		Helpers.assertThat(bounds.height, closeTo(10, E));
		
		bounds = sprite.getBounds(sprite);
		Helpers.assertThat(bounds.x, closeTo(-30, E));
		Helpers.assertThat(bounds.y, closeTo(10, E));
		Helpers.assertThat(bounds.width, closeTo(20, E));
		Helpers.assertThat(bounds.height, closeTo(10, E));            
	}
	
	
	public function testBoundsInSpace():Void
	{		
		function addQuadToSprite(sprite:Sprite):Void
		{
			sprite.addChild(new Quad(100, 100));
		}

		var root:Sprite = new Sprite();
		
		var spriteA:Sprite = new Sprite();
		spriteA.x = 50;
		spriteA.y = 50;
		addQuadToSprite(spriteA);
		root.addChild(spriteA);
		
		var spriteA1:Sprite = new Sprite();
		spriteA1.x = 150;
		spriteA1.y = 50;
		spriteA1.scaleX = spriteA1.scaleY = 0.5;
		addQuadToSprite(spriteA1);
		spriteA.addChild(spriteA1);
		
		var spriteA11:Sprite = new Sprite();
		spriteA11.x = 25;
		spriteA11.y = 50;
		spriteA11.scaleX = spriteA11.scaleY = 0.5;
		addQuadToSprite(spriteA11);
		spriteA1.addChild(spriteA11);
		
		var spriteA2:Sprite = new Sprite();
		spriteA2.x = 50;
		spriteA2.y = 150;
		spriteA2.scaleX = spriteA2.scaleY = 0.5;
		addQuadToSprite(spriteA2);
		spriteA.addChild(spriteA2);
		
		var spriteA21:Sprite = new Sprite();
		spriteA21.x = 50;
		spriteA21.y = 25;
		spriteA21.scaleX = spriteA21.scaleY = 0.5;
		addQuadToSprite(spriteA21);
		spriteA2.addChild(spriteA21);
		
		// ---
		
		var bounds:Rectangle = spriteA21.getBounds(spriteA11);
		var expectedBounds:Rectangle = new Rectangle(-350, 350, 100, 100);
		Helpers.compareRectangles(bounds, expectedBounds);
		
		// now rotate as well
		
		spriteA11.rotation = Math.PI / 4.0;
		spriteA21.rotation = Math.PI / -4.0;
		
		bounds = spriteA21.getBounds(spriteA11);
		expectedBounds = new Rectangle(0, 394.974762, 100, 100);
		Helpers.compareRectangles(bounds, expectedBounds);
	}
	
	
	public function testBoundsOfEmptyContainer():Void
	{
		var sprite:Sprite = new Sprite();
		sprite.x = 100;
		sprite.y = 200;
		
		var bounds:Rectangle = sprite.bounds;
		Helpers.assertThat(bounds.x, closeTo(100, E));
		Helpers.assertThat(bounds.y, closeTo(200, E));
		Helpers.assertThat(bounds.width, closeTo(0, E));
		Helpers.assertThat(bounds.height, closeTo(0, E));            
	}
	
	
	public function testSize():Void
	{
		var quad1:Quad = new Quad(100, 100);
		var quad2:Quad = new Quad(100, 100);
		quad2.x = quad2.y = 100;
		
		var sprite:Sprite = new Sprite();
		var childSprite:Sprite = new Sprite();
		
		sprite.addChild(childSprite);
		childSprite.addChild(quad1);
		childSprite.addChild(quad2);
		
		Helpers.assertThat(sprite.width, closeTo(200, E));
		Helpers.assertThat(sprite.height, closeTo(200, E));
		
		sprite.scaleX = 2.0;
		sprite.scaleY = 2.0;
		
		Helpers.assertThat(sprite.width, closeTo(400, E));
		Helpers.assertThat(sprite.height, closeTo(400, E));
	}
	
	
	public function testSort():Void
	{
		var s1:Sprite = new Sprite(); s1.y = 8;
		var s2:Sprite = new Sprite(); s2.y = 3;
		var s3:Sprite = new Sprite(); s3.y = 6;
		var s4:Sprite = new Sprite(); s4.y = 1;
		
		var parent:Sprite = new Sprite();
		parent.addChild(s1);
		parent.addChild(s2);
		parent.addChild(s3);
		parent.addChild(s4);
		
		Assert.equals(s1, parent.getChildAt(0));
		Assert.equals(s2, parent.getChildAt(1));
		Assert.equals(s3, parent.getChildAt(2));
		Assert.equals(s4, parent.getChildAt(3));
		
		parent.sortChildren(function(child1:DisplayObject, child2:DisplayObject):Int
		{
			if (child1.y < child2.y) return -1;
			else if (child1.y > child2.y) return 1;
			else return 0;
		});
		
		Assert.equals(s4, parent.getChildAt(0));
		Assert.equals(s2, parent.getChildAt(1));
		Assert.equals(s3, parent.getChildAt(2));
		Assert.equals(s1, parent.getChildAt(3));
	}
	
	
	public function testAddExistingChild():Void
	{
		var stage:Stage = @:privateAccess new Stage(400, 300);
		var sprite:Sprite = new Sprite();
		var quad:Quad = new Quad(100, 100);
		quad.addEventListener(Event.ADDED, onAdded);
		quad.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		quad.addEventListener(Event.REMOVED, onRemoved);
		quad.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
		stage.addChild(sprite);
		sprite.addChild(quad);
		Assert.equals(1, _added);
		Assert.equals(1, _addedToStage);
		
		// add same child again
		sprite.addChild(quad);
		
		// nothing should change, actually.
		Assert.equals(1, sprite.numChildren);
		Assert.equals(0, sprite.getChildIndex(quad));
		
		// since the parent does not change, no events should be dispatched 
		Assert.equals(1, _added);
		Assert.equals(1, _addedToStage);
		Assert.equals(0, _removed);
		Assert.equals(0, _removedFromStage);
	}
	
	
	public function testRemoveWithEventHandler():Void
	{
		var parent:Sprite = new Sprite();
		var child0:Sprite = new Sprite();
		var child1:Sprite = new Sprite();
		var child2:Sprite = new Sprite();
		
		parent.addChild(child0);
		parent.addChild(child1);
		parent.addChild(child2);
		
		// Remove last child, and in its event listener remove first child.
		// That must work, even though the child changes its index in the event handler.
		
		child2.addEventListener(Event.REMOVED, function():Void
		{
			child0.removeFromParent();
		});
		
		Helpers.assertDoesNotThrow(function():Void
		{
			parent.removeChildAt(2);
		});
		
		Assert.isNull(child2.parent);
		Assert.isNull(child0.parent);
		Assert.equals(child1, parent.getChildAt(0));
		Assert.equals(1, parent.numChildren);
	}
	
	public function testIllegalRecursion():Void
	{
		var sprite1:Sprite = new Sprite();
		var sprite2:Sprite = new Sprite();
		var sprite3:Sprite = new Sprite();
		
		sprite1.addChild(sprite2);
		sprite2.addChild(sprite3);
		
		Assert.raises(function():Void
		{
			// this should throw an error
			sprite3.addChild(sprite1);
		}, ArgumentError);
	}
	
	public function testAddAsChildToSelf():Void
	{
		var sprite:Sprite = new Sprite();
		Assert.raises(function():Void
		{
			sprite.addChild(sprite);
		}, ArgumentError);
	}
	
	
	public function testDisplayListEvents():Void
	{
		var stage:Stage = @:privateAccess new Stage(100, 100);
		var sprite:Sprite = new Sprite();
		var quad:Quad = new Quad(20, 20);
		
		quad.addEventListener(Event.ADDED, onAdded);
		quad.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		quad.addEventListener(Event.REMOVED, onRemoved);
		quad.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
		stage.addEventListener(Event.ADDED, onAddedChild);
		stage.addEventListener(Event.REMOVED, onRemovedChild);
		
		sprite.addChild(quad);            
		Assert.equals(1, _added);
		Assert.equals(0, _removed);
		Assert.equals(0, _addedToStage);
		Assert.equals(0, _removedFromStage);
		Assert.equals(0, _addedChild);
		Assert.equals(0, _removedChild);
		
		stage.addChild(sprite);
		Assert.equals(1, _added);
		Assert.equals(0, _removed);
		Assert.equals(1, _addedToStage);
		Assert.equals(0, _removedFromStage);
		Assert.equals(1, _addedChild);
		Assert.equals(0, _removedChild);
		
		stage.removeChild(sprite);
		Assert.equals(1, _added);
		Assert.equals(0, _removed);
		Assert.equals(1, _addedToStage);
		Assert.equals(1, _removedFromStage);
		Assert.equals(1, _addedChild);
		Assert.equals(1, _removedChild);
		
		sprite.removeChild(quad);
		Assert.equals(1, _added);
		Assert.equals(1, _removed);
		Assert.equals(1, _addedToStage);
		Assert.equals(1, _removedFromStage);
		Assert.equals(1, _addedChild);
		Assert.equals(1, _removedChild);
	}
	
	
	public function testRemovedFromStage():Void
	{
		var stage:Stage = @:privateAccess new Stage(100, 100);
		var sprite:Sprite = new Sprite();
		stage.addChild(sprite);
		function onSpriteRemovedFromStage(e:Event):Void
		{
			// stage should still be accessible in event listener
			Assert.notNull(sprite.stage);
			_removedFromStage++;
		}
		sprite.addEventListener(Event.REMOVED_FROM_STAGE, onSpriteRemovedFromStage);
		sprite.removeFromParent();
		Assert.equals(1, _removedFromStage);
	}
	
	
	public function testRepeatedStageRemovedEvent():Void
	{
		var stage:Stage = @:privateAccess new Stage(100, 100);
		var grandParent:Sprite = new Sprite();
		var parent:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		
		stage.addChild(grandParent);
		grandParent.addChild(parent);
		parent.addChild(child);

		var childRemovedCount:Int = 0;

		function onGrandParentRemovedFromStage():Void
		{
			parent.removeFromParent();
		}
		
		function onChildRemovedFromStage():Void
		{
			Assert.notNull(child.stage);
			Assert.equals(0, childRemovedCount);
			
			childRemovedCount++;
		}
		
		grandParent.addEventListener(Event.REMOVED_FROM_STAGE, onGrandParentRemovedFromStage);
		child.addEventListener(Event.REMOVED_FROM_STAGE, onChildRemovedFromStage);
		
		// in this set-up, the child could receive the REMOVED_FROM_STAGE event more than
		// once -- which must be avoided. Furthermore, "stage" must always be accessible
		// in such an event handler.
		
		grandParent.removeFromParent();
	}
	
	private function onAdded(event:Event):Void { _added++; }
	private function onAddedToStage(event:Event):Void { _addedToStage++; }
	private function onAddedChild(event:Event):Void { _addedChild++; }
	
	private function onRemoved(event:Event):Void { _removed++; }
	private function onRemovedFromStage(event:Event):Void { _removedFromStage++; }
	private function onRemovedChild(event:Event):Void { _removedChild++; }
}
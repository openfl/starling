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

import starling.display.Sprite3D;
import starling.display.Sprite;
import utest.Assert;
import utest.Test;

class Sprite3DTest extends Test
{
	
	public function testBasicProperties():Void
	{
		var sprite:Sprite3D = new Sprite3D();
		Assert.equals(0, sprite.numChildren);
		Assert.equals(0, sprite.rotationX);
		Assert.equals(0, sprite.rotationY);
		Assert.equals(0, sprite.pivotZ);
		Assert.equals(0, sprite.z);

		sprite.addChild(new Sprite());
		sprite.rotationX = 2;
		sprite.rotationY = 3;
		sprite.pivotZ = 4;
		sprite.z = 5;

		Assert.equals(1, sprite.numChildren);
		Assert.equals(2, sprite.rotationX);
		Assert.equals(3, sprite.rotationY);
		Assert.equals(4, sprite.pivotZ);
		Assert.equals(5, sprite.z);
	}

	
	public function testIs3D():Void
	{
		var sprite3D:Sprite3D = new Sprite3D();
		Assert.isTrue(sprite3D.is3D);

		var sprite:Sprite = new Sprite();
		Assert.isFalse(sprite.is3D);

		var child:Sprite = new Sprite();
		sprite.addChild(child);
		Assert.isFalse(child.is3D);

		sprite3D.addChild(sprite);
		Assert.isTrue(sprite.is3D);
		Assert.isTrue(child.is3D);

		sprite.removeFromParent();
		Assert.isFalse(sprite.is3D);
		Assert.isFalse(child.is3D);
	}
}
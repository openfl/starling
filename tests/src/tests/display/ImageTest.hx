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

import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.display.Image;
import starling.textures.Texture;
import tests.utils.MockTexture;
import utest.Assert;
import utest.Test;

class ImageTest extends Test
{
	@:final private static var E:Float = 0.00001;

	
	public function testBindScale9GridToTexture():Void
	{
		var image:Image;
		var texture:Texture = new MockTexture(16, 16);
		var texture2:Texture = new MockTexture(16, 16);
		var scale9Grid:Rectangle = new Rectangle(2, 2, 12, 12);

		Image.bindScale9GridToTexture(texture, scale9Grid);

		image = new Image(texture);
		Helpers.compareRectangles(image.scale9Grid, scale9Grid);

		image.texture = texture2;
		Assert.isNull(image.scale9Grid);

		Image.resetSetupForTexture(texture);

		image = new Image(texture);
		Assert.isNull(image.scale9Grid);
	}

	
	public function testBindPivotPointToTexture():Void
	{
		var image:Image;
		var texture:Texture = new MockTexture(16, 16);
		var texture2:Texture = new MockTexture(16, 16);
		var pivotX:Float = 4;
		var pivotY:Float = 8;

		Image.bindPivotPointToTexture(texture, pivotX, pivotY);

		image = new Image(texture);
		Helpers.assertThat(image.pivotX, closeTo(pivotX, E));
		Helpers.assertThat(image.pivotY, closeTo(pivotY, E));

		image.texture = texture2;
		Assert.equals(image.pivotX, 0);
		Assert.equals(image.pivotY, 0);

		Image.resetSetupForTexture(texture);

		image = new Image(texture);
		Assert.equals(image.pivotX, 0);
		Assert.equals(image.pivotY, 0);
	}

	
	public function testAddAndRemoveAutomatedSetup():Void
	{
		var image:Image;
		var texture:Texture = new MockTexture(16, 16);
		var setupColor:UInt = 0xff0000;
		var releaseColor:UInt = 0x00ff00;

		function onAssign(image:Image):Void { image.color = setupColor; }
		function onRelease(image:Image):Void { image.color = releaseColor; }

		Image.automateSetupForTexture(texture, onAssign, onRelease);
		image = new Image(texture);
		Assert.equals(image.color, setupColor);

		Assert.equals(image.color, setupColor);
		image.texture = null;
		Assert.equals(image.color, releaseColor);

		Image.removeSetupForTexture(texture, onAssign, onRelease);
		image.texture = texture;
		Assert.equals(image.color, releaseColor);

		image.color = 0x0;
		Assert.equals(image.color, 0x0);
	}

	
	public function testAutomatedSetupWithMultipleCallbacks():Void
	{
		var image:Image;
		var texture:Texture = new MockTexture(16, 16);
		var pivotX:Float = 4;
		var pivotY:Float = 8;
		var setupColor:UInt = 0xff0000;
		var releaseColor:UInt = 0;

		Image.bindPivotPointToTexture(texture, pivotX, pivotY);
		Image.automateSetupForTexture(texture,
			function(image:Image):Void { image.color = setupColor; },
			function(image:Image):Void { image.color = releaseColor; });

		image = new Image(texture);

		Helpers.assertThat(image.pivotX, closeTo(pivotX, E));
		Helpers.assertThat(image.pivotY, closeTo(pivotY, E));
		Assert.equals(image.color, setupColor);

		image.texture = new MockTexture(16, 16);

		Assert.equals(image.pivotX, 0);
		Assert.equals(image.pivotY, 0);
		Assert.equals(image.color, 0);

		Image.resetSetupForTexture(texture);
		image.texture = texture;

		Assert.equals(image.pivotX, 0);
		Assert.equals(image.pivotY, 0);
		Assert.equals(image.color, releaseColor);
	}
}
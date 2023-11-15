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
import starling.display.Button;
import starling.textures.Texture;
import tests.StarlingTest;
import tests.utils.MockTexture;

class ButtonTest extends StarlingTest
{
	@:final private static var E:Float = 0.0001;

	
	public function testWidthAndHeight():Void
	{
		var texture:Texture = new MockTexture(100, 50);
		var button:Button = new Button(texture, "test");
		var textBounds:Rectangle = new Rectangle();

		Helpers.assertThat(button.width,  closeTo(100, E));
		Helpers.assertThat(button.height, closeTo(50, E));
		Helpers.assertThat(button.scaleX, closeTo(1.0, E));
		Helpers.assertThat(button.scaleY, closeTo(1.0, E));

		button.scale = 0.5;
		textBounds.copyFrom(button.textBounds);

		Helpers.assertThat(button.width, closeTo(50, E));
		Helpers.assertThat(button.height, closeTo(25, E));
		Helpers.assertThat(button.scaleX, closeTo(0.5, E));
		Helpers.assertThat(button.scaleY, closeTo(0.5, E));
		Helpers.assertThat(textBounds.width, closeTo(100, E));
		Helpers.assertThat(textBounds.height, closeTo(50, E));

		button.width = 100;
		button.height = 50;
		textBounds.copyFrom(button.textBounds);

		Helpers.assertThat(button.width,  closeTo(100, E));
		Helpers.assertThat(button.height, closeTo(50, E));
		Helpers.assertThat(button.scaleX, closeTo(0.5, E));
		Helpers.assertThat(button.scaleY, closeTo(0.5, E));
		Helpers.assertThat(textBounds.width, closeTo(200, E));
		Helpers.assertThat(textBounds.height, closeTo(100, E));
	}
}
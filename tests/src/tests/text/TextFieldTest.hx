// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.text;

import openfl.Vector;
import org.hamcrest.Matchers.closeTo;
import org.hamcrest.Matchers.greaterThan;
import org.hamcrest.Matchers.lessThanOrEqualTo;
import starling.display.MeshBatch;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.text.TextFormat;
import starling.textures.Texture;
import tests.StarlingTest;
import utest.Assert;

class TextFieldTest extends StarlingTest
{
	@:final private static var E:Float = 0.0001;
	@:final private static var SUPER_LARGE_TEXT_LENGTH:Float = 3200;

	
	public function testTextField():Void
	{
		var textField:TextField = new TextField(240, 50, "test text");
		Assert.equals("test text", textField.text);
	}

	
	public function testWidthAndHeight():Void
	{
		var textField:TextField = new TextField(100, 50, "test");

		Helpers.assertThat(textField.width,  closeTo(100, E));
		Helpers.assertThat(textField.height, closeTo(50, E));
		Helpers.assertThat(textField.scaleX, closeTo(1.0, E));
		Helpers.assertThat(textField.scaleY, closeTo(1.0, E));

		textField.scale = 0.5;

		Helpers.assertThat(textField.width, closeTo(50, E));
		Helpers.assertThat(textField.height, closeTo(25, E));
		Helpers.assertThat(textField.scaleX, closeTo(0.5, E));
		Helpers.assertThat(textField.scaleY, closeTo(0.5, E));

		textField.width = 100;
		textField.height = 50;

		Helpers.assertThat(textField.width,  closeTo(100, E));
		Helpers.assertThat(textField.height, closeTo(50, E));
		Helpers.assertThat(textField.scaleX, closeTo(0.5, E));
		Helpers.assertThat(textField.scaleY, closeTo(0.5, E));
	}

	
	public function testLargeTextField():Void
	{
		var maxTextureSize:Int = Texture.maxSize;
		var sampleText:String = getSampleText(Std.int(SUPER_LARGE_TEXT_LENGTH * (maxTextureSize / 2048)));
		var textField:TextField = new TextField(500, 50, sampleText);
		textField.format = new TextFormat("_sans", 32);
		textField.autoSize = TextFieldAutoSize.VERTICAL;

		Helpers.assertThat(textField.height, greaterThan(maxTextureSize));

		var textureSize:Texture = mainTextureFromTextField(textField);
		Assert.notNull(textureSize);
		Helpers.assertThat(textureSize != null ? textureSize.height * textureSize.scale : 0,
				lessThanOrEqualTo(maxTextureSize));
	}

	/** Creates a sample text longer than 'leastLength'. */
	private function getSampleText(leastLength:Int):String
	{
		var sample:String = "This is a sample String. ";
		var repeat:Int = Math.ceil(leastLength / sample.length);
		var parts:Vector<String> = new Vector<String>(repeat);

		for (i in 0...repeat)
			parts[i] = sample;

		return parts.join("");
	}

	/** Retrieves the TextField's internally used 'Texture'. */
	private function mainTextureFromTextField(textField:TextField):Texture
	{
		for (i in 0...textField.numChildren)
		{
			var meshBatch:MeshBatch = #if haxe4 Std.downcast #else Std.instance #end(textField.getChildAt(i), MeshBatch);
			if (meshBatch != null) return meshBatch.texture;
		}
		return null;
	}
}
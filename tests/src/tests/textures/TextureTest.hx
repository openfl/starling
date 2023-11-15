// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.textures;

import utest.Test;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.rendering.VertexData;
import starling.textures.SubTexture;
import starling.textures.Texture;
import tests.utils.MockTexture;
import utest.Assert;

class TextureTest extends Test
{
	@:final private static var E:Float = 0.0001;
	
	public function testTextureCoordinates():Void
	{
		var rootWidth:Int = 256;
		var rootHeight:Int = 128;
		var subTexture:SubTexture;
		var subSubTexture:SubTexture;
		var texCoords:Point = new Point();
		var expected:Point = new Point();
		var texture:Texture = new MockTexture(rootWidth, rootHeight);

		// test sub texture filling the whole base texture
		subTexture = new SubTexture(texture, new Rectangle(0, 0, rootWidth, rootHeight));            
		subTexture.localToGlobal(1, 1, texCoords);
		expected.setTo(1, 1);
		Helpers.comparePoints(expected, texCoords);

		// test subtexture with 50% of the size of the base texture
		subTexture = new SubTexture(texture,
			new Rectangle(rootWidth/4, rootHeight/4, rootWidth/2, rootHeight/2));
		subTexture.localToGlobal(1, 0.5, texCoords);
		expected.setTo(0.75, 0.5);
		Helpers.comparePoints(expected, texCoords);

		// test subtexture of subtexture
		subSubTexture = new SubTexture(subTexture,
			new Rectangle(subTexture.width/4, subTexture.height/4, 
							subTexture.width/2, subTexture.height/2));
		subSubTexture.localToGlobal(1, 0.5, texCoords);
		expected.setTo(0.625, 0.5);
		Helpers.comparePoints(expected, texCoords);
	}
	
	
	public function testRotation():Void
	{
		var rootWidth:Int = 256;
		var rootHeight:Int = 128;
		var subTexture:SubTexture;
		var subSubTexture:SubTexture;
		var texCoords:Point = new Point();
		var expected:Point = new Point();
		var texture:Texture = new MockTexture(rootWidth, rootHeight);

		// rotate full region once
		subTexture = new SubTexture(texture, null, false, null, true);
		subTexture.localToGlobal(1, 1, texCoords);
		expected.setTo(0, 1);
		Helpers.comparePoints(expected, texCoords);

		// rotate again
		subSubTexture = new SubTexture(subTexture, null, false, null, true);
		subSubTexture.localToGlobal(1, 1, texCoords);
		expected.setTo(0, 0);
		Helpers.comparePoints(expected, texCoords);

		// now get rotated region
		subTexture = new SubTexture(texture,
			new Rectangle(rootWidth/4, rootHeight/2, rootWidth/2, rootHeight/4),
			false, null, true);
		subTexture.localToGlobal(1, 1, texCoords);
		expected.setTo(0.25, 0.75);
		Helpers.comparePoints(expected, texCoords);
	}

	
	public function testSetupVertexPositions():Void
	{
		var size:Rectangle = new Rectangle(0, 0, 60, 40);
		var frame:Rectangle = new Rectangle(-20, -30, 100, 100);
		var texture:Texture = new MockTexture(Std.int(size.width), Std.int(size.height));
		var subTexture:SubTexture = new SubTexture(texture, null, false, frame);
		var vertexData:VertexData = new VertexData("pos:float2");
		var expected:Rectangle = new Rectangle();
		var result:Rectangle, bounds:Rectangle;

		Assert.equals(100, subTexture.frameWidth);
		Assert.equals(100, subTexture.frameHeight);

		subTexture.setupVertexPositions(vertexData, 0, "pos");
		Assert.equals(4, vertexData.numVertices);

		result = vertexData.getBounds("pos");
		expected.setTo(20, 30, 60, 40);
		Helpers.compareRectangles(expected, result);

		bounds = new Rectangle(1, 2, 200, 50);
		subTexture.setupVertexPositions(vertexData, 0, "pos", bounds);
		result = vertexData.getBounds("pos");
		expected.setTo(41, 17, 120, 20);
		Helpers.compareRectangles(expected, result);
	}

	
	public function testGetRoot():Void
	{
		var texture:Texture = new MockTexture(32, 32);
		var subTexture:SubTexture = new SubTexture(texture, new Rectangle(0, 0, 16, 16));
		var subSubTexture:SubTexture = new SubTexture(texture, new Rectangle(0, 0, 8, 8));
		
		Assert.equals(texture, texture.root);
		Assert.equals(texture, subTexture.root);
		Assert.equals(texture, subSubTexture.root);
		Assert.equals(texture.base, subSubTexture.base);
	}

	
	public function testGetSize():Void
	{
		var texture:Texture = new MockTexture(32, 16, 2);
		var subTexture:SubTexture = new SubTexture(texture, new Rectangle(0, 0, 12, 8));
		
		Helpers.assertThat(texture.width, closeTo(16, E));
		Helpers.assertThat(texture.height, closeTo(8, E));
		Helpers.assertThat(texture.nativeWidth, closeTo(32, E));
		Helpers.assertThat(texture.nativeHeight, closeTo(16, E));
		
		Helpers.assertThat(subTexture.width, closeTo(12, E));
		Helpers.assertThat(subTexture.height, closeTo(8, E));
		Helpers.assertThat(subTexture.nativeWidth, closeTo(24, E));
		Helpers.assertThat(subTexture.nativeHeight, closeTo(16, E));
	}

	
	public function testScaleModifier():Void
	{
		var texCoords:Point;
		var region:Rectangle;
		var texture:Texture = new MockTexture(32, 16, 2);
		var subTexture:SubTexture = new SubTexture(texture, null, false, null, false, 0.5);

		// construct texture with scale factor 1
		Helpers.assertThat(subTexture.scale, closeTo(1.0, E));
		Helpers.assertThat(subTexture.width, closeTo(texture.nativeWidth, E));
		Helpers.assertThat(subTexture.height, closeTo(texture.nativeHeight, E));
		Helpers.assertThat(subTexture.nativeWidth, closeTo(texture.nativeWidth, E));
		Helpers.assertThat(subTexture.nativeHeight, closeTo(texture.nativeHeight, E));

		// and from the one above, back to the original factor of 2
		var subSubTexture:SubTexture = new SubTexture(subTexture, null, false, null, false, 2.0);
		Helpers.assertThat(subSubTexture.scale, closeTo(2.0, E));
		Helpers.assertThat(subSubTexture.width, closeTo(texture.width, E));
		Helpers.assertThat(subSubTexture.height, closeTo(texture.height, E));
		Helpers.assertThat(subSubTexture.nativeWidth, closeTo(texture.nativeWidth, E));
		Helpers.assertThat(subSubTexture.nativeHeight, closeTo(texture.nativeHeight, E));

		// now make the resolution of the original texture even higher
		subTexture = new SubTexture(texture, null, false, null, false, 2);
		Helpers.assertThat(subTexture.scale, closeTo(4.0, E));
		Helpers.assertThat(subTexture.width, closeTo(texture.width / 2, E));
		Helpers.assertThat(subTexture.height, closeTo(texture.height / 2, E));
		Helpers.assertThat(subTexture.nativeWidth, closeTo(texture.nativeWidth, E));
		Helpers.assertThat(subTexture.nativeHeight, closeTo(texture.nativeHeight, E));

		// test region
		region = new Rectangle(8, 4, 8, 4);
		subTexture = new SubTexture(texture, region, false, null, false, 0.5);
		Helpers.assertThat(subTexture.width, closeTo(region.width * 2, E));
		Helpers.assertThat(subTexture.height, closeTo(region.height * 2, E));
		Helpers.assertThat(subTexture.nativeWidth, closeTo(texture.nativeWidth / 2, E));
		Helpers.assertThat(subTexture.nativeHeight, closeTo(texture.nativeHeight / 2, E));

		texCoords = subTexture.localToGlobal(0, 0);
		Helpers.comparePoints(new Point(0.5, 0.5), texCoords);

		texCoords = subTexture.localToGlobal(1, 1);
		Helpers.comparePoints(new Point(1, 1), texCoords);
	}
}
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

import openfl.geom.Point;
import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import tests.utils.MockTexture;
import utest.Assert;
import utest.Test;

class QuadTest extends Test
{
	@:final private static var E:Float = 0.0001;

	
	public function testQuad():Void
	{
		var quad:Quad = new Quad(100, 200, Color.AQUA);            
		Assert.equals(Color.AQUA, quad.color);
	}
	
	
	public function testColors():Void
	{
		var quad:Quad = new Quad(100, 100);            
		quad.setVertexColor(0, Color.AQUA);
		quad.setVertexColor(1, Color.BLACK);
		quad.setVertexColor(2, Color.BLUE);
		quad.setVertexColor(3, Color.FUCHSIA);
		
		Assert.equals(Color.AQUA,    quad.getVertexColor(0));
		Assert.equals(Color.BLACK,   quad.getVertexColor(1));
		Assert.equals(Color.BLUE,    quad.getVertexColor(2));
		Assert.equals(Color.FUCHSIA, quad.getVertexColor(3));
	}

	
	public function testBounds():Void
	{
		var quad:Quad = new Quad(100, 200);
		Helpers.compareRectangles(new Rectangle(0, 0, 100, 200), quad.bounds);
		
		quad.pivotX = 50;
		Helpers.compareRectangles(new Rectangle(-50, 0, 100, 200), quad.bounds);
		
		quad.pivotY = 60;
		Helpers.compareRectangles(new Rectangle(-50, -60, 100, 200), quad.bounds);
		
		quad.scaleX = 2;
		Helpers.compareRectangles(new Rectangle(-100, -60, 200, 200), quad.bounds);
		
		quad.scaleY = 0.5;
		Helpers.compareRectangles(new Rectangle(-100, -30, 200, 100), quad.bounds);
		
		quad.x = 10;
		Helpers.compareRectangles(new Rectangle(-90, -30, 200, 100), quad.bounds);
		
		quad.y = 20;
		Helpers.compareRectangles(new Rectangle(-90, -10, 200, 100), quad.bounds);
		
		var parent:Sprite = new Sprite();
		parent.addChild(quad);
		
		Helpers.compareRectangles(parent.bounds, quad.bounds);
	}
	
	
	public function testWidthAndHeight():Void
	{
		var quad:Quad = new Quad(100, 50);
		Assert.equals(100, quad.width);
		Assert.equals(50,  quad.height);
		
		quad.scaleX = -1;
		Assert.equals(100, quad.width);
		
		quad.pivotX = 100;
		Assert.equals(100, quad.width);
		
		quad.pivotX = -10;
		Assert.equals(100, quad.width);
		
		quad.scaleY = -1;
		Assert.equals(50, quad.height);
		
		quad.pivotY = 20;
		Assert.equals(50, quad.height);
	}

	
	public function testHitTest():Void
	{
		var quad:Quad = new Quad(100, 50);
		Assert.equals(quad, quad.hitTest(new Point(0.1, 0.1)));
		Assert.equals(quad, quad.hitTest(new Point(99.9, 49.9)));
		Assert.isNull(quad.hitTest(new Point(-0.1, -0.1)));
		Assert.isNull(quad.hitTest(new Point(100.1, 25)));
		Assert.isNull(quad.hitTest(new Point(50, 50.1)));
		Assert.isNull(quad.hitTest(new Point(100.1, 50.1)));
	}

	
	public function testReadjustSize():Void
	{
		var texture:Texture = new MockTexture(100, 50);
		var quad:Quad = new Quad(10, 20);
		quad.texture = texture;

		Helpers.assertThat(quad.width, closeTo(10, E));
		Helpers.assertThat(quad.height, closeTo(20, E));
		Assert.equals(texture, quad.texture);

		quad.readjustSize();

		Helpers.assertThat(quad.width, closeTo(texture.frameWidth, E));
		Helpers.assertThat(quad.height, closeTo(texture.frameHeight, E));

		var newWidth:Float  = 64;
		var newHeight:Float = 32;

		quad.readjustSize(newWidth, newHeight);

		Helpers.assertThat(quad.width, closeTo(newWidth, E));
		Helpers.assertThat(quad.height, closeTo(newHeight, E));

		quad.texture = null;
		quad.readjustSize(); // shouldn't change anything

		Helpers.assertThat(quad.width, closeTo(newWidth, E));
		Helpers.assertThat(quad.height, closeTo(newHeight, E));
	}
}
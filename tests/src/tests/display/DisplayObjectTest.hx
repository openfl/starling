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

import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Stage;
import starling.utils.Align;
import starling.utils.MathUtil;
import utest.Assert;
import utest.Test;

class DisplayObjectTest extends Test
{
	@:final private static var E:Float = 0.0001;
	
	
	public function testBase():Void
	{
		var object1:Sprite = new Sprite();
		var object2:Sprite = new Sprite();
		var object3:Sprite = new Sprite();
		
		object1.addChild(object2);
		object2.addChild(object3);
		
		Assert.equals(object1, object1.base);
		Assert.equals(object1, object2.base);
		Assert.equals(object1, object3.base);
		
		var quad:Quad = new Quad(100, 100);
		Assert.equals(quad, quad.base);
	}
	
	
	public function testRootAndStage():Void
	{
		var object1:Sprite = new Sprite();
		var object2:Sprite = new Sprite();
		var object3:Sprite = new Sprite();
		
		object1.addChild(object2);
		object2.addChild(object3);
		
		Assert.equals(null, object1.root);
		Assert.equals(null, object2.root);
		Assert.equals(null, object3.root);
		Assert.equals(null, object1.stage);
		Assert.equals(null, object2.stage);
		Assert.equals(null, object3.stage);
		
		var stage:Stage = @:privateAccess new Stage(100, 100);
		stage.addChild(object1);
		
		Assert.equals(object1, object1.root);
		Assert.equals(object1, object2.root);
		Assert.equals(object1, object3.root);
		Assert.equals(stage, object1.stage);
		Assert.equals(stage, object2.stage);
		Assert.equals(stage, object3.stage);
	}
	
	
	public function testGetTransformationMatrix():Void
	{
		var sprite:Sprite = new Sprite();
		var child:Sprite = new Sprite();
		child.x = 30;
		child.y = 20;
		child.scaleX = 1.2;
		child.scaleY = 1.5;
		child.rotation = Math.PI / 4.0;
		sprite.addChild(child);
		
		var matrix:Matrix = sprite.getTransformationMatrix(child);
		var expectedMatrix:Matrix = child.transformationMatrix;
		expectedMatrix.invert();            
		Helpers.compareMatrices(expectedMatrix, matrix);
		
		matrix = child.getTransformationMatrix(sprite);
		Helpers.compareMatrices(child.transformationMatrix, matrix);
					
		// more is tested indirectly via 'testBoundsInSpace' in DisplayObjectContainerTest            
	}
	
	
	public function testSetTransformationMatrix():Void
	{
		var sprite:Sprite = new Sprite();
		var matrix:Matrix = new Matrix();
		matrix.scale(1.5, 2.0);
		matrix.rotate(0.25);
		matrix.translate(10, 20);
		sprite.transformationMatrix = matrix;
		
		Helpers.assertThat(sprite.scaleX, closeTo(1.5, E));
		Helpers.assertThat(sprite.scaleY, closeTo(2.0, E));
		Helpers.assertThat(sprite.rotation, closeTo(0.25, E));
		Helpers.assertThat(sprite.x, closeTo(10, E));
		Helpers.assertThat(sprite.y, closeTo(20, E));
		
		Helpers.compareMatrices(matrix, sprite.transformationMatrix);
	}
	
	
	public function testSetTransformationMatrixWithPivot():Void
	{
		// pivot point information is redundant; instead, x/y properties will be modified.
		
		var sprite:Sprite = new Sprite();
		sprite.pivotX = 50;
		sprite.pivotY = 20;
		
		var matrix:Matrix = sprite.transformationMatrix;
		sprite.transformationMatrix = matrix;
		
		Helpers.assertThat(sprite.x, closeTo(-50, E));
		Helpers.assertThat(sprite.y, closeTo(-20, E));
		Helpers.assertThat(sprite.pivotX, closeTo(0.0, E));
		Helpers.assertThat(sprite.pivotY, closeTo(0.0, E));
	}
	
	
	public function testSetTransformationMatrixWithRightAngles():Void
	{
		var sprite:Sprite = new Sprite();
		var matrix:Matrix = new Matrix();
		var angles:Array<Float> = [Math.PI / 2.0, Math.PI / -2.0];

		for (angle in angles)
		{
			matrix.identity();
			matrix.rotate(angle);
			sprite.transformationMatrix = matrix;

			Helpers.assertThat(sprite.x, closeTo(0, E));
			Helpers.assertThat(sprite.y, closeTo(0, E));
			Helpers.assertThat(sprite.skewX, closeTo(0.0, E));
			Helpers.assertThat(sprite.skewY, closeTo(0.0, E));
			Helpers.assertThat(sprite.rotation, closeTo(angle, E));
		}
	}
	
	
	public function testSetTransformationMatrixWithZeroValues():Void
	{
		var sprite:Sprite = new Sprite();
		var matrix:Matrix = new Matrix(0, 0, 0, 0, 0, 0);
		sprite.transformationMatrix = matrix;
		
		Assert.equals(0.0, sprite.x);
		Assert.equals(0.0, sprite.y);
		Assert.equals(0.0, sprite.scaleX);
		Assert.equals(0.0, sprite.scaleY);
		Assert.equals(0.0, sprite.rotation);
		Assert.equals(0.0, sprite.skewX);
		Assert.equals(0.0, sprite.skewY);
	}

	
	public function testBounds():Void
	{
		var quad:Quad = new Quad(10, 20);
		quad.x = -10;
		quad.y =  10;
		quad.rotation = Math.PI / 2;
		
		var bounds:Rectangle = quad.bounds;            
		Helpers.assertThat(bounds.x, closeTo(-30, E));
		Helpers.assertThat(bounds.y, closeTo(10, E));
		Helpers.assertThat(bounds.width, closeTo(20, E));
		Helpers.assertThat(bounds.height, closeTo(10, E));
		
		bounds = quad.getBounds(quad);
		Helpers.assertThat(bounds.x, closeTo(0, E));
		Helpers.assertThat(bounds.y, closeTo(0, E));
		Helpers.assertThat(bounds.width, closeTo(10, E));
		Helpers.assertThat(bounds.height, closeTo(20, E));
	}
	
	
	public function testZeroSize():Void
	{
		var sprite:Sprite = new Sprite();
		Assert.equals(1.0, sprite.scaleX);
		Assert.equals(1.0, sprite.scaleY);
		
		// sprite is empty, scaling should thus have no effect!
		sprite.width = 100;
		sprite.height = 200;
		Assert.equals(1.0, sprite.scaleX);
		Assert.equals(1.0, sprite.scaleY);
		Assert.equals(0.0, sprite.width);
		Assert.equals(0.0, sprite.height);
		
		// setting a value to zero should be no problem -- and the original size 
		// should be remembered.
		var quad:Quad = new Quad(100, 200);
		quad.scaleX = 0.0;
		quad.scaleY = 0.0;
		Helpers.assertThat(quad.width, closeTo(0, E));
		Helpers.assertThat(quad.height, closeTo(0, E));
		
		quad.scaleX = 1.0;
		quad.scaleY = 1.0;
		Helpers.assertThat(quad.width, closeTo(100, E));
		Helpers.assertThat(quad.height, closeTo(200, E));

		// the same should work with width & height
		quad = new Quad(100, 200);
		quad.width = 0;
		quad.height = 0;
		Helpers.assertThat(quad.width, closeTo(0, E));
		Helpers.assertThat(quad.height, closeTo(0, E));

		quad.width = 50;
		quad.height = 100;
		Helpers.assertThat(quad.scaleX, closeTo(0.5, E));
		Helpers.assertThat(quad.scaleY, closeTo(0.5, E));
	}
	
	
	public function testLocalToGlobal():Void
	{
		var root:Sprite = new Sprite();
		var sprite:Sprite = new Sprite();
		sprite.x = 10;
		sprite.y = 20;
		root.addChild(sprite);
		var sprite2:Sprite = new Sprite();
		sprite2.x = 150;
		sprite2.y = 200;
		sprite.addChild(sprite2);
		
		var localPoint:Point = new Point(0, 0);
		var globalPoint:Point = sprite2.localToGlobal(localPoint);
		var expectedPoint:Point = new Point(160, 220);
		Helpers.comparePoints(expectedPoint, globalPoint);
		
		// the position of the root object should be irrelevant -- we want the coordinates
		// *within* the root coordinate system!
		root.x = 50;
		globalPoint = sprite2.localToGlobal(localPoint);
		Helpers.comparePoints(expectedPoint, globalPoint);
	}
		
	
	public function testGlobalToLocal():Void
	{
		var root:Sprite = new Sprite();
		var sprite:Sprite = new Sprite();
		sprite.x = 10;
		sprite.y = 20;
		root.addChild(sprite);
		var sprite2:Sprite = new Sprite();
		sprite2.x = 150;
		sprite2.y = 200;
		sprite.addChild(sprite2);
		
		var globalPoint:Point = new Point(160, 220);
		var localPoint:Point = sprite2.globalToLocal(globalPoint);
		var expectedPoint:Point = new Point();
		Helpers.comparePoints(expectedPoint, localPoint);
		
		// the position of the root object should be irrelevant -- we want the coordinates
		// *within* the root coordinate system!
		root.x = 50;
		localPoint = sprite2.globalToLocal(globalPoint);
		Helpers.comparePoints(expectedPoint, localPoint);
	}
	
	
	public function testHitTestPoint():Void
	{
		var quad:Quad = new Quad(25, 10);            
		Assert.notNull(quad.hitTest(new Point(15, 5)));
		Assert.notNull(quad.hitTest(new Point(0, 0)));
		Assert.notNull(quad.hitTest(new Point(24.99, 0)));
		Assert.notNull(quad.hitTest(new Point(24.99, 9.99)));
		Assert.notNull(quad.hitTest(new Point(0, 9.99)));
		Assert.isNull(quad.hitTest(new Point(-1, -1)));
		Assert.isNull(quad.hitTest(new Point(25.01, 10.01)));
		
		quad.visible = false;
		Assert.isNull(quad.hitTest(new Point(15, 5)));
		
		quad.visible = true;
		quad.touchable = false;
		Assert.isNull(quad.hitTest(new Point(10, 5)));
		
		quad.visible = false;
		quad.touchable = false;
		Assert.isNull(quad.hitTest(new Point(10, 5)));
	}
	
	
	public function testRotation():Void
	{
		var quad:Quad = new Quad(100, 100);
		quad.rotation = MathUtil.deg2rad(400);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(40), E));
		quad.rotation = MathUtil.deg2rad(220);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(-140), E));
		quad.rotation = MathUtil.deg2rad(180);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(180), E));
		quad.rotation = MathUtil.deg2rad(-90);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(-90), E));
		quad.rotation = MathUtil.deg2rad(-179);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(-179), E));
		quad.rotation = MathUtil.deg2rad(-180);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(-180), E));
		quad.rotation = MathUtil.deg2rad(-181);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(179), E));
		quad.rotation = MathUtil.deg2rad(-300);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(60), E));
		quad.rotation = MathUtil.deg2rad(-370);
		Helpers.assertThat(quad.rotation, closeTo(MathUtil.deg2rad(-10), E));
	}
	
	
	public function testPivotPoint():Void
	{
		var width:Float = 100.0;
		var height:Float = 150.0;
		
		// a quad with a pivot point should behave exactly as a quad without 
		// pivot point inside a sprite
		
		var sprite:Sprite = new Sprite();
		var innerQuad:Quad = new Quad(width, height);
		sprite.addChild(innerQuad);            
		var quad:Quad = new Quad(width, height);            
		Helpers.compareRectangles(sprite.bounds, quad.bounds);
		
		innerQuad.x = -50;
		quad.pivotX = 50;            
		innerQuad.y = -20;
		quad.pivotY = 20;            
		Helpers.compareRectangles(sprite.bounds, quad.bounds);
		
		sprite.rotation = quad.rotation = MathUtil.deg2rad(45);
		Helpers.compareRectangles(sprite.bounds, quad.bounds);
		
		sprite.scaleX = quad.scaleX = 1.5;
		sprite.scaleY = quad.scaleY = 0.6;
		Helpers.compareRectangles(sprite.bounds, quad.bounds);
		
		sprite.x = quad.x = 5;
		sprite.y = quad.y = 20;
		Helpers.compareRectangles(sprite.bounds, quad.bounds);
	}
	
	
	public function testPivotWithSkew():Void
	{
		var width:Int = 200;
		var height:Int = 100;
		var skewX:Float = 0.2;
		var skewY:Float = 0.35;
		var scaleY:Float = 0.5;
		var rotation:Float = 0.5;
		
		// create a scaled, rotated and skewed object from a sprite and a quad
		
		var quad:Quad = new Quad(width, height);
		quad.x = width / -2;
		quad.y = height / -2;
		
		var sprite:Sprite = new Sprite();
		sprite.x = width / 2;
		sprite.y = height / 2;
		sprite.skewX = skewX;
		sprite.skewY = skewY;
		sprite.rotation = rotation;
		sprite.scaleY = scaleY;
		sprite.addChild(quad);
		
		// do the same without a sprite, but with a pivoted quad
		
		var pQuad:Quad = new Quad(width, height);
		pQuad.x = width / 2;
		pQuad.y = height / 2;
		pQuad.pivotX = width / 2;
		pQuad.pivotY = height / 2;
		pQuad.skewX = skewX;
		pQuad.skewY = skewY;
		pQuad.scaleY = scaleY;
		pQuad.rotation = rotation;
		
		// the bounds have to be the same
		
		Helpers.compareRectangles(sprite.bounds, pQuad.bounds, 1.0);
	}
	
	
	public function testAlignPivot():Void
	{
		var sprite:Sprite = new Sprite();
		var quad:Quad = new Quad(100, 50);
		quad.x = 200;
		quad.y = -100;
		sprite.addChild(quad);
		
		sprite.alignPivot();
		Helpers.assertThat(sprite.pivotX, closeTo(250, E));
		Helpers.assertThat(sprite.pivotY, closeTo(-75, E));

		sprite.alignPivot(Align.LEFT, Align.TOP);
		Helpers.assertThat(sprite.pivotX, closeTo(200, E));
		Helpers.assertThat(sprite.pivotY, closeTo(-100, E));

		sprite.alignPivot(Align.RIGHT, Align.BOTTOM);
		Helpers.assertThat(sprite.pivotX, closeTo(300, E));
		Helpers.assertThat(sprite.pivotY, closeTo(-50, E));

		sprite.alignPivot(Align.LEFT, Align.BOTTOM);
		Helpers.assertThat(sprite.pivotX, closeTo(200, E));
		Helpers.assertThat(sprite.pivotY, closeTo(-50, E));
	}
	
	
	public function testName():Void
	{
		var sprite:Sprite = new Sprite();
		Assert.isNull(sprite.name);
		
		sprite.name = "hugo";
		Assert.equals("hugo", sprite.name);
	}

	
	public function testUniformScale():Void
	{
		var sprite:Sprite = new Sprite();
		Helpers.assertThat(sprite.scale, closeTo(1.0, E));

		sprite.scaleY = 0.5;
		Helpers.assertThat(sprite.scale, closeTo(1.0, E));

		sprite.scaleX = 0.25;
		Helpers.assertThat(sprite.scale, closeTo(0.25, E));

		sprite.scale = 0.75;
		Helpers.assertThat(sprite.scaleX, closeTo(0.75, E));
		Helpers.assertThat(sprite.scaleY, closeTo(0.75, E));
	}

	
	public function testSetWidthNegativeAndBack():Void
	{
		// -> https://github.com/Gamua/Starling-Framework/issues/850

		var quad:Quad = new Quad(100, 100);

		quad.width = -10;
		quad.height = -10;

		Helpers.assertThat(quad.scaleX, closeTo(-0.1, E));
		Helpers.assertThat(quad.scaleY, closeTo(-0.1, E));

		quad.width = 100;
		quad.height = 100;

		Helpers.assertThat(quad.scaleX, closeTo(1.0, E));
		Helpers.assertThat(quad.scaleY, closeTo(1.0, E));
	}

	
	public function testSetWidthAndHeightToNaNAndBack():Void
	{
		var quad:Quad = new Quad(100, 200);

		quad.width  = Math.NaN;
		quad.height = Math.NaN;

		Assert.isTrue(Math.isNaN(quad.width));
		Assert.isTrue(Math.isNaN(quad.height));

		quad.width = 100;
		quad.height = 200;

		Helpers.assertThat(quad.width, closeTo(100, E));
		Helpers.assertThat(quad.height, closeTo(200, E));
	}

	
	public function testSetWidthAndHeightToVerySmallValueAndBack():Void
	{
		var sprite:Sprite = new Sprite();
		var quad:Quad = new Quad(100, 100);
		sprite.addChild(quad);
		sprite.x = sprite.y = 480;

		sprite.width = 2.842170943040401e-14;
		sprite.width = 100;

		sprite.height = 2.842170943040401e-14;
		sprite.height = 100;

		Helpers.assertThat(sprite.width, closeTo(100, E));
		Helpers.assertThat(sprite.height, closeTo(100, E));
	}
}
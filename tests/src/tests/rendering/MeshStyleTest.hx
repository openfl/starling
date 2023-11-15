// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.rendering;

import starling.display.Mesh;
import starling.display.Quad;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.styles.MeshStyle;
import tests.StarlingTest;
import utest.Assert;

class MeshStyleTest extends StarlingTest
{
	
	public function testAssignment():Void
	{
		var quad0:Quad = new Quad(100, 100);
		var quad1:Quad = new Quad(100, 100);
		var style:MeshStyle = new MeshStyle();
		var meshStyleType:Class<Dynamic> = (new MeshStyle()).type;

		quad0.style = style;
		Assert.equals(style, quad0.style);
		Assert.equals(style.target, quad0);

		quad1.style = style;
		Assert.equals(style, quad1.style);
		Assert.equals(style.target, quad1);
		Assert.isFalse(quad0.style == style);
		Assert.equals(quad0.style.type, meshStyleType);

		quad1.style = null;
		Assert.equals(quad1.style.type, meshStyleType);
		Assert.isNull(style.target);
	}

	
	public function testEnterFrameEvent():Void
	{
		var eventCount:Int = 0;

		function onEvent(event:EnterFrameEvent):Void
		{
			++eventCount;
		}

		var event:EnterFrameEvent = new EnterFrameEvent(Event.ENTER_FRAME, 0.1);
		var style:MeshStyle = new MeshStyle();
		var quad0:Quad = new Quad(100, 100);
		var quad1:Quad = new Quad(100, 100);

		style.addEventListener(Event.ENTER_FRAME, onEvent);
		quad0.dispatchEvent(event);
		Assert.equals(0, eventCount);

		quad0.style = style;
		quad0.dispatchEvent(event);
		Assert.equals(1, eventCount);

		quad0.dispatchEvent(event);
		Assert.equals(2, eventCount);

		quad1.style = style;
		quad0.dispatchEvent(event);
		Assert.equals(2, eventCount);

		quad0.style = style;
		quad0.dispatchEvent(event);
		Assert.equals(3, eventCount);

		style.removeEventListener(Event.ENTER_FRAME, onEvent);
		quad0.dispatchEvent(event);
		Assert.equals(3, eventCount);
	}

	
	public function testDefaultStyle():Void
	{
		var origStyle:Class<Dynamic> = Mesh.defaultStyle;
		var quad:Quad = new Quad(100, 100);
		Assert.isOfType(quad.style, origStyle);

		Mesh.defaultStyle = MockStyle;

		quad = new Quad(100, 100);
		Assert.isOfType(quad.style, MockStyle);

		Mesh.defaultStyle = origStyle;
	}

	
	public function testDefaultStyleFactory():Void
	{
		var quad:Quad;
		var origStyle:Class<Dynamic> = Mesh.defaultStyle;
		var origStyleFactory:?Mesh->MeshStyle = Mesh.defaultStyleFactory;

		Mesh.defaultStyleFactory = function(?mesh:Mesh):MeshStyle { return new MockStyle(); };
		quad = new Quad(100, 100);
		Assert.isOfType(quad.style, MockStyle);

		Mesh.defaultStyleFactory = function(?mesh:Mesh):MeshStyle { return null; };
		quad = new Quad(100, 100);
		Assert.isOfType(quad.style, origStyle);

		Mesh.defaultStyleFactory = null;
		quad = new Quad(100, 100);
		Assert.isOfType(quad.style, origStyle);

		Mesh.defaultStyle = origStyle;
		Mesh.defaultStyleFactory = origStyleFactory;
	}
}

class MockStyle extends MeshStyle {}
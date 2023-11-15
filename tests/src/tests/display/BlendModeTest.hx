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

import haxe.Constraints.Function;
import openfl.display3D.Context3DBlendFactor;
import org.hamcrest.Matchers.equalTo;
import starling.display.BlendMode;
import utest.Assert;
import utest.Test;

class BlendModeTest extends Test
{
	
	public function testRegisterBlendMode():Void
	{
		var name:String = "test";
		var srcFactor:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		var dstFactor:String = Context3DBlendFactor.DESTINATION_COLOR;
		
		BlendMode.register(name, srcFactor, dstFactor);

		Assert.equals(srcFactor, BlendMode.get(name).sourceFactor);
		Assert.equals(dstFactor, BlendMode.get(name).destinationFactor);
	}

	
	public function testGetAllBlendModes():Void
	{
		var name:String = "test";
		var srcFactor:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		var dstFactor:String = Context3DBlendFactor.DESTINATION_COLOR;

		BlendMode.register(name, srcFactor, dstFactor);

		var modeFilter:Function = function(modeName:String):BlendMode->Bool
		{
			return function(mode:BlendMode):Bool {
				return mode.name == modeName;
			};
		};

		var modes:Array<BlendMode> = BlendMode.getAll();
		Helpers.assertThat(modes.filter(modeFilter("test")).length, equalTo(1));
		Helpers.assertThat(modes.filter(modeFilter("normal")).length, equalTo(1));
	}
}
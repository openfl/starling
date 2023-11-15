// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import openfl.display.Sprite;
import utest.Runner;
import utest.ui.Report;

class TestMain extends Sprite {
	public function new() {
		super();

		var runner = new Runner();
		runner.addCase(new tests.animation.DelayedCallTest());
		runner.addCase(new tests.animation.JugglerTest());
		runner.addCase(new tests.animation.TweenTest());
		runner.addCase(new tests.display.BlendModeTest());
		runner.addCase(new tests.display.ButtonTest());
		runner.addCase(new tests.display.DisplayObjectContainerTest());
		runner.addCase(new tests.display.DisplayObjectTest());
		runner.addCase(new tests.display.ImageTest());
		runner.addCase(new tests.display.MeshTest());
		runner.addCase(new tests.display.MovieClipTest());
		runner.addCase(new tests.display.QuadTest());
		runner.addCase(new tests.display.Sprite3DTest());
		runner.addCase(new tests.events.EventTest());
		runner.addCase(new tests.filters.FilterChainTest());
		runner.addCase(new tests.filters.FragmentFilterTest());
		runner.addCase(new tests.geom.PolygonTest());
		runner.addCase(new tests.rendering.IndexDataTest());
		runner.addCase(new tests.rendering.MeshStyleTest());
		runner.addCase(new tests.rendering.VertexDataFormatTest());
		runner.addCase(new tests.rendering.VertexDataTest());
		runner.addCase(new tests.text.TextFieldTest());
		runner.addCase(new tests.textures.TextureAtlasTest());
		runner.addCase(new tests.textures.TextureTest());
		runner.addCase(new tests.utils.AssetManagerTest());
		runner.addCase(new tests.utils.ByteArrayUtilTest());
		runner.addCase(new tests.utils.ColorTest());
		runner.addCase(new tests.utils.MathUtilTest());
		runner.addCase(new tests.utils.MatrixUtilTest());
		runner.addCase(new tests.utils.RectangleUtilTest());
		runner.addCase(new tests.utils.StringUtilTest());
		runner.addCase(new tests.utils.UtilsTest());

		Report.create(runner);

		runner.run();
	}
}

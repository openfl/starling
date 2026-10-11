// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.styles;

import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display3D.Context3DProfile;
import openfl.geom.Rectangle;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.MeshBatch;
import starling.display.Quad;
import starling.display.Sprite;
import starling.rendering.MeshEffect;
import starling.rendering.Painter;
import starling.styles.MeshStyle;
import starling.styles.MultiTextureStyle;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MeshSubset;
import tests.StarlingTest;
import utest.Assert;

class MultiTextureStyleTest extends StarlingTest
{
	private static var COLORS:Array<UInt> = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00,
	                                         0xff00ff, 0x00ffff, 0xff8000, 0x8000ff,
	                                         0x800000, 0x008000, 0x000080, 0x808000,
	                                         0x800080, 0x008080, 0xff0080, 0x0080ff];
	private static inline var SIZE:Int = 16;

	private var _textures:Vector<Texture>;
	private var _maxTextures:Int;

	@:timeout(7500)
	override public function setup(async:utest.Async):Void
	{
		super.setup(async);
		_maxTextures = MultiTextureStyle.maxTextures;
	}

	override public function teardown():Void
	{
		if (_textures != null)
			for (texture in _textures) texture.dispose();
		_textures = null;
		MultiTextureStyle.maxTextures = _maxTextures;
		super.teardown();
	}

	// limits

	public function testMaxTexturesIsClamped():Void
	{
		new MultiTextureStyle(); // makes sure any profile-dependent limits are initialized

		MultiTextureStyle.maxTextures = 0;
		Assert.equals(1, MultiTextureStyle.maxTextures);

		MultiTextureStyle.maxTextures = MultiTextureStyle.MAX_NUM_TEXTURES + 1;
		Assert.equals(MultiTextureStyle.MAX_NUM_TEXTURES, MultiTextureStyle.maxTextures);
	}

	public function testAllTexturesFitDevice():Void
	{
		new MultiTextureStyle();
		MultiTextureStyle.maxTextures = MultiTextureStyle.MAX_NUM_TEXTURES;

		var count:Int = COLORS.length;
		var row:Sprite = new Sprite();
		var expected:Array<Null<Int>> = [];
		for (i in 0...count)
		{
			row.addChild(createImage(i, i));
			expected.push(i);
		}

		// a batch must never reference more textures than the profile and GPU support
		var limit:Int = getTextureLimit();

		var drawCount:Int = painter.drawCount;
		assertColors(row, expected, count + " textures");
		var expectedDrawCount:Int = Math.ceil(count / limit);
		var actual:Int = painter.drawCount - drawCount;
		Assert.equals(expectedDrawCount, actual, count + " textures (limit " + limit +
			"): expected " + expectedDrawCount + " draw calls, got " + actual);
	}

	#if flash
	@Ignored("OpenFL only: it samples the alpha of compressed textures from an extra unit")
	#end
	@:timeout(5000)
	public function testCompressedAlphaTextureInFullBatch(async:utest.Async):Void
	{
		// OpenFL samples the alpha channel of compressed textures from an extra texture unit,
		// which must fit within the GPU's limit, too
		var assets:starling.assets.AssetManager = new starling.assets.AssetManager();
		assets.verbose = false;
		assets.enqueue(["fixtures/image.atf"]);
		assets.loadQueue(function():Void
		{
			if (async.timedOut) return;

			new MultiTextureStyle();
			MultiTextureStyle.maxTextures = MultiTextureStyle.MAX_NUM_TEXTURES;

			var compressed:Texture = assets.getTexture("image");
			var limit:Int = getTextureLimit();
			var row:Sprite = new Sprite();
			var expected:Array<Null<Int>> = [null];
			row.addChild(createImageWithTexture(compressed, 0));
			for (i in 1...limit)
			{
				row.addChild(createImage(i, i));
				expected.push(i);
			}

			Assert.equals("compressedAlpha", Std.string(compressed.format));

			try assertColors(row, expected, "compressed texture with alpha + " + (limit - 1) + " textures")
			catch (e:Dynamic) Assert.fail("rendering failed: " + e);

			assets.purge();
			async.done();
		});
	}

	// batching

	public function testTextureOrderWithDifferentLimits():Void
	{
		var order:Array<Null<Int>> = [0, 1, 2, 3, 1, 0, 3, 2, 4, 5, 6, 7, 7, 0, 5];

		// draw calls needed for that order, indexed by the effective limit minus one
		var expectedDrawCounts:Array<Int> = [14, 7, 5, 3, 2, 2, 2, 1];

		new MultiTextureStyle();

		for (maxTextures in 1...MultiTextureStyle.MAX_NUM_TEXTURES + 1)
		{
			MultiTextureStyle.maxTextures = maxTextures;
			var row:Sprite = new Sprite();
			for (i in 0...order.length)
				row.addChild(createImage(order[i], i));

			var info:String = "max=" + maxTextures;
			var drawCount:Int = painter.drawCount;
			assertColors(row, order, info);

			var limit:Int = getTextureLimit();
			var expected:Int = expectedDrawCounts[(limit > 8 ? 8 : limit) - 1];
			var actual:Int = painter.drawCount - drawCount;
			Assert.equals(expected, actual, info + ": expected " + expected + " draw calls, got " + actual);
		}
	}

	public function testSubTexturesShareOneSlot():Void
	{
		MultiTextureStyle.maxTextures = 1;

		var atlas:BitmapData = new BitmapData(32, 8, false);
		for (i in 0...4) atlas.fillRect(new Rectangle(i * 8, 0, 8, 8), COLORS[i]);
		var root:Texture = Texture.fromBitmapData(atlas, false);

		var row:Sprite = new Sprite();
		for (i in 0...4)
			row.addChild(createImageWithTexture(Texture.fromTexture(root, new Rectangle(i * 8, 0, 8, 8)), i));

		var drawCount:Int = painter.drawCount;
		assertColors(row, [0, 1, 2, 3], "sub-textures");
		var actual:Int = painter.drawCount - drawCount;
		Assert.equals(1, actual, "4 sub-textures of one atlas: expected 1 draw call, got " + actual);

		root.dispose();
	}

	public function testDifferentSmoothingBreaksBatch():Void
	{
		MultiTextureStyle.maxTextures = 4;

		var sharp:Image = createImage(1, 1);
		sharp.textureSmoothing = TextureSmoothing.NONE;

		var row:Sprite = new Sprite();
		row.addChild(createImage(0, 0));
		row.addChild(sharp);
		row.addChild(createImage(2, 2));

		var drawCount:Int = painter.drawCount;
		assertColors(row, [0, 1, 2], "smoothing");
		var actual:Int = painter.drawCount - drawCount;
		Assert.equals(3, actual, "different smoothing in the middle: expected 3 draw calls, got " + actual);
	}

	public function testUntexturedQuadsInBetween():Void
	{
		MultiTextureStyle.maxTextures = 4;

		var row:Sprite = new Sprite();
		var expected:Array<Null<Int>> = [];
		for (i in 0...8)
		{
			if (i % 2 == 1) { row.addChild(createQuad(0xffffff, i)); expected.push(-1); }
			else { row.addChild(createImage(Std.int(i / 2) % 4, i)); expected.push(Std.int(i / 2) % 4); }
		}
		assertColors(row, expected, "quads");
	}

	public function testUntexturedQuadsShareDrawCall():Void
	{
		MultiTextureStyle.maxTextures = 4;

		var row:Sprite = new Sprite();
		for (i in 0...8)
		{
			if (i % 2 == 1) row.addChild(createQuad(0xffffff, i));
			else row.addChild(createImage(Std.int(i / 2) % 4, i));
		}

		var drawCount:Int = painter.drawCount;
		row.drawToBitmapData(null, 0x0, 1.0).dispose();
		var actual:Int = painter.drawCount - drawCount;
		Assert.equals(1, actual, "4 images + 4 untextured quads: expected 1 draw call, got " + actual);
	}

	public function testUntexturedQuadFirst():Void
	{
		MultiTextureStyle.maxTextures = 4;

		var row:Sprite = new Sprite();
		row.addChild(createQuad(0x8080ff, 0));
		row.addChild(createImage(0, 1));
		row.addChild(createImage(1, 2));
		row.addChild(createQuad(0x80ff80, 3));

		assertPixels(row, [0x8080ff, COLORS[0], COLORS[1], 0x80ff80], "untextured quad first");
	}

	// shader programs

	public function testProgramNamePerTextureVariant():Void
	{
		// Every combination of texture formats (incl. premultiplied alpha) needs its own shader,
		// so it must get its own program name; otherwise, batches reuse a wrong program.

		var variants:Array<{format:String, pma:Bool}> = [
			{ format: "bgra",            pma: true  },
			{ format: "bgra",            pma: false },
			{ format: "compressed",      pma: true  },
			{ format: "compressedAlpha", pma: true  }
		];

		var combinations:Array<Array<Int>> = [];

		// all combinations of up to four textures ...
		for (numTextures in 1...5)
		{
			var numVariantCombinations:Int = Std.int(Math.pow(variants.length, numTextures));
			for (code in 0...numVariantCombinations)
			{
				var combination:Array<Int> = [];
				var rest:Int = code;
				for (i in 0...numTextures)
				{
					combination.push(rest % variants.length);
					rest = Std.int(rest / variants.length);
				}
				combinations.push(combination);
			}
		}

		// ... and longer ones that differ only in their first or last texture
		for (numTextures in [8, 9, 12, 16])
			for (position in [0, numTextures - 1])
				for (variant in 0...variants.length)
					combinations.push([for (i in 0...numTextures) i == position ? variant : 0]);

		var combinationsByName:Map<String, String> = new Map();
		var collisions:Array<String> = [];

		for (combination in combinations)
		{
			var description:String = [for (v in combination)
				variants[v].format + (variants[v].pma ? "" : "(straight)")].join(", ");
			var name:String = getProgramName(combination, variants);
			var previous:String = combinationsByName.get(name);

			if (previous != null && previous != description)
				collisions.push("[" + previous + "] and [" + description + "]");

			combinationsByName.set(name, description);
		}

		Assert.equals(0, collisions.length, collisions.length + " of " + combinations.length +
			" texture combinations share a program with a different one, e.g. " +
			collisions.slice(0, 3).join("; "));
	}

	public function testProgramsForMixedPremultipliedAlpha():Void
	{
		MultiTextureStyle.maxTextures = 4;

		// opaque, so it looks the same whether or not its alpha is premultiplied
		var straightAlpha:Texture = Texture.empty(SIZE, SIZE, false, false, false, 1);
		straightAlpha.root.uploadBitmapData(new BitmapData(SIZE, SIZE, false, 0x808080));

		// first batch: three textures, the middle one with straight (non-premultiplied) alpha
		var rowA:Sprite = new Sprite();
		rowA.addChild(createImage(0, 0));
		rowA.addChild(createImageWithTexture(straightAlpha, 1));
		rowA.addChild(createImage(1, 2));
		assertPixels(rowA, [COLORS[0], 0x808080, COLORS[1]], "3 textures, mixed alpha");

		// second batch: four textures, all premultiplied; needs a different shader
		var rowB:Sprite = new Sprite();
		for (i in 0...4) rowB.addChild(createImage(i, i));
		assertColors(rowB, [0, 1, 2, 3], "4 textures after the mixed batch");

		straightAlpha.dispose();
	}

	// nested batches

	public function testNestedMeshBatch():Void
	{
		MultiTextureStyle.maxTextures = 4;

		// a batch that already references two textures, rendered next to other images
		var batch:MeshBatch = new MeshBatch();
		batch.style = new MultiTextureStyle();
		batch.batchable = true;
		batch.addMesh(createImage(2, 2));
		batch.addMesh(createImage(3, 3));

		var row:Sprite = new Sprite();
		row.addChild(createImage(0, 0));
		row.addChild(createImage(1, 1));
		row.addChild(batch);
		row.addChild(createImage(3, 4));
		row.addChild(createImage(2, 5));

		assertColors(row, [0, 1, 2, 3, 3, 2], "nested (first frame)");
		assertColors(row, [0, 1, 2, 3, 3, 2], "nested (second frame)");
	}

	public function testMeshBatchAddedToMeshBatch():Void
	{
		MultiTextureStyle.maxTextures = 4;

		var inner:MeshBatch = new MeshBatch();
		inner.style = new MultiTextureStyle();
		inner.addMesh(createImage(2, 0));
		inner.addMesh(createImage(3, 1));
		inner.x = 2 * SIZE;

		var outer:MeshBatch = new MeshBatch();
		outer.style = new MultiTextureStyle();
		outer.addMesh(createImage(0, 0));
		outer.addMesh(createImage(1, 1));
		outer.addMesh(inner); // with its transformation matrix

		assertColors(outer, [0, 1, 2, 3], "batch in batch");
	}

	public function testSubsetOfBatch():Void
	{
		MultiTextureStyle.maxTextures = 4;

		// the render cache adds subsets of the previous frame's batches, without transformation
		var source:MeshBatch = new MeshBatch();
		source.style = new MultiTextureStyle();
		for (i in 0...4) source.addMesh(createImage(i, i));

		var target:MeshBatch = new MeshBatch();
		target.style = new MultiTextureStyle();
		target.addMesh(createImage(3, 0));
		target.addMesh(source, null, 1.0, new MeshSubset(8, 8, 12, 12), true);

		assertColors(target, [3, null, 2, 3], "subset");
	}

	// textures

	public function testTextureRemovedFromQuad():Void
	{
		var quad:Quad = createQuad(0xffffff, 0);
		quad.texture = getTexture(0);
		quad.texture = null;
		assertColors(quad, [-1], "texture removed");
	}

	public function testTextureReplacedOnQuad():Void
	{
		var quad:Quad = createQuad(0xffffff, 0);
		quad.texture = getTexture(0);
		quad.texture = getTexture(1);
		assertColors(quad, [1], "texture replaced");
	}

	// rendering

	public function testMatchesStandardRendering():Void
	{
		// rotated, tinted and translucent, so texture coordinates and vertex colors must be right
		// too; the reference is the same scene drawn with the standard MeshStyle

		new MultiTextureStyle();
		MultiTextureStyle.maxTextures = MultiTextureStyle.MAX_NUM_TEXTURES;

		var striped:Array<Texture> = [for (i in 0...8) createStripedTexture(COLORS[i])];
		var actual:BitmapData = drawScene(striped, function() return new MultiTextureStyle());
		var expected:BitmapData = drawScene(striped, function() return new MeshStyle());

		var maxDifference:Int = 0;
		var numDifferentPixels:Int = 0;
		var firstDifference:String = "";

		for (y in 0...expected.height)
		{
			for (x in 0...expected.width)
			{
				var a:UInt = actual.getPixel32(x, y);
				var b:UInt = expected.getPixel32(x, y);
				var difference:Int = 0;

				for (shift in [0, 8, 16, 24])
				{
					var channelDifference:Int = Std.int(Math.abs(((a >> shift) & 0xff) - ((b >> shift) & 0xff)));
					if (channelDifference > difference) difference = channelDifference;
				}

				if (difference > 2)
				{
					if (numDifferentPixels == 0)
						firstDifference = " (first at " + x + "x" + y + ": expected " +
							StringTools.hex(b, 8) + ", got " + StringTools.hex(a, 8) + ")";
					numDifferentPixels++;
				}
				if (difference > maxDifference) maxDifference = difference;
			}
		}

		Assert.equals(0, numDifferentPixels, numDifferentPixels + " pixels differ from the " +
			"MeshStyle rendering by more than 2, at most by " + maxDifference + firstDifference);

		actual.dispose();
		expected.dispose();
		for (texture in striped) texture.dispose();
	}

	// helpers

	private var painter(get, never):Painter;
	private function get_painter():Painter { return Starling.current.painter; }

	// created on first use: the context doesn't exist yet while 'setup' runs
	private function getTexture(index:Int):Texture
	{
		if (_textures == null)
		{
			_textures = new Vector<Texture>();
			for (i in 0...COLORS.length)
			{
				var bitmap:BitmapData = new BitmapData(4 + i % 4, 12 - i % 4, false, COLORS[i]);
				_textures.push(Texture.fromBitmapData(bitmap, false));
			}
		}
		return _textures[index];
	}

	// The number of textures a batch may reference: 'maxTextures', limited by the profile
	// (four in "baselineConstrained", eight in the other baseline profiles) and the GPU.
	private function getTextureLimit():Int
	{
		var profile:Context3DProfile = Starling.current.profile;
		var profileLimit:Int = 16;
		if (profile == Context3DProfile.BASELINE_CONSTRAINED) profileLimit = 4;
		else if (profile == Context3DProfile.BASELINE || profile == Context3DProfile.BASELINE_EXTENDED) profileLimit = 8;

		var limit:Int = MultiTextureStyle.maxTextures;
		var deviceLimit:Int = getDeviceTextureUnits();
		if (profileLimit < limit) limit = profileLimit;
		if (deviceLimit < limit) limit = deviceLimit;
		return limit;
	}

	private function getDeviceTextureUnits():Int
	{
		#if (lime && !flash)
		var gl = @:privateAccess Starling.current.context.gl;
		return gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
		#else
		return 16;
		#end
	}

	// The name of the program a batch with textures of the given variants would use.
	// Mock textures suffice: the name only depends on their format and alpha mode.
	private function getProgramName(combination:Array<Int>, variants:Array<{format:String, pma:Bool}>):String
	{
		var batch:MeshBatch = new MeshBatch();
		batch.style = new MultiTextureStyle();

		var textures:Array<Texture> = [];
		for (variant in combination)
		{
			var texture:Texture = new VariantTexture(variants[variant].format, variants[variant].pma);
			var quad:Quad = new Quad(SIZE, SIZE);
			quad.style = new MultiTextureStyle();
			quad.texture = texture;
			batch.addMesh(quad);
			textures.push(texture);
		}

		var effect:MeshEffect = batch.style.createEffect();
		batch.style.updateEffect(effect, painter.state);
		var name:String = effect.programName;

		effect.dispose();
		batch.dispose();
		for (texture in textures) texture.dispose();
		return name;
	}

	// Power-of-two size, so that bilinear filtering doesn't pull in any padding.
	private function createStripedTexture(color:UInt):Texture
	{
		var bitmap:BitmapData = new BitmapData(32, 32, false, 0xffffff);
		var y:Int = 0;
		while (y < 32)
		{
			bitmap.fillRect(new Rectangle(0, y, 32, 4), color);
			y += 8;
		}
		return Texture.fromBitmapData(bitmap, false);
	}

	private function drawScene(textures:Array<Texture>, createStyle:Void->MeshStyle):BitmapData
	{
		var size:Int = 128;
		var cellSize:Int = Std.int(size / 4);
		var canvas:Sprite = new Sprite();

		var background:Quad = new Quad(size, size, 0x303030);
		background.style = createStyle();
		canvas.addChild(background);

		for (i in 0...textures.length)
		{
			var image:Image = new Image(textures[i]);
			image.style = createStyle();
			image.alignPivot();
			image.scale = 0.75;
			image.rotation = (i - 4) * Math.PI / 16;
			image.x = (i % 4 + 0.5) * cellSize;
			image.y = (Std.int(i / 4) + 0.5) * cellSize;
			if (i == 5) image.color = 0x808080;
			if (i == 6) image.alpha = 0.5;
			canvas.addChild(image);
		}

		var quad:Quad = new Quad(size - 16, cellSize / 2, 0x8080ff);
		quad.style = createStyle();
		quad.x = 8;
		quad.y = 2.25 * cellSize;
		canvas.addChild(quad);

		var bitmap:BitmapData = canvas.drawToBitmapData(null, 0x0, 1.0);
		canvas.dispose();
		return bitmap;
	}

	private function createImage(textureIndex:Int, slot:Int):Image
	{
		return createImageWithTexture(getTexture(textureIndex), slot);
	}

	private function createImageWithTexture(texture:Texture, slot:Int):Image
	{
		var image:Image = new Image(texture);
		image.style = new MultiTextureStyle();
		image.width = image.height = SIZE;
		image.x = slot * SIZE;
		return image;
	}

	private function createQuad(color:UInt, slot:Int):Quad
	{
		var quad:Quad = new Quad(SIZE, SIZE, color);
		quad.style = new MultiTextureStyle();
		quad.x = slot * SIZE;
		return quad;
	}

	// Checks the center pixel of each slot: a texture index, -1 for white, or null to skip.
	private function assertColors(object:DisplayObject, textureIndices:Array<Null<Int>>, info:String):Void
	{
		assertPixels(object, [for (index in textureIndices)
			index == null ? null : (index < 0 ? 0xffffff : COLORS[index])], info);
	}

	// Checks the center pixel of each slot against the given color, or skips it if it's null.
	private function assertPixels(object:DisplayObject, colors:Array<Null<UInt>>, info:String):Void
	{
		var bitmap:BitmapData = object.drawToBitmapData(null, 0x0, 1.0);
		for (i in 0...colors.length)
		{
			var expected:Null<UInt> = colors[i];
			if (expected == null) continue;

			var actual:UInt = bitmap.getPixel(i * SIZE + Std.int(SIZE / 2), Std.int(SIZE / 2));
			Assert.isTrue(actual == expected, info + ", slot " + i + ": expected " +
				StringTools.hex(expected, 6) + ", got " + StringTools.hex(actual, 6));
		}
		bitmap.dispose();
	}
}

// A texture without GPU data, in any format; enough for everything but rendering.
private class VariantTexture extends ConcreteTexture
{
	public function new(format:String, premultipliedAlpha:Bool)
	{
		super(null, format, 16, 16, false, premultipliedAlpha, false, 1);
	}
}

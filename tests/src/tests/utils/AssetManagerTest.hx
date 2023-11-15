// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.utils;

import openfl.media.Sound;
import openfl.utils.ByteArray;
import starling.assets.AssetManager;
import starling.events.Event;
import starling.textures.TextureAtlas;
import tests.StarlingTest;
import utest.Assert;
import utest.Async;

class AssetManagerTest extends StarlingTest
{
	private var _manager:TestAssetManager;
	
	@:timeout(7500)
	override public function setup(async:Async):Void
	{
		super.setup(async);
		_manager = new TestAssetManager();
		_manager.verbose = false;
	}
	
	override public function teardown():Void
	{
		_manager.purge();
		_manager = null;
		super.teardown();
	}
	
	@:timeout(1000)
	public function testLoadEmptyQueue(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.pass();
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadBitmapFromPngFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/image.png"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getTextures("image").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadBitmapFromJpgFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/image.jpg"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getTextures("image").length);
			async.done();
		}, onError);
	}
	
	#if !flash
	@Ignored
	#end
	@:timeout(1000)
	public function testLoadBitmapFromGifFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/image.gif"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getTextures("image").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadXmlFromFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/xml.xml"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getXmlNames("xml").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadInvalidXmlFromFile(async:Async):Void
	{
		var errorCount:Int = 0;

		function onComplete():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(1, errorCount);
			async.done();
		}

		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/invalid.xml"]);
		_manager.loadQueue(onComplete, onError);
	}
	
	@:timeout(1000)
	public function testLoadJsonFromFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/json.json"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getObjectNames("json").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadInvalidJsonFromFile(async:Async):Void
	{
		var errorCount:Int=0;

		function onComplete():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(1, errorCount);
			async.done();
		}

		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/invalid.json"]);
		_manager.loadQueue(onComplete, onError);
	}
	
	@:timeout(1000)
	public function testLoadSoundFromMp3File(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/audio.mp3"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getSoundNames("audio").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadTextureAtlasFromFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/atlas.xml"]);
		_manager.enqueueSingle("fixtures/image.png", "atlas");
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getTextureAtlasNames("atlas").length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadFontFromFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/font.xml"]);
		_manager.enqueueSingle("fixtures/image.png", "font");
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getBitmapFontNames().length);
			async.done();
		}, onError);
	}
	
	@:timeout(1000)
	public function testLoadByteArrayFromFile(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/data.txt"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			var bytes:ByteArray = _manager.getByteArray("data");
			Assert.notNull(bytes);
			Assert.equals("data", bytes.readUTFBytes(bytes.length));
			async.done();
		}, onError);
	}

	// @:timeout(1000)
	// public function testLoadXmlFromByteArray(async:Async):Void
	// {
	// 	_manager.verbose = true;
	// 	_manager.enqueue(EmbeddedXml);
	// 	_manager.loadQueue(function():Void
	// 	{
	// 		if (async.timedOut) {
	// 			return;
	// 		}
	// 		Assert.equals(1, _manager.getXmlNames("Data").length);
	// 		async.done();
	// 	});
	// }
	
	// @:timeout(1000)
	// public function testLoadJsonFromByteArray(async:Async):Void
	// {
	// 	_manager.verbose = true;
	// 	_manager.enqueue(EmbeddedJson);
	// 	_manager.loadQueue(function():Void
	// 	{
	// 		if (async.timedOut) {
	// 			return;
	// 		}
	// 		Assert.equals(1, _manager.getObjectNames("Data").length);
	// 		async.done();
	// 	});
	// }

	#if flash
	// this is the one target where it _should_ work
	@Ignored
	#end
	@:timeout(1000)
	public function testLoadAtfFromByteArray(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/image.atf"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.equals(1, _manager.getTextures("image").length);
			async.done();
		}, onError);
	}

	public function testPurgeQueue():Void
	{
		var cancelled = false;
		_manager.addEventListener(Event.CANCEL, function(event:Event):Void
		{
			cancelled = true;
		});
		Assert.isFalse(cancelled);
		_manager.purgeQueue();
		Assert.isTrue(cancelled);
		Assert.equals(0, _manager.numQueuedAssets);
	}
	
	public function testTextureAsset():Void
	{
		var NAME:String = "test_texture";
		var texture:MockTexture = new MockTexture();
		
		_manager.addAsset(NAME, texture);
		Assert.equals(texture, _manager.getTexture(NAME));
		Assert.equals(1, _manager.getTextures(NAME).length);
		Assert.equals(1, _manager.getTextureNames(NAME).length);
		Assert.equals(NAME, _manager.getTextureNames(NAME)[0]);
		
		_manager.removeTexture(NAME);
		Assert.isNull(_manager.getTexture(NAME));
		Assert.equals(0, _manager.getTextures(NAME).length);
		Assert.equals(0, _manager.getTextureNames(NAME).length);
	}
	
	
	public function testTextureAtlasAsset():Void
	{
		var NAME:String = "test_textureAtlas";
		var atlas:TextureAtlas = new TextureAtlas(null);
		
		_manager.addAsset(NAME, atlas);
		Assert.equals(atlas, _manager.getTextureAtlas(NAME));
		Assert.equals(1, _manager.getTextureAtlasNames(NAME).length);
		Assert.equals(NAME, _manager.getTextureAtlasNames(NAME)[0]);
		
		_manager.removeTextureAtlas(NAME, false);// do not dispose, it holds no real texture
		Assert.isNull(_manager.getTextureAtlas(NAME));
		Assert.equals(0, _manager.getTextureAtlasNames(NAME).length);
	}
	
	
	public function testSoundAsset():Void
	{
		var NAME:String = "test_sound";
		var sound:Sound = new Sound();
		
		_manager.addAsset(NAME, sound);
		Assert.equals(sound, _manager.getSound(NAME));
		Assert.equals(1, _manager.getSoundNames(NAME).length);
		Assert.equals(NAME, _manager.getSoundNames(NAME)[0]);
		
		_manager.removeSound(NAME);
		Assert.isNull(_manager.getSound(NAME));
		Assert.equals(0, _manager.getSoundNames(NAME).length);
	}
	
	
	public function textPlayUndefinedSound():Void
	{
		Assert.isNull(_manager.playSound("undefined"));
	}
	
	
	public function testXmlAsset():Void
	{
		var NAME:String = "test_xml";
		var xml:Xml = Xml.parse("<test/>");
		
		_manager.addAsset(NAME, xml);
		Assert.equals(xml, _manager.getXml(NAME));
		Assert.equals(1, _manager.getXmlNames(NAME).length);
		Assert.equals(NAME, _manager.getXmlNames(NAME)[0]);
		
		_manager.removeXml(NAME);
		Assert.isNull(_manager.getXml(NAME));
		Assert.equals(0, _manager.getXmlNames(NAME).length);
	}
	
	
	public function testObjectAsset():Void
	{
		var NAME:String = "test_object";
		var object:Dynamic = {};
		
		_manager.addAsset(NAME, object);
		Assert.equals(object, _manager.getObject(NAME));
		Assert.equals(1, _manager.getObjectNames(NAME).length);
		Assert.equals(NAME, _manager.getObjectNames(NAME)[0]);
		
		_manager.removeObject(NAME);
		Assert.isNull(_manager.getObject(NAME));
		Assert.equals(0, _manager.getObjectNames(NAME).length);
	}
	
	
	public function testByteArrayAsset():Void
	{
		var NAME:String = "test_bytearray";
		var bytes:ByteArray = new ByteArray();
		
		_manager.addAsset(NAME, bytes);
		Assert.equals(bytes, _manager.getByteArray(NAME));
		Assert.equals(1, _manager.getByteArrayNames(NAME).length);
		Assert.equals(NAME, _manager.getByteArrayNames(NAME)[0]);
		
		_manager.removeByteArray(NAME);
		Assert.isNull(_manager.getByteArray(NAME));
		Assert.equals(0, _manager.getByteArrayNames(NAME).length);
	}

	
	public function testGetBasenameFromUrl():Void
	{
		Assert.equals("a", _manager.__getNameFromUrl("a"));
		Assert.equals("image", _manager.__getNameFromUrl("image.png"));
		Assert.equals("image", _manager.__getNameFromUrl("http://example.com/dir/image.png"));
		Assert.equals(null, _manager.__getNameFromUrl("http://example.com/dir/image/"));
	}
	
	
	public function testGetExtensionFromUrl():Void
	{
		Assert.equals("png", _manager.__getExtensionFromUrl("image.png"));
		Assert.equals("png", _manager.__getExtensionFromUrl("http://example.com/dir/image.png"));
		Assert.equals("", _manager.__getExtensionFromUrl("http://example.com/dir/image/"));
	}
	
	
	public function testEnqueueWithName():Void
	{
		_manager.enqueueSingle("a", "b");
		Assert.equals(1, _manager.numQueuedAssets);
	}
	
	
	public function testEnqueueString():Void
	{
		_manager.enqueue(["a"]);
		Assert.equals(1, _manager.numQueuedAssets);
	}
	
	
	public function testEnqueueArray():Void
	{
		_manager.enqueue([["a", "b"]]);
		Assert.equals(2, _manager.numQueuedAssets);
	}
	
	
	// public function testEnqueueClass():Void
	// {
	// 	_manager.enqueue(EmbeddedBitmap);
	// 	Assert.equals(1, _manager.numQueuedAssets);
	// }
	
	
	public function testEnqueueUnsupportedType():Void
	{
		_manager.enqueue([{}]);
		Assert.equals(0, _manager.numQueuedAssets);
	}

	
	public function testAddSameTextureTwice():Void
	{
		var texture:MockTexture = new MockTexture();
		var name:String = "mock";

		_manager.addAsset(name, texture);
		_manager.addAsset(name, texture);

		Assert.isFalse(texture.isDisposed);
	}

	@:timeout(1000)
	public function testDequeueAsset(async:Async):Void
	{
		var errorCount:Int = 0;
		function onError(error:String):Void { ++errorCount; }

		_manager.enqueue(["fixtures/image.png"]);
		_manager.enqueue(["fixtures/json.json"]);
		_manager.enqueue(["fixtures/data.txt"]);
		_manager.enqueue(["fixtures/xml.xml"]);
		_manager.dequeue(["data", "xml"]);
		_manager.loadQueue(function():Void
		{
			if (async.timedOut) {
				return;
			}
			Assert.equals(0, errorCount);
			Assert.notNull(_manager.getTextures("image"));
			Assert.isNull(_manager.getByteArray("data"));
			Assert.notNull(_manager.getObject("json"));
			Assert.isNull(_manager.getObject("xml"));
			async.done();
		}, onError);
	}
}

private class TestAssetManager extends AssetManager
{
	public function __getNameFromUrl(url:String):String
	{
		return getNameFromUrl(url);
	}

	public function __getExtensionFromUrl(url:String):String
	{
		return getExtensionFromUrl(url);
	}
}

/*
class EmbeddedBitmap
{
[Embed(source="../../../fixtures/image.png")]
public static const Image:Class;
}

class EmbeddedXml
{
[Embed(source="../../../fixtures/xml.xml", mimeType="application/octet-stream")]
public static const Data:Class;
}

class EmbeddedJson
{
[Embed(source="../../../fixtures/json.json", mimeType="application/octet-stream")]
public static const Data:Class;
}
*/
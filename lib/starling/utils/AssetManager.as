package starling.utils {

	import openfl.media.Sound;
	import openfl.media.SoundTransform;
	import openfl.utils.ByteArray;
	import openfl.Vector;
	import starling.events.EventDispatcher;
	// import starling.utils.ArrayUtil;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.AtfData;
	import starling.textures.TextureOptions;
	
	// @:meta(Event(name = "texturesRestored", type = "starling.events.Event")) @:meta(Event(name = "ioError", type = "starling.events.Event")) @:meta(Event(name = "securityError", type = "starling.events.Event")) @:meta(Event(name = "parseError", type = "starling.events.Event"))
	
	/**
	 * @externs
	 */
	public class AssetManager extends starling.events.EventDispatcher {
		public var checkPolicyFile:Boolean;
		public var forcePotTextures:Boolean;
		public function get isLoading():Boolean { return false; }
		public var keepAtlasXmls:Boolean;
		public var keepFontXmls:Boolean;
		public function get numQueuedAssets():int { return 0; }
		public var numConnections:int;
		public var scaleFactor:Number;
		public var textureFormat:String;
		public var useMipMaps:Boolean;
		public var verbose:Boolean;
		public function AssetManager(scaleFactor:Number = 0, useMipmaps:Boolean = false):void {}
		public function addByteArray(name:String, byteArray:openfl.utils.ByteArray):void {}
		public function addObject(name:String, object:Object):void {}
		public function addSound(name:String, sound:openfl.media.Sound):void {}
		public function addTexture(name:String, texture:starling.textures.Texture):void {}
		public function addTextureAtlas(name:String, atlas:starling.textures.TextureAtlas):void {}
		public function addXml(name:String, xml:Object):void {}
		public function dispose():void {}
		public function enqueue(rawAssets:Array):void {}
		public function enqueueWithName(asset:Object, name:String = null, options:starling.textures.TextureOptions = null):String { return null; }
		public function getByteArray(name:String):openfl.utils.ByteArray { return null; }
		public function getByteArrayNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getObject(name:String):Object { return null; }
		public function getObjectNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getSound(name:String):openfl.media.Sound { return null; }
		public function getSoundNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getTexture(name:String):starling.textures.Texture { return null; }
		public function getTextureAtlas(name:String):starling.textures.TextureAtlas { return null; }
		public function getTextureAtlasNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getTextureNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getTextures(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function getXml(name:String):Object { return null; }
		public function getXmlNames(prefix:String = null, out:openfl.Vector = null):openfl.Vector { return null; }
		public function loadQueue(onProgress:Function):void {}
		public function playSound(name:String, startTime:Number = 0, loops:int = 0, transform:openfl.media.SoundTransform = null):openfl.media.SoundChannel { return null; }
		public function purge():void {}
		public function purgeQueue():void {}
		public function removeByteArray(name:String, dispose:Boolean = false):void {}
		public function removeObject(name:String):void {}
		public function removeSound(name:String):void {}
		public function removeTexture(name:String, dispose:Boolean = false):void {}
		public function removeTextureAtlas(name:String, dispose:Boolean = false):void {}
		public function removeXml(name:String, dispose:Boolean = false):void {}
	}

}
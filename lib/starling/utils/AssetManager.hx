package starling.utils;

import starling.events.EventDispatcher;
// import starling.utils.ArrayUtil;
import haxe.ds.StringMap;
import Std;
import Type;
import starling.core.Starling;
import haxe.Timer;
import starling.textures.TextureAtlas;
import starling.text.TextField;
import starling.text.BitmapFont;
import Xml;
import starling.textures.Texture;
import js.Boot;
import starling.textures.AtfData;
import EReg;
import haxe.Log;
import HxOverrides;
import starling.textures.TextureOptions;

@:jsRequire("starling/utils/AssetManager", "default")

@:meta(Event(name = "texturesRestored", type = "starling.events.Event")) @:meta(Event(name = "ioError", type = "starling.events.Event")) @:meta(Event(name = "securityError", type = "starling.events.Event")) @:meta(Event(name = "parseError", type = "starling.events.Event")) extern class AssetManager extends starling.events.EventDispatcher {
	var checkPolicyFile(get,set) : Bool;
	var forcePotTextures(get,set) : Bool;
	var isLoading(get,never) : Bool;
	var keepAtlasXmls(get,set) : Bool;
	var keepFontXmls(get,set) : Bool;
	var nu__queuedAssets(get,never) : Int;
	var numConnections(get,set) : Int;
	var scaleFactor(get,set) : Float;
	var textureFormat(get,set) : openfl.display3D.Context3DTextureFormat;
	var useMipMaps(get,set) : Bool;
	var verbose(get,set) : Bool;
	function new(scaleFactor : Float = 0, useMipmaps : Bool = false) : Void;
	function addByteArray(name : String, byteArray : openfl.utils.ByteArray) : Void;
	function addObject(name : String, object : Dynamic) : Void;
	function addSound(name : String, sound : openfl.media.Sound) : Void;
	function addTexture(name : String, texture : starling.textures.Texture) : Void;
	function addTextureAtlas(name : String, atlas : starling.textures.TextureAtlas) : Void;
	function addXml(name : String, xml : Xml) : Void;
	function dispose() : Void;
	function enqueue(rawAssets : Array<Dynamic>) : Void;
	function enqueueWithName(asset : Dynamic, ?name : String, ?options : starling.textures.TextureOptions) : String;
	function getByteArray(name : String) : openfl.utils.ByteArray;
	function getByteArrayNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function getObject(name : String) : Dynamic;
	function getObjectNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function getSound(name : String) : openfl.media.Sound;
	function getSoundNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function getTexture(name : String) : starling.textures.Texture;
	function getTextureAtlas(name : String) : starling.textures.TextureAtlas;
	function getTextureAtlasNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function getTextureNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function getTextures(?prefix : String, ?out : openfl.Vector<starling.textures.Texture>) : openfl.Vector<starling.textures.Texture>;
	function getXml(name : String) : Xml;
	function getXmlNames(?prefix : String, ?out : openfl.Vector<String>) : openfl.Vector<String>;
	function loadQueue(onProgress : Float -> Void) : Void;
	function playSound(name : String, startTime : Float = 0, loops : Int = 0, ?transform : openfl.media.SoundTransform) : openfl.media.SoundChannel;
	function purge() : Void;
	function purgeQueue() : Void;
	function removeByteArray(name : String, dispose : Bool = false) : Void;
	function removeObject(name : String) : Void;
	function removeSound(name : String) : Void;
	function removeTexture(name : String, dispose : Bool = false) : Void;
	function removeTextureAtlas(name : String, dispose : Bool = false) : Void;
	function removeXml(name : String, dispose : Bool = false) : Void;
}

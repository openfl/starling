// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import haxe.Constraints.Function;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
#if flash
import flash.net.FileReference;
#end
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
#if flash
import flash.system.ImageDecodingPolicy;
#end
import openfl.system.LoaderContext;
import openfl.system.System;
import openfl.utils.ByteArray;

import haxe.Json;
import haxe.Timer;

import openfl.utils.ByteArray;
import openfl.Vector;

import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.AtfData;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.textures.TextureOptions;

/** Dispatched when all textures have been restored after a context loss. */
@:meta(Event(name="texturesRestored", type="starling.events.Event"))

/** Dispatched when an URLLoader fails with an IO_ERROR while processing the queue.
 *  The 'data' property of the Event contains the URL-String that could not be loaded. */
@:meta(Event(name="ioError", type="starling.events.Event"))

/** Dispatched when an URLLoader fails with a SECURITY_ERROR while processing the queue.
 *  The 'data' property of the Event contains the URL-String that could not be loaded. */
@:meta(Event(name="securityError", type="starling.events.Event"))

/** Dispatched when an XML or JSON file couldn't be parsed.
 *  The 'data' property of the Event contains the name of the asset that could not be parsed. */
@:meta(Event(name="parseError", type="starling.events.Event"))

/** The AssetManager handles loading and accessing a variety of asset types. You can 
 *  add assets directly (via the 'add...' methods) or asynchronously via a queue. This allows
 *  you to deal with assets in a unified way, no matter if they are loaded from a file, 
 *  directory, URL, or from an embedded object.
 *  
 *  <p>The class can deal with the following media types:
 *  <ul>
 *    <li>Textures, either from Bitmaps or ATF data</li>
 *    <li>Texture atlases</li>
 *    <li>Bitmap Fonts</li>
 *    <li>Sounds</li>
 *    <li>XML data</li>
 *    <li>JSON data</li>
 *    <li>ByteArrays</li>
 *  </ul>
 *  </p>
 *  
 *  <p>For more information on how to add assets from different sources, read the documentation
 *  of the "enqueue()" method.</p>
 * 
 *  <strong>Context Loss</strong>
 *  
 *  <p>When the stage3D context is lost (and you have enabled 'Starling.handleLostContext'),
 *  the AssetManager will automatically restore all loaded textures. To save memory, it will
 *  get them from their original sources. Since this is done asynchronously, your images might
 *  not reappear all at once, but during a timeframe of several seconds. If you want, you can
 *  pause your game during that time; the AssetManager dispatches an "Event.TEXTURES_RESTORED"
 *  event when all textures have been restored.</p>
 *
 *  <strong>Error handling</strong>
 *
 *  <p>Loading of some assets may fail while the queue is being processed. In that case, the
 *  AssetManager will dispatch events of type "IO_ERROR", "SECURITY_ERROR" or "PARSE_ERROR".
 *  You can listen to those events and handle the errors manually (e.g., you could enqueue
 *  them once again and retry, or provide placeholder textures). Queue processing will
 *  continue even when those events are dispatched.</p>
 *
 *  <strong>Using variable texture formats</strong>
 *
 *  <p>When you enqueue a texture, its properties for "format", "scale", "mipMapping", and
 *  "repeat" will reflect the settings of the AssetManager at the time they were enqueued.
 *  This means that you can enqueue a bunch of textures, then change the settings and enqueue
 *  some more. Like this:</p>
 *
 *  <listing>
 *  var appDir:File = File.applicationDirectory;
 *  var assets:AssetManager = new AssetManager();
 *  
 *  assets.textureFormat = Context3DTextureFormat.BGRA;
 *  assets.enqueue(appDir.resolvePath("textures/32bit"));
 *  
 *  assets.textureFormat = Context3DTextureFormat.BGRA_PACKED;
 *  assets.enqueue(appDir.resolvePath("textures/16bit"));
 *  
 *  assets.loadQueue(...);</listing>
 */

@:jsRequire("starling/utils/AssetManager", "default")

extern class AssetManager extends EventDispatcher
{
    /** Create a new AssetManager. The 'scaleFactor' and 'useMipmaps' parameters define
     * how enqueued bitmaps will be converted to textures. */
    public function new(scaleFactor:Float=1, useMipmaps:Bool=false);
    
    /** Disposes all contained textures, XMLs and ByteArrays.
     *
     * <p>Beware that all references to the assets will remain intact, even though the assets
     * are no longer valid. Call 'purge' if you want to remove all resources and reuse
     * the AssetManager later.</p>
     */
    public function dispose():Void;
    
    // retrieving
    
    /** Returns a texture with a certain name. The method first looks through the directly
     * added textures; if no texture with that name is found, it scans through all 
     * texture atlases. */
    public function getTexture(name:String):Texture;
    
    /** Returns all textures that start with a certain string, sorted alphabetically
     * (especially useful for "MovieClip"). */
    public function getTextures(prefix:String="", out:Vector<Texture>=null):Vector<Texture>;
    
    /** Returns all texture names that start with a certain string, sorted alphabetically. */
    public function getTextureNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    /** Returns a texture atlas with a certain name, or null if it's not found. */
    public function getTextureAtlas(name:String):TextureAtlas;

    /** Returns all texture atlas names that start with a certain string, sorted alphabetically.
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getTextureAtlasNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    /** Returns a sound with a certain name, or null if it's not found. */
    public function getSound(name:String):Sound;
    
    /** Returns all sound names that start with a certain string, sorted alphabetically.
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getSoundNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    /** Generates a new SoundChannel object to play back the sound. This method returns a 
     * SoundChannel object, which you can access to stop the sound and to control volume. */ 
    public function playSound(name:String, startTime:Float=0, loops:Int=0, 
                              transform:SoundTransform=null):SoundChannel;
    
    /** Returns an XML with a certain name, or null if it's not found. */
    public function getXml(name:String):Xml;
    
    /** Returns all XML names that start with a certain string, sorted alphabetically. 
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getXmlNames(prefix:String="", out:Vector<String>=null):Vector<String>;

    /** Returns an object with a certain name, or null if it's not found. Enqueued JSON
     * data is parsed and can be accessed with this method. */
    public function getObject(name:String):Dynamic;
    
    /** Returns all object names that start with a certain string, sorted alphabetically. 
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getObjectNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    /** Returns a byte array with a certain name, or null if it's not found. */
    public function getByteArray(name:String):ByteArray;
    
    /** Returns all byte array names that start with a certain string, sorted alphabetically. 
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getByteArrayNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    /** Returns a bitmaps font with a certain name, or null if it's not found. */
    public function getBitmapFont(name:String):BitmapFont;

    /** Returns all bitmap fonts names that start with a certain string, sorted alphabetically. 
     * If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getBitmapFontNames(prefix:String="", out:Vector<String>=null):Vector<String>;
    
    // direct adding
    
    /** Register a texture under a certain name. It will be available right away.
     * If the name was already taken, the existing texture will be disposed and replaced
     * by the new one. */
    public function addTexture(name:String, texture:Texture):Void;
    
    /** Register a texture atlas under a certain name. It will be available right away. 
     * If the name was already taken, the existing atlas will be disposed and replaced
     * by the new one. */
    public function addTextureAtlas(name:String, atlas:TextureAtlas):Void;
    
    /** Register a sound under a certain name. It will be available right away.
     * If the name was already taken, the existing sound will be replaced by the new one. */
    public function addSound(name:String, sound:Sound):Void;
    
    /** Register an XML object under a certain name. It will be available right away.
     * If the name was already taken, the existing XML will be disposed and replaced
     * by the new one. */
    public function addXml(name:String, xml:Dynamic):Void;
    
    /** Register an arbitrary object under a certain name. It will be available right away. 
     * If the name was already taken, the existing object will be replaced by the new one. */
    public function addObject(name:String, object:Dynamic):Void;
    
    /** Register a byte array under a certain name. It will be available right away.
     * If the name was already taken, the existing byte array will be cleared and replaced
     * by the new one. */
    public function addByteArray(name:String, byteArray:ByteArray):Void;
    
    /** Register a bitmap font under a certain name. It will be available right away.
     *  If the name was already taken, the existing font will be disposed and replaced
     *  by the new one.
     *
     *  <p>Note that the font is <strong>not</strong> registered at the TextField class.
     *  This only happens when a bitmap font is loaded via the asset queue.</p>
     */
    public function addBitmapFont(name:String, font:BitmapFont):Void;
    
    // removing
    
    /** Removes a certain texture, optionally disposing it. */
    public function removeTexture(name:String, dispose:Bool=true):Void;
    
    /** Removes a certain texture atlas, optionally disposing it. */
    public function removeTextureAtlas(name:String, dispose:Bool=true):Void;
    
    /** Removes a certain sound. */
    public function removeSound(name:String):Void;
    
    /** Removes a certain Xml object, optionally disposing it. */
    public function removeXml(name:String, dispose:Bool=true):Void;
    
    /** Removes a certain object. */
    public function removeObject(name:String):Void;
    
    /** Removes a certain byte array, optionally disposing its memory right away. */
    public function removeByteArray(name:String, dispose:Bool=true):Void;
    
    /** Removes a certain bitmap font, optionally disposing it. */
    public function removeBitmapFont(name:String, dispose:Bool=true):Void;
    
    /** Empties the queue and aborts any pending load operations. */
    public function purgeQueue():Void;
    
    /** Removes assets of all types (disposing them along the way), empties the queue and
     * aborts any pending load operations. */
    public function purge():Void;
    
    // queued adding
    
    /** Enqueues one or more raw assets; they will only be available after successfully 
     * executing the "loadQueue" method. This method accepts a variety of different objects:
     * 
     * <ul>
     *   <li>Strings or URLRequests containing an URL to a local or remote resource. Supported
     *       types: <code>png, jpg, gif, atf, mp3, xml, fnt, json, binary</code>.</li>
     *   <li>Instances of the File class (AIR only) pointing to a directory or a file.
     *       Directories will be scanned recursively for all supported types.</li>
     *   <li>Classes that contain <code>static</code> embedded assets.</li>
     *   <li>If the file extension is not recognized, the data is analyzed to see if
     *       contains XML or JSON data. If it's neither, it is stored as ByteArray.</li>
     * </ul>
     * 
     * <p>Suitable object names are extracted automatically: A file named "image.png" will be
     * accessible under the name "image". When enqueuing embedded assets via a class, 
     * the variable name of the embedded object will be used as its name. An exception
     * are texture atlases: they will have the same name as the actual texture they are
     * referencing.</p>
     * 
     * <p>XMLs that contain texture atlases or bitmap fonts are processed directly: fonts are
     * registered at the TextField class, atlas textures can be acquired with the
     * "getTexture()" method. All other XMLs are available via "getXml()".</p>
     * 
     * <p>If you pass in JSON data, it will be parsed into an object and will be available via
     * "getObject()".</p>
     */
    public function enqueue(rawAssets:Array<Dynamic>):Void;
    
    /** Enqueues a single asset with a custom name that can be used to access it later.
     * If the asset is a texture, you can also add custom texture options.
     * 
     * @param asset    The asset that will be enqueued; accepts the same objects as the
     *                 'enqueue' method.
     * @param name     The name under which the asset will be found later. If you pass null or
     *                 omit the parameter, it's attempted to generate a name automatically.
     * @param options  Custom options that will be used if 'asset' points to texture data.
     * @return         the name with which the asset was registered.
     */
    public function enqueueWithName(asset:Dynamic, name:String=null,
                                    options:TextureOptions=null):String;
    
    /** Loads all enqueued assets asynchronously. The 'onProgress' function will be called
     * with a 'ratio' between '0.0' and '1.0', with '1.0' meaning that it's complete.
     *
     * <p>When you call this method, the manager will save a reference to "Starling.current";
     * all textures that are loaded will be accessible only from within this instance. Thus,
     * if you are working with more than one Starling instance, be sure to call
     * "makeCurrent()" on the appropriate instance before processing the queue.</p>
     *
     * @param onProgress <code>function(ratio:Number):void;</code>
     */
    public function loadQueue(onProgress:Float->Void):Void;

    // properties
    
    /** The queue contains one 'Object' for each enqueued asset. Each object has 'asset'
     * and 'name' properties, pointing to the raw asset and its name, respectively. */
    private var queue(get, never):Array<Dynamic>;
    private function get_queue():Array<Dynamic>;
    
    /** Returns the number of raw assets that have been enqueued, but not yet loaded. */
    public var numQueuedAssets(get, never):Int;
    private function get_numQueuedAssets():Int;
    
    /** When activated, the class will trace information about added/enqueued assets.
     * @default true */
    public var verbose(get, set):Bool;
    private function get_verbose():Bool;
    private function set_verbose(value:Bool):Bool;
    
    /** Indicates if a queue is currently being loaded. */
    public var isLoading(get, never):Bool;
    private function get_isLoading():Bool;

    /** For bitmap textures, this flag indicates if mip maps should be generated when they 
     * are loaded; for ATF textures, it indicates if mip maps are valid and should be
     * used. @default false */
    public var useMipMaps(get, set):Bool;
    private function get_useMipMaps():Bool;
    private function set_useMipMaps(value:Bool):Bool;

    /** Textures that are created from Bitmaps or ATF files will have the scale factor 
     * assigned here. @default 1 */
    public var scaleFactor(get, set):Float;
    private function get_scaleFactor():Float;
    private function set_scaleFactor(value:Float):Float;

    /** Textures that are created from Bitmaps will be uploaded to the GPU with the
     * <code>Context3DTextureFormat</code> assigned to this property. @default "bgra" */
    public var textureFormat(get, set):Context3DTextureFormat;
    private function get_textureFormat():Context3DTextureFormat;
    private function set_textureFormat(value:Context3DTextureFormat):Context3DTextureFormat;
    
    /** Indicates if the underlying Stage3D textures should be created as the power-of-two based
     *  <code>Texture</code> class instead of the more memory efficient <code>RectangleTexture</code>.
     *  @default false */
    public var forcePotTextures(get, set):Bool;
    private function get_forcePotTextures():Bool;
    private function set_forcePotTextures(value:Bool):Bool;
    
    /** Specifies whether a check should be made for the existence of a URL policy file before
     * loading an object from a remote server. More information about this topic can be found 
     * in the 'flash.system.LoaderContext' documentation. @default false */
    public var checkPolicyFile(get, set):Bool;
    private function get_checkPolicyFile():Bool;
    private function set_checkPolicyFile(value:Bool):Bool;

    /** Indicates if atlas XML data should be stored for access via the 'getXml' method.
     * If true, you can access an XML under the same name as the atlas.
     * If false, XMLs will be disposed when the atlas was created. @default false. */
    public var keepAtlasXmls(get, set):Bool;
    private function get_keepAtlasXmls():Bool;
    private function set_keepAtlasXmls(value:Bool):Bool;

    /** Indicates if bitmap font XML data should be stored for access via the 'getXml' method.
     * If true, you can access an XML under the same name as the bitmap font.
     * If false, XMLs will be disposed when the font was created. @default false. */
    public var keepFontXmls(get, set):Bool;
    private function get_keepFontXmls():Bool;
    private function set_keepFontXmls(value:Bool):Bool;

    /** The maximum number of parallel connections that are spawned when loading the queue.
     * More connections can reduce loading times, but require more memory. @default 3. */
    public var numConnections(get, set):Int;
    private function get_numConnections():Int;
    private function set_numConnections(value:Int):Int;
    
    /** Indicates if bitmap fonts should be registered with their "face" attribute from the
     *  font XML file. Per default, they are registered with the name of the texture file.
     *  @default false */
    public var registerBitmapFontsWithFontFace(get, set):Bool;
    public function get_registerBitmapFontsWithFontFace():Bool;
    public function set_registerBitmapFontsWithFontFace(value:Bool):Bool;
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import Sound from "openfl/media/Sound";
import SoundChannel from "openfl/media/SoundChannel";
import SoundTransform from "openfl/media/SoundTransform";
import ByteArray from "openfl/utils/ByteArray";
import Vector from "openfl/Vector";
import EventDispatcher from "./../events/EventDispatcher";
import BitmapFont from "./../text/BitmapFont";
import Texture from "./../textures/Texture";
import TextureAtlas from "./../textures/TextureAtlas";
import TextureOptions from "./../textures/TextureOptions";

declare namespace starling.assets
{

	/** Dispatched when all textures have been restored after a context loss. */
	// @:meta(Event(name="texturesRestored", type="starling.events.Event"))

	/** The AssetManager handles loading and accessing a variety of asset types. You can
	 *  add assets directly (via the 'add...' methods) or asynchronously via a queue. This allows
	 *  you to deal with assets in a unified way, no matter if they are loaded from a file,
	 *  directory, URL, or from an embedded object.
	 *
	 *  <p>The class can deal with the following media types:
	 *  <ul>
	 *    <li>Texture, either from Bitmaps or ATF data</li>
	 *    <li>Texture atlases</li>
	 *    <li>Bitmap Fonts</li>
	 *    <li>Sounds</li>
	 *    <li>XML data</li>
	 *    <li>JSON data</li>
	 *    <li>ByteArrays</li>
	 *    <li>other AssetManagers</li>
	 *  </ul>
	 *  </p>
	 *
	 *  <p>For more information on how to add assets from different sources, read the documentation
	 *  of the "enqueue()" method.</p>
	 *
	 *  <strong>Context Loss</strong>
	 *
	 *  <p>When the stage3D context is lost, the AssetManager will automatically restore all
	 *  loaded textures. To save memory, it will get them from their original sources. Since
	 *  this is done asynchronously, your images might not reappear all at once, but during
	 *  a time frame of several seconds. If you want, you can pause your game during that time;
	 *  the AssetManager dispatches an "Event.TEXTURES_RESTORED" event when all textures have
	 *  been restored.</p>
	 *
	 *  <strong>Error Handling</strong>
	 *
	 *  <p>Loading of some assets may fail while the queue is being processed. In that case, the
	 *  AssetManager will call the 'onError' callback that you can optional provide to the
	 *  'loadQueue' method. Queue processing will continue after an error, so it's always
	 *  guaranteed that the 'onComplete' callback is executed, too.</p>
	 *
	 *  <strong>Texture Properties</strong>
	 *
	 *  <p>When you enqueue a texture, its properties for "format", "scale", "mipMapping", and
	 *  "repeat" will reflect the settings of the AssetManager at the time they were enqueued.
	 *  This means that you can enqueue a bunch of textures, then change the settings and enqueue
	 *  some more. Like this:</p>
	 *
	 *  <listing>
	 *  appDir:File = File.applicationDirectory;
	 *  assets:AssetManager = new AssetManager();
	 *  
	 *  assets.textureOptions.format = Context3DTextureFormat.BGRA;
	 *  assets.enqueue(appDir.resolvePath("textures/32bit"));
	 *  
	 *  assets.textureOptions.format = Context3DTextureFormat.BGRA_PACKED;
	 *  assets.enqueue(appDir.resolvePath("textures/16bit"));
	 *  
	 *  assets.loadQueue(...);</listing>
	 * 
	 *  <strong>Nesting</strong>
	 *
	 *  <p>When you enqueue one or more AssetManagers to another one, the "loadQueue" method will
	 *  oad the Assets of the "child" AssetManager, as well. Later, when accessing assets,
	 *  the "parent" AssetManager will return the "child" assets as well - just like it returns,
	 *  say, the SubTextures from a contained TextureAtlas.</p>
	 *
	 *  <p>The main advantage of grouping your assets like this is something else, though: it
	 *  allows to remove (and dispose) a complete group of assets in one step. The example
	 *  below loads the assets from two directories. When the contents of one of them are no
	 *  longer needed, all its assets are removed together.</p>
	 *
	 *  <listing>
	 *  manager:AssetManager = new AssetManager();
	 *  appDir:File = File.applicationDirectory;
	 *  
	 *  redAssets:AssetManager = new AssetManager();
	 *  manager.enqueueSingle(appDir.resolvePath("textures/red/", "redAssets");
	 *  
	 *  greenAssets:AssetManager = new AssetManager();
	 *  manager.enqueueSingle(appDir.resolvePath("textures/green/", "greenAssets");
	 *  
	 *  manager.loadQueue(...); // loads both "red" and "green" assets
	 *  
	 *  // ... later, remove all "red" assets together
	 *  manager.removeAssetManager("redAssets");</listing>
	 *
	 *  <strong>Customization</strong>
	 *
	 *  <p>You can customize how assets are created by extending the 'AssetFactory' class and
	 *  registering an instance of your new class at the AssetManager via 'registerFactory'.
	 *  Factories are probed by priority; any factory with a priority > 0 will be executed
	 *  before the built-in factories.</p>
	 *
	 *  <p>An asset type is identified by a unique String. You can add your own asset types
	 *  by creating a custom 'AssetFactory' and having it add the asset with custom string
	 *  identifier.</p>
	 *
	 *  <p>By overriding the methods 'getNameFromUrl', 'getExtensionFromUrl', 'disposeAsset',
	 *  and 'log', you can customize how assets are named and disposed, and you can forward
	 *  any logging to an external logger. To customize the way data is loaded from URLs or
	 *  files, you can assign a custom 'DataLoader' instance to the AssetManager.</p>
	 *
	 *  @see starling.assets.AssetFactory
	 *  @see starling.assets.AssetType
	 *  @see starling.assets.DataLoader
	 */
	export class AssetManager extends EventDispatcher
	{
		/** Create a new instance with the given scale factor. */
		public constructor(scaleFactor?:number=);

		/** Disposes all assets and purges the queue.
		 *
		 *  <p>Beware that all references to the assets will remain intact, even though the assets
		 *  are no longer valid. Call 'purge' if you want to remove all resources and reuse
		 *  the AssetManager later.</p>
		 */
		public dispose():void;

		/** Removes assets of all types (disposing them along the way), empties the queue and
		 *  aborts any pending load operations. */
		public purge():void;

		// queue processing

		/** Enqueues one or more raw assets; they will only be available after successfully
		 *  executing the "loadQueue" method. This method accepts a variety of different objects:
		 *
		 *  <ul>
		 *    <li>Strings or URLRequests containing an URL to a local or remote resource. Supported
		 *        types: <code>png, jpg, gif, atf, mp3, xml, fnt, json, binary</code>.</li>
		 *    <li>Instances of the File class (AIR only) pointing to a directory or a file.
		 *        Directories will be scanned recursively for all supported types.</li>
		 *    <li>Classes that contain <code>static</code> embedded assets.</li>
		 *    <li>If the file extension is not recognized, the data is analyzed to see if
		 *        contains XML or JSON data. If it's neither, it is stored as ByteArray.</li>
		 *  </ul>
		 *
		 *  <p>Suitable object names are extracted automatically: A file named "image.png" will be
		 *  accessible under the name "image". When enqueuing embedded assets via a class,
		 *  the variable name of the embedded object will be used as its name. An exception
		 *  are texture atlases: they will have the same name as the actual texture they are
		 *  referencing.</p>
		 *
		 *  <p>XMLs are made available via "getXml()"; this includes XMLs containing texture
		 *  atlases or bitmap fonts, which are processed along the way. Bitmap fonts are also
		 *  registered at the TextField class.</p>
		 *
		 *  <p>If you pass in JSON data, it will be parsed into an object and will be available via
		 *  "getObject()".</p>
		 */
		public enqueue(assets:Array<any>):void;

		/** Enqueues a single asset with a custom name that can be used to access it later.
		 *  If the asset is a texture, you can also add custom texture options.
		 *
		 *  @param asset    The asset that will be enqueued; accepts the same objects as the
		 *                  'enqueue' method.
		 *  @param name     The name under which the asset will be found later. If you pass null or
		 *                  omit the parameter, it's attempted to generate a name automatically.
		 *  @param options  Custom options that will be used if 'asset' points to texture data.
		 *  @return         the name with which the asset was registered.
		 */
		public enqueueSingle(asset:any, name?:string,
									options?:TextureOptions):string;

		/** Empties the queue and aborts any pending load operations. */
		public purgeQueue():void;

		/** Loads all enqueued assets asynchronously. The 'onComplete' callback will be executed
		 *  once all assets have been loaded - even when there have been errors, which are
		 *  forwarded to the optional 'onError' callback. The 'onProgress' will be called
		 *  with a 'ratio' between '0.0' and '1.0' and is also optional.
		 *
		 *  <p>When you call this method, the manager will save a reference to "Starling.current";
		 *  all textures that are loaded will be accessible only from within this instance. Thus,
		 *  if you are working with more than one Starling instance, be sure to call
		 *  "makeCurrent()" on the appropriate instance before processing the queue.</p>
		 *
		 *  @param onComplete   <code>function(manager:AssetManager):void;</code> - parameter is optional!
		 *  @param onError      <code>function(error:string):void;</code>
		 *  @param onProgress   <code>function(ratio:Number):void;</code>
		 */
		public loadQueue(onComplete:()=>void,
								onError?:(string)=>void, onProgress?:(number)=>void):void;

		// basic accessing methods

		/** Add an asset with a certain name and type.
		 *
		 *  <p>Beware: if the slot (name + type) was already taken, the existing object will be
		 *  disposed and replaced by the new one.</p>
		 *
		 *  @param name    The name with which the asset can be retrieved later. Must be
		 *                 unique within this asset type.
		 *  @param asset   The actual asset to add (e.g. a texture, a sound, etc).
		 *  @param type    The type of the asset. If omitted, the type will be determined
		 *                 automatically (which works for all standard types defined within
		 *                 the 'AssetType' class).
		 */
		public addAsset(name:string, asset:any, type?:string):void;

		/** Retrieves an asset of the given type, with the given name. If 'recursive' is true,
		 *  the method will traverse included texture atlases and asset managers.
		 *
		 *  <p>Typically, you will use one of the type-safe convenience methods instead, like
		 *  'getTexture', 'getSound', etc.</p>
		 */
		public getAsset(type:string, name:string, recursive?:boolean):any;

		/** Retrieves an alphabetically sorted list of all assets that have the given type and
		 *  start with the given prefix. If 'recursive' is true, the method will traverse included
		 *  texture atlases and asset managers. */
		public getAssetNames(assetType:string, prefix?:string, recursive?:boolean,
									out?:Vector<string>):Vector<string>;

		/** Removes the asset with the given name and type, and will optionally dispose it. */
		public removeAsset(assetType:string, name:string, dispose?:boolean):void;

		// convenience access methods

		/** Returns a texture with a certain name. Includes textures stored inside atlases. */
		public getTexture(name:string):Texture;

		/** Returns all textures that start with a certain string, sorted alphabetically
		 *  (especially useful for "MovieClip"). Includes textures stored inside atlases. */
		public getTextures(prefix?:string, out?:Vector<Texture>):Vector<Texture>;

		/** Returns all texture names that start with a certain string, sorted alphabetically.
		 *  Includes textures stored inside atlases. */
		public getTextureNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns a texture atlas with a certain name, or null if it's not found. */
		public getTextureAtlas(name:string):TextureAtlas;

		/** Returns all texture atlas names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getTextureAtlasNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns a sound with a certain name, or null if it's not found. */
		public getSound(name:string):Sound;

		/** Returns all sound names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getSoundNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Generates a new SoundChannel object to play back the sound. This method returns a
		 *  SoundChannel object, which you can access to stop the sound and to control volume. */
		public playSound(name:string, startTime?:number, loops?:number,
								transform?:SoundTransform):SoundChannel;

		/** Returns an XML with a certain name, or null if it's not found. */
		public getXml(name:string):Xml;

		/** Returns all XML names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getXmlNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns an object with a certain name, or null if it's not found. Enqueued JSON
		 *  data is parsed and can be accessed with this method. */
		public getObject(name:string):any;

		/** Returns all object names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getObjectNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns a byte array with a certain name, or null if it's not found. */
		public getByteArray(name:string):ByteArray;

		/** Returns all byte array names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getByteArrayNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns a bitmap font with a certain name, or null if it's not found. */
		public getBitmapFont(name:string):BitmapFont;

		/** Returns all bitmap font names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getBitmapFontNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Returns an asset manager with a certain name, or null if it's not found. */
		public getAssetManager(name:string):AssetManager;

		/** Returns all asset manager names that start with a certain string, sorted alphabetically.
		 *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
		public getAssetManagerNames(prefix?:string, out?:Vector<string>):Vector<string>;

		/** Removes a certain texture, optionally disposing it. */
		public removeTexture(name:string, dispose?:boolean):void;

		/** Removes a certain texture atlas, optionally disposing it. */
		public removeTextureAtlas(name:string, dispose?:boolean):void;

		/** Removes a certain sound. */
		public removeSound(name:string):void;

		/** Removes a certain Xml object, optionally disposing it. */
		public removeXml(name:string, dispose?:boolean):void;

		/** Removes a certain object. */
		public removeObject(name:string):void;

		/** Removes a certain byte array, optionally disposing its memory right away. */
		public removeByteArray(name:string, dispose?:boolean):void;

		/** Removes a certain bitmap font, optionally disposing it. */
		public removeBitmapFont(name:string, dispose?:boolean):void;

		/** Removes a certain asset manager and optionally disposes it right away. */
		public removeAssetManager(name:string, dispose?:boolean):void;

		// registration of factories

		/** Registers a custom AssetFactory. If you use any priority > 0, the factory will
		 *  be called before the default factories. The final factory to be invoked is the
		 *  'ByteArrayFactory', which is using a priority of '-100'. */
		public registerFactory(factory:AssetFactory, priority?:number):void;

		// properties

		/** When activated, the class will trace information about added/enqueued assets.
		 *  @default true */
		public verbose:boolean;
		protected get_verbose():boolean;
		protected set_verbose(value:boolean):boolean;

		/** Returns the number of raw assets that have been enqueued, but not yet loaded. */
		public readonly numQueuedAssets:number;
		protected get_numQueuedAssets():number;

		/** The maximum number of parallel connections that are spawned when loading the queue.
		 *  More connections can reduce loading times, but require more memory. @default 3. */
		public numConnections:number;
		protected get_numConnections():number;
		protected set_numConnections(value:number):number;

		/** Textures will be created with the options set up in this object at the time of
		 *  enqueuing. */
		public textureOptions:TextureOptions;
		protected get_textureOptions():TextureOptions;
		protected set_textureOptions(value:TextureOptions):TextureOptions;

		/** The DataLoader is used to load any data from files or URLs. If you need to customize
		 *  its behavior (e.g. to add a caching mechanism), assign your custom instance here. */
		public dataLoader:DataLoader;
		protected get_dataLoader():DataLoader;
		protected set_dataLoader(value:DataLoader):DataLoader;

		/** Indicates if bitmap fonts should be registered with their "face" attribute from the
		 *  font XML file. Per default, they are registered with the name of the texture file.
		 *  @default false */
		public registerBitmapFontsWithFontFace:boolean;
		protected get_registerBitmapFontsWithFontFace():boolean;
		protected set_registerBitmapFontsWithFontFace(value:boolean):boolean;
	}

	export class AssetPostProcessor
	{
		public constructor(callback:(AssetManager)=>void, priority:number);

		public readonly priority:number;
		protected get_priority():number;
	}
}

export default starling.assets.AssetManager;
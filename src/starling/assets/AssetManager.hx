// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.assets;

import haxe.Timer;
import openfl.errors.ArgumentError;
#if desktop
import openfl.filesystem.File;
#end
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.Vector;
//import openfl.utils.describeType;
//import openfl.utils.getQualifiedClassName;
//import openfl.utils.setTimeout;

import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.text.BitmapFont;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.textures.TextureOptions;
import starling.utils.MathUtil;
import starling.utils.Execute;

/** Dispatched when all textures have been restored after a context loss. */
@:meta(Event(name="texturesRestored", type="starling.events.Event"))

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
 *  var appDir:File = File.applicationDirectory;
 *  var assets:AssetManager = new AssetManager();
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
 *  var manager:AssetManager = new AssetManager();
 *  var appDir:File = File.applicationDirectory;
 *  
 *  var redAssets:AssetManager = new AssetManager();
 *  redAssets.enqueueSingle(appDir.resolvePath("textures/red/", "redAssets"));
 *  
 *  var greenAssets:AssetManager = new AssetManager();
 *  greenAssets.enqueueSingle(appDir.resolvePath("textures/green/", "greenAssets"));
 *  
 *  manager.enqueueSingle(redAssets, "redAssets");
 *  manager.enqueueSingle(greenAssets, "greenAssets");
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
class AssetManager extends EventDispatcher
{
    private var _starling:Starling;
    private var _assets:Map<String, Map<String, Dynamic>>;
    private var _verbose:Bool;
    private var _numConnections:Int;
    private var _dataLoader:DataLoader;
    private var _textureOptions:TextureOptions;
    private var _queue:Vector<AssetReference>;
    private var _registerBitmapFontsWithFontFace:Bool;
    private var _assetFactories:Vector<AssetFactory>;
    private var _numRestoredTextures:Int;
    private var _numLostTextures:Int;

    // Regex for name / extension extraction from URLs.
    private static var NAME_REGEX:EReg = ~/(([^?\/\\]+?)(?:\.([\w\-]+))?)(?:\?.*)?$/;

    // fallback for unnamed assets
    private static var NO_NAME:String = "unnamed";
    private static var sNoNameCount:Int = 0;

    // helper objects
    private static var sNames:Vector<String> = new Vector<String>();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (AssetManager.prototype, {
            "verbose": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_verbose (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_verbose (v); }") },
            "numQueuedAssets": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numQueuedAssets (); }") },
            "numConnections": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numConnections (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_numConnections (v); }") },
            "textureOptions": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_textureOptions (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_textureOptions (v); }") },
            "dataLoader": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_dataLoader (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_dataLoader (v); }") },
            "registerBitmapFontsWithFontFace": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_registerBitmapFontsWithFontFace (); }"), set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_registerBitmapFontsWithFontFace (v); }") },
        });
        
    }
    #end

    /** Create a new instance with the given scale factor. */
    public function new(scaleFactor:Float= 1)
    {
        super();
        
        _assets = new Map<String, Map<String, Dynamic>>();
        _verbose = true;
        _textureOptions = new TextureOptions(scaleFactor);
        _queue = new Vector<AssetReference>();
        _numConnections = 3;
        _dataLoader = new DataLoader();
        _assetFactories = new Vector<AssetFactory>();

        registerFactory(new BitmapTextureFactory());
        registerFactory(new AtfTextureFactory());
        registerFactory(new SoundFactory());
        registerFactory(new JsonFactory());
        registerFactory(new XmlFactory());
        registerFactory(new ByteArrayFactory(), -100);
    }

    /** Disposes all assets and purges the queue.
     *
     *  <p>Beware that all references to the assets will remain intact, even though the assets
     *  are no longer valid. Call 'purge' if you want to remove all resources and reuse
     *  the AssetManager later.</p>
     */
    public function dispose():Void
    {
        purgeQueue();

        for (store in _assets)
            for (asset in store)
                disposeAsset(asset);
    }

    /** Removes assets of all types (disposing them along the way), empties the queue and
     *  aborts any pending load operations. */
    public function purge():Void
    {
        log("Purging all assets, emptying queue");

        purgeQueue();
        dispose();

        _assets = new Map<String, Map<String, Dynamic>>();
    }

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
    public function enqueue(assets:Array<Dynamic>):Void
    {
        for (asset in assets)
        {
            if (asset == null)
            {
                continue;
            }
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Array))
            {
                enqueue(asset);
            }
			// Note that #if 0 means no compilation
            #if 0	//We don't support Embedded assets via static class variables that are read with describeType() in AS3
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Class))
            {
                var typeXml:Xml = describeType(asset);
                var childNode:Xml;

                if (_verbose)
                    log("Looking for static embedded assets in '" +
                        (typeXml.@name).split("::").pop() + "'");

                for each (childNode in typeXml.constant.(@type == "Class"))
                    enqueueSingle(asset[childNode.@name], childNode.@name);

                for each (childNode in typeXml.variable.(@type == "Class"))
                    enqueueSingle(asset[childNode.@name], childNode.@name);
            }
            else if (getQualifiedClassName(asset) == "flash.filesystem::File")
            {
                if (!asset["exists"])
                {
                    log("File or directory not found: '" + asset["url"] + "'");
                }
                else if (!asset["isHidden"])
                {
                    if (asset["isDirectory"])
                        enqueue.apply(this, asset["getDirectoryListing"]());
                    else
                        enqueueSingle(asset);
                }
            }
            #end
			#if desktop
			else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, File))
			{
				var file:File = cast asset;
				if (!file.exists)
				{
					log("File or directory not found: '" + file.url + "'");
				}
				else if (!file.isHidden)
				{
					if (file.isDirectory)
						enqueue(file.getDirectoryListing());
					else
						enqueueSingle(file);
				}
			}
			#end
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, String) || #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, URLRequest) || #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, AssetManager))
            {
                enqueueSingle(asset);
            }
            else
            {
                log("Ignoring unsupported asset type: " + openfl.Lib.getQualifiedClassName(asset));
            }
        }
    }

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
    public function enqueueSingle(asset:Dynamic, name:String=null,
                                  options:TextureOptions=null,
								  customExtension:String=null,
								  customMimeType:String=null):String
    {
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Class))
            asset = Type.createInstance(asset, []);

        var assetReference:AssetReference = new AssetReference(asset);
        
        if (name != null)
        {
            assetReference.name = name;
        }
        else
        {
            var nameFromUrl:String = getNameFromUrl(assetReference.url);
            if (nameFromUrl != null)
                assetReference.name  = nameFromUrl;
            else
                assetReference.name = getUniqueName();
        }
        
		if (customExtension != null)
			assetReference.extension = customExtension;
		else
			assetReference.extension = getExtensionFromUrl(assetReference.url);
		
		assetReference.mimeType = customMimeType;
        
        if (options != null)
            assetReference.textureOptions = options;
        else
            assetReference.textureOptions = _textureOptions;
        
        var logName:String = getFilenameFromUrl(assetReference.url);
        if (logName == null) logName = assetReference.name;
        
        _queue.push(assetReference);
        log("Enqueuing '" + logName + "'");
        return assetReference.name;
    }
	
	/** Removes the asset(s) with the given name(s) from the queue. Note that this won't work
	 *  after loading has started, even if these specific assets have not yet been processed. */
	public function dequeue(assetNames:Array<String>):Void
	{
		_queue = _queue.filter(function (asset:AssetReference):Bool
		{
			return assetNames.indexOf(asset.name) == -1;
		});
	}

    /** Empties the queue and aborts any pending load operations. */
    public function purgeQueue():Void
    {
        _queue.length = 0;
        _dataLoader.close();
        dispatchEventWith(Event.CANCEL);
    }

    /** Loads all enqueued assets asynchronously. The 'onComplete' callback will be executed
     *  once all assets have been loaded - even when there have been errors, which are
     *  forwarded to the optional 'onError' callback. The 'onProgress' function will be called
     *  with a 'ratio' between '0.0' and '1.0' and is also optional. Furthermore, all
     *  parameters of all the callbacks are optional.
     *
     *  <p>When you call this method, the manager will save a reference to "Starling.current";
     *  all textures that are loaded will be accessible only from within this instance. Thus,
     *  if you are working with more than one Starling instance, be sure to call
     *  "makeCurrent()" on the appropriate instance before processing the queue.</p>
     *
     *  @param onComplete   <code>function(manager:AssetManager):void;</code>
     *  @param onError      <code>function(error:String, asset:AssetReference):void;</code>
     *  @param onProgress   <code>function(ratio:Number):void;</code>
     */
    public function loadQueue(onComplete:Void->Void,
                              onError:String->Void=null, onProgress:Float->Void=null):Void
    {
        var self:AssetManager = this;
        var canceled:Bool = false;
        var queue:Vector<AssetReference> = _queue.concat();
        var numAssets:Int = queue.length;
        var numComplete:Int = 0;
        var numConnections:Int = Std.int(MathUtil.min(_numConnections, numAssets));
        var assetProgress:Vector<Float> = new Vector<Float>();
        var postProcessors:Vector<AssetPostProcessor> = new Vector<AssetPostProcessor>();
        var factoryHelper:AssetFactoryHelper = null;
        
        var loadNextAsset:Void->Void = null;
        var onAssetLoaded:?String->?Dynamic->/*?String->*/Void = null;
        var onAssetLoadError:String->/*AssetReference->*/Void = null;
        var onAssetProgress:Float->Void = null;
        var addPostProcessor:(AssetManager->Void)->Int->Void = null;
        var runPostProcessors:Void->Void = null;
        var onCanceled:Void->Void = null;
        var finish:Void->Void = null;
        
        loadNextAsset = function ():Void
        {
            if (canceled) return;

            var j:Int = 0;
            while (j<numAssets)
            {
                if (assetProgress[j] < 0)
                {
                    loadFromQueue(queue, assetProgress, j, factoryHelper,
                        onAssetLoaded, onAssetProgress, onAssetLoadError, onError);
                    break;
                }
                j++;
            }
        }

        onAssetLoaded = function (name:String=null, asset:Dynamic=null /*, type:String=null*/):Void
        {
            var type = null;
            
            if (canceled && asset != null) disposeAsset(asset);
            else
            {
                if (name != null && asset != null) addAsset(name, asset, type);
                numComplete++;

                if (numComplete == numAssets)
                {
                    postProcessors.sort(compareAssetPostProcessorsPriorities);
                    Timer.delay(runPostProcessors, 1);
                }
                else Timer.delay(loadNextAsset, 1);
            }
        }

        onAssetLoadError = function (error:String /*, asset:AssetReference*/):Void
        {
            if (!canceled)
            {
                Execute.execute(onError, [error /*, asset*/]);
                onAssetLoaded();
            }
        }

        onAssetProgress = function (ratio:Float):Void
        {
            if (!canceled) Execute.execute(onProgress, [ratio * 0.95]);
        }

        addPostProcessor = function (processorFunc:AssetManager->Void, priority:Int):Void
        {
            postProcessors.push(new AssetPostProcessor(processorFunc, priority));
        }

        runPostProcessors = function ():Void
        {
            if (!canceled)
            {
                if (postProcessors.length > 0)
                {
                    try { postProcessors.shift().execute(self); }
                    catch (e:Dynamic) { Execute.execute(onError, [e.message]); }

                    Timer.delay(runPostProcessors, 1);
                }
                else finish();
            }
        }

        onCanceled = function ():Void
        {
            canceled = true;
            removeEventListener(Event.CANCEL, onCanceled);
        }

        finish = function ():Void
        {
            onCanceled();
            Execute.execute(onProgress, [1.0]);
            Execute.execute(onComplete, [self]);
        }
        
        if (_queue.length == 0)
        {
            finish();
            return;
        }

        // By using an event listener, we can make a call to "cancel" affect
        // only the currently active loading process(es).
        addEventListener(Event.CANCEL, onCanceled);

        factoryHelper = new AssetFactoryHelper();
        factoryHelper.getNameFromUrlFunc = getNameFromUrl;
        factoryHelper.getExtensionFromUrlFunc = getExtensionFromUrl;
        factoryHelper.addPostProcessorFunc = addPostProcessor;
        factoryHelper.addAssetFunc = addAsset;
        factoryHelper.onRestoreFunc = onAssetRestored;
        factoryHelper.dataLoader = _dataLoader;
        factoryHelper.logFunc = log;

        _starling = Starling.current;
        _queue.length = 0;

        for (i in 0...numAssets)
            assetProgress[i] = -1;

        for (i in 0...numConnections)
            loadNextAsset();
    }

    private function loadFromQueue(
        queue:Vector<AssetReference>, progressRatios:Vector<Float>, index:Int,
        helper:AssetFactoryHelper, onComplete:String->Dynamic->Void, onProgress:Float->Void,
        onError:String->Void, onIntermediateError:String->Void):Void
    {
        var referenceCount:Int = queue.length;
        var reference:AssetReference = queue[index];
        progressRatios[index] = 0;
        
        var onLoadComplete:?ByteArray->?String->?String->?String->Void = null;
        var onLoadProgress:Float->Void = null;
        var onLoadError:String->Void = null;
        var onFactoryError:String->Void = null;
        var onAnyError:String->Void = null;
        var onManagerComplete:Void->Void = null;
        
        onLoadComplete = function (data:ByteArray = null, mimeType:String=null,
                                   name:String=null, extension:String=null):Void
        {
            if (_starling != null) _starling.makeCurrent();

            onLoadProgress(1.0);

            if (data != null)      reference.data = data;
            if (name != null)      reference.name = name;
            if (extension != null) reference.extension = extension;
            if (mimeType != null)  reference.mimeType = mimeType;

            var assetFactory:AssetFactory = getFactoryFor(reference);
            if (assetFactory == null)
                Execute.execute(onAnyError, ["Warning: no suitable factory found for '" + reference.name + "'"]);
            else
                assetFactory.create(reference, helper, onComplete, onFactoryError);
        }

        onLoadProgress = function (ratio:Float):Void
        {
            progressRatios[index] = ratio;

            var totalRatio:Float = 0;
            var multiplier:Float = 1.0 / referenceCount;

            for (k in 0...referenceCount)
            {
                var r:Float = progressRatios[k];
                if (r > 0) totalRatio += multiplier * r;
            }

            Execute.execute(onProgress, [MathUtil.min(totalRatio, 1.0)]);
        }

        onLoadError = function (error:String):Void
        {
            onLoadProgress(1.0);
            Execute.execute(onAnyError, ["Error loading " + reference.name + ": " + error]);
        }
        
        onAnyError = function (error:String):Void
        {
            log(error);
            Execute.execute(onError, [error, reference]);
        }
        
        onFactoryError = function (error:String):Void
        {
            Execute.execute(onAnyError, ["Error creating " + reference.name + ": " + error]);
        }
        
        onManagerComplete = function ():Void
        {
            onComplete(reference.name, reference.data);
        }

        if (reference.url != null)
            _dataLoader.load(reference.url, onLoadComplete, onLoadError, onLoadProgress);
        else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(reference.data, AssetManager))
            (cast(reference.data, AssetManager)).loadQueue(onManagerComplete, onIntermediateError, onLoadProgress);
        else
            Timer.delay(function():Void { onLoadComplete(reference.data); }, 1);
    }

    private function getFactoryFor(asset:AssetReference):AssetFactory
    {
        var numFactories:Int = _assetFactories.length;
        for (i in 0...numFactories)
        {
            var factory:AssetFactory = _assetFactories[i];
            if (factory.canHandle(asset)) return factory;
        }

        return null;
    }

    private function onAssetRestored(finished:Bool):Void
    {
        if (finished)
        {
            _numRestoredTextures++;

            if (_starling != null)
                _starling.stage.setRequiresRedraw();

            if (_numRestoredTextures == _numLostTextures)
                dispatchEventWith(Event.TEXTURES_RESTORED);
        }
        else _numLostTextures++;
    }

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
    public function addAsset(name:String, asset:Dynamic, type:String=null):Void
    {
        if(type == null)
            type = AssetType.fromAsset(asset);

        var store:Map<String, Dynamic> = _assets[type];
        if (store == null)
        {
            store = new Map<String, Dynamic>();
            _assets[type] = store;
        }

        log("Adding " + type + " '" + name + "'");

        var prevAsset:Dynamic = store[name];
        if (prevAsset != null && prevAsset != asset)
        {
            log("Warning: name was already in use; disposing the previous " + type);
            disposeAsset(prevAsset);
        }

        store[name] = asset;
    }

    /** Retrieves an asset of the given type, with the given name. If 'recursive' is true,
     *  the method will traverse included texture atlases and asset managers.
     *
     *  <p>Typically, you will use one of the type-safe convenience methods instead, like
     *  'getTexture', 'getSound', etc.</p>
     */
    public function getAsset(type:String, name:String, recursive:Bool=true):Dynamic
    {
        if (recursive)
        {
            var managerStore:Map<String, Dynamic> = _assets[AssetType.ASSET_MANAGER];
            if (managerStore != null)
            {
                for (manager in managerStore)
                {
                    manager = cast(manager, AssetManager);
                    var asset:Dynamic = manager.getAsset(type, name, true);
                    if (asset != null) return asset;
                }
            }

            if (type == AssetType.TEXTURE)
            {
                var atlasStore:Map<String, Dynamic> = _assets[AssetType.TEXTURE_ATLAS];
                if (atlasStore != null)
                {
                    for (atlas in atlasStore)
                    {
                        atlas = cast(atlas, TextureAtlas);
                        var texture:Texture = atlas.getTexture(name);
                        if (texture != null) return texture;
                    }
                }
            }
        }

        var store:Map<String, Dynamic> = _assets[type];
        if (store != null) return store[name];
        else return null;
    }

    /** Retrieves an alphabetically sorted list of all assets that have the given type and
     *  start with the given prefix. If 'recursive' is true, the method will traverse included
     *  texture atlases and asset managers. */
    public function getAssetNames(assetType:String, prefix:String="", recursive:Bool=true,
                                  out:Vector<String>=null):Vector<String>
    {
        if(out == null)
            out = new Vector<String>();

        if (recursive)
        {
            var managerStore:Map<String, Dynamic> = _assets[AssetType.ASSET_MANAGER];
            if (managerStore != null)
            {
                for (manager in managerStore)
                {
                    manager = cast(manager, AssetManager);
                    manager.getAssetNames(assetType, prefix, true, out);
                }
            }

            if (assetType == AssetType.TEXTURE)
            {
                var atlasStore:Map<String, Dynamic> = _assets[AssetType.TEXTURE_ATLAS];
                if (atlasStore != null)
                {
                    for (atlas in atlasStore)
                    {
                        atlas = cast(atlas, TextureAtlas);
                        atlas.getNames(prefix, out);
                    }
                }
            }
        }

        getDictionaryKeys(_assets[assetType], prefix, out);
        out.sort(compareString);
        return out;
    }

    /** Removes the asset with the given name and type, and will optionally dispose it. */
    public function removeAsset(assetType:String, name:String, dispose:Bool=true):Void
    {
        var store:Map<String, Dynamic> = _assets[assetType];
        if (store != null)
        {
            var asset:Dynamic = store[name];
            if (asset != null)
            {
                log("Removing " + assetType + " '" + name + "'");
                if (dispose) disposeAsset(asset);
                store.remove(name);
            }
        }
    }

    // convenience access methods

    /** Returns a texture with a certain name. Includes textures stored inside atlases. */
    public function getTexture(name:String):Texture
    {
        var asset = getAsset(AssetType.TEXTURE, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Texture) ? cast asset : null;
    }

    /** Returns all textures that start with a certain string, sorted alphabetically
     *  (especially useful for "MovieClip"). Includes textures stored inside atlases. */
    public function getTextures(prefix:String="", out:Vector<Texture>=null):Vector<Texture>
    {
        if (out == null) out = new Vector<Texture>();

        for (name in getTextureNames(prefix, sNames))
            out[out.length] = getTexture(name); // avoid 'push'

        sNames.length = 0;
        return out;
    }

    /** Returns all texture names that start with a certain string, sorted alphabetically.
     *  Includes textures stored inside atlases. */
    public function getTextureNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.TEXTURE, prefix, true, out);
    }

    /** Returns a texture atlas with a certain name, or null if it's not found. */
    public function getTextureAtlas(name:String):TextureAtlas
    {
        var asset = getAsset(AssetType.TEXTURE_ATLAS, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, TextureAtlas) ? cast asset : null;
    }

    /** Returns all texture atlas names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getTextureAtlasNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.TEXTURE_ATLAS, prefix, true, out);
    }

    /** Returns a sound with a certain name, or null if it's not found. */
    public function getSound(name:String):Sound
    {
        var asset = getAsset(AssetType.SOUND, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Sound) ? cast asset : null;
    }

    /** Returns all sound names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getSoundNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.SOUND, prefix, true, out);
    }

    /** Generates a new SoundChannel object to play back the sound. This method returns a
     *  SoundChannel object, which you can access to stop the sound and to control volume. */
    public function playSound(name:String, startTime:Float=0, loops:Int=0,
                              transform:SoundTransform=null):SoundChannel
    {
        var sound:Sound = getSound(name);
        if (sound != null) return sound.play(startTime, loops, transform);
        else return null;
    }

    /** Returns an XML with a certain name, or null if it's not found. */
    public function getXml(name:String):Xml
    {
        var asset = getAsset(AssetType.XML_DOCUMENT, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Xml) ? cast asset : null;
    }

    /** Returns all XML names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getXmlNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.XML_DOCUMENT, prefix, true, out);
    }

    /** Returns an object with a certain name, or null if it's not found. Enqueued JSON
     *  data is parsed and can be accessed with this method. */
    public function getObject(name:String):Dynamic
    {
        return getAsset(AssetType.OBJECT, name);
    }

    /** Returns all object names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getObjectNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.OBJECT, prefix, true, out);
    }

    /** Returns a byte array with a certain name, or null if it's not found. */
    public function getByteArray(name:String):ByteArray
    {
        var asset = getAsset(AssetType.BYTE_ARRAY, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, #if commonjs ByteArray #else ByteArrayData #end) ? cast asset : null;
    }

    /** Returns all byte array names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getByteArrayNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.BYTE_ARRAY, prefix, true, out);
    }

    /** Returns a bitmap font with a certain name, or null if it's not found. */
    public function getBitmapFont(name:String):BitmapFont
    {
        var asset = getAsset(AssetType.BITMAP_FONT, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, BitmapFont) ? cast asset : null;
    }

    /** Returns all bitmap font names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getBitmapFontNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.BITMAP_FONT, prefix, true, out);
    }

    /** Returns an asset manager with a certain name, or null if it's not found. */
    public function getAssetManager(name:String):AssetManager
    {
        var asset = getAsset(AssetType.ASSET_MANAGER, name);
        return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, AssetManager) ? cast asset : null;
    }

    /** Returns all asset manager names that start with a certain string, sorted alphabetically.
     *  If you pass an <code>out</code>-vector, the names will be added to that vector. */
    public function getAssetManagerNames(prefix:String="", out:Vector<String>=null):Vector<String>
    {
        return getAssetNames(AssetType.ASSET_MANAGER, prefix, true, out);
    }

    /** Removes a certain texture, optionally disposing it. */
    public function removeTexture(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.TEXTURE, name, dispose);
    }

    /** Removes a certain texture atlas, optionally disposing it. */
    public function removeTextureAtlas(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.TEXTURE_ATLAS, name, dispose);
    }

    /** Removes a certain sound. */
    public function removeSound(name:String):Void
    {
        removeAsset(AssetType.SOUND, name);
    }

    /** Removes a certain Xml object, optionally disposing it. */
    public function removeXml(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.XML_DOCUMENT, name, dispose);
    }

    /** Removes a certain object. */
    public function removeObject(name:String):Void
    {
        removeAsset(AssetType.OBJECT, name);
    }

    /** Removes a certain byte array, optionally disposing its memory right away. */
    public function removeByteArray(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.BYTE_ARRAY, name, dispose);
    }

    /** Removes a certain bitmap font, optionally disposing it. */
    public function removeBitmapFont(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.BITMAP_FONT, name, dispose);
    }

    /** Removes a certain asset manager and optionally disposes it right away. */
    public function removeAssetManager(name:String, dispose:Bool=true):Void
    {
        removeAsset(AssetType.ASSET_MANAGER, name, dispose);
    }

    // registration of factories

    /** Registers a custom AssetFactory. If you use any priority > 0, the factory will
     *  be called before the default factories. The final factory to be invoked is the
     *  'ByteArrayFactory', which is using a priority of '-100'. */
    public function registerFactory(factory:AssetFactory, priority:Int=0):Void
    {
        factory.priority = priority;

        _assetFactories.push(factory);
        _assetFactories.sort(compareAssetFactoriesPriorities);
    }
	
	/** Unregisters the specified AssetFactory. */
	public function unregisterFactory(factory:AssetFactory):Void
	{
		var index:Int = _assetFactories.indexOf(factory);
		if (index != -1) _assetFactories.removeAt(index);
	}

    // helpers
    
    private function getFilenameFromUrl(url:String):String
    {
        if (url != null)
        {
            if (NAME_REGEX.match(StringTools.urlDecode(url)))
                return NAME_REGEX.matched(1);
        }
        return null;
    }

    /** This method is called internally to determine the name under which an asset will be
     *  accessible; override it if you need a custom naming scheme.
     *
     *  @return the name to be used for the asset, or 'null' if it can't be determined. */
    private function getNameFromUrl(url:String):String
    {
        if (url != null)
        {
            if (NAME_REGEX.match(StringTools.urlDecode(url)))
                return NAME_REGEX.matched(2);
        }
        return null;
    }

    /** This method is called internally to determine the extension that's passed to the
     *  'AssetFactory' (via the 'AssetReference'). Override it if you need to customize
     *  e.g. the extension of a server URL.
     *
     *  @return the extension to be used for the asset, or an empty string if it can't be
     *          determined. */
    private function getExtensionFromUrl(url:String):String
    {
        if (url != null)
        {
            if (NAME_REGEX.match(StringTools.urlDecode(url)))
                if (NAME_REGEX.matched(3) != null) //will this throw an exception if no extension is present?
                    return NAME_REGEX.matched(3);
        }
        return "";
    }

    /** Disposes the given asset. ByteArrays are cleared, XMLs are disposed using
     *  'System.disposeXML'. If the object contains a 'dispose' method, it will be called.
     *  Override if you need to add custom cleanup code for a certain asset. */
    private function disposeAsset(asset:Dynamic):Void
    {
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, #if commonjs ByteArray #else ByteArrayData #end))
        {
            var byteArray:ByteArray = cast asset;
            byteArray.clear();
        }
        //if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(asset, Xml)) cast (asset, Xml) - no need to do any special disposing of Xml in Haxe, no cross-platform equivalent of AS3's System.disposeXML();
        //if (Reflect.hasField(asset, "dispose")) cast(Reflect.field(asset, "dispose"), Function)();	- cast to Function is not allowed. How should we call dispose()?
        if (Reflect.hasField(asset, "dispose"))
        {
            var disposeMethod = Reflect.field(asset, "dispose");
            Reflect.callMethod(asset, disposeMethod, []);
        }
    }

    /** This method is called during loading of assets when 'verbose' is activated. Per
     *  default, it traces 'message' to the console. */
    private function log(message:String):Void
    {
        if (_verbose) trace("[AssetManager] " + message);
    }

    private function getDictionaryKeys(dictionary:Map<String, Dynamic>, prefix:String="",
                                              out:Vector<String>=null):Vector<String>
    {
        if (out == null) out = new Vector<String>();
        if (dictionary != null)
        {
            for (name in dictionary.keys())
                if (name.indexOf(prefix) == 0)
                    out.push(name);

            out.sort(compareString);
        }
        return out;
    }

    private function getUniqueName():String
    {
        return NO_NAME + "-" + sNoNameCount++;
    }
    
    private function compareString(a:String, b:String) {return (a < b) ? -1 : (a > b) ? 1 : 0;}
    
    private function compareAssetFactoriesPriorities(a:AssetFactory, b:AssetFactory):Int
    {
        if (a.priority == b.priority) return 0;
        return a.priority > b.priority ? -1 : 1;
    }
    
    private function compareAssetPostProcessorsPriorities(a:AssetPostProcessor, b:AssetPostProcessor):Int
    {
        if (a.priority == b.priority) return 0;
        return a.priority > b.priority ? -1 : 1;
    }

    // properties

    /** When activated, the class will trace information about added/enqueued assets.
     *  @default true */
    public var verbose(get, set):Bool;
    private function get_verbose():Bool { return _verbose; }
    private function set_verbose(value:Bool):Bool { return _verbose = value; }

    /** Returns the number of raw assets that have been enqueued, but not yet loaded. */
    public var numQueuedAssets(get, never):Int;
    private function get_numQueuedAssets():Int { return _queue.length; }

    /** The maximum number of parallel connections that are spawned when loading the queue.
     *  More connections can reduce loading times, but require more memory. @default 3. */
    public var numConnections(get, set):Int;
    private function get_numConnections():Int { return _numConnections; }
    private function set_numConnections(value:Int):Int
    {
        return _numConnections = Std.int(MathUtil.max(1, value));
    }

    /** Textures will be created with the options set up in this object at the time of
     *  enqueuing. */
    public var textureOptions(get, set):TextureOptions;
    private function get_textureOptions():TextureOptions { return _textureOptions; }
    private function set_textureOptions(value:TextureOptions):TextureOptions 
    {
        _textureOptions.copyFrom(value);
        return _textureOptions;
    }

    /** The DataLoader is used to load any data from files or URLs. If you need to customize
     *  its behavior (e.g. to add a caching mechanism), assign your custom instance here. */
    public var dataLoader(get, set):DataLoader;
    private function get_dataLoader():DataLoader { return _dataLoader; }
    private function set_dataLoader(value:DataLoader):DataLoader { return _dataLoader = value; }

    /** Indicates if bitmap fonts should be registered with their "face" attribute from the
     *  font XML file. Per default, they are registered with the name of the texture file.
     *  @default false */
    public var registerBitmapFontsWithFontFace(get, set):Bool;
    private function get_registerBitmapFontsWithFontFace():Bool { return _registerBitmapFontsWithFontFace; }
    private function set_registerBitmapFontsWithFontFace(value:Bool):Bool { return _registerBitmapFontsWithFontFace = value; }
}

class AssetPostProcessor
{
    private var _priority:Int;
    private var _callback:AssetManager->Void;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (AssetPostProcessor.prototype, {
            "priority": { get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_priority (); }") },
        });
        
    }
    #end

    public function new(callback:AssetManager->Void, priority:Int)
    {
        if (callback == null)
            throw new ArgumentError("callback must be a function " +
                "accepting one 'AssetStore' parameter");

        _callback = callback;
        _priority = priority;
    }

    @:allow(starling) private function execute(store:AssetManager):Void
    {
        _callback(store);
    }

    public var priority(get, never):Int;
    private function get_priority():Int { return _priority; }
}

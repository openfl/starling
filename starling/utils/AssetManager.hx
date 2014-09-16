package starling.utils;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import haxe.Json;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
//import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
//import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.system.System;
import flash.utils.ByteArray;
//import flash.utils.Dictionary;
//import flash.utils.clearTimeout;
//import flash.utils.describeType;
//import flash.utils.Type.getClassName;
//import flash.utils.setTimeout;

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
//[Event(name="texturesRestored", type="starling.events.Event")]

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
 */
class AssetManager extends EventDispatcher
{
    // This HTTPStatusEvent is only available in AIR
    inline private static var HTTP_RESPONSE_STATUS:String = "httpResponseStatus";

    private var mStarling:Starling;
    private var mNumLostTextures:Int;
    private var mNumRestoredTextures:Int;

    private var mDefaultTextureOptions:TextureOptions;
    private var mCheckPolicyFile:Bool;
    private var mKeepAtlasXmls:Bool;
    private var mKeepFontXmls:Bool;
    private var mVerbose:Bool;
    
    private var mQueue:Array<Dynamic>;
    private var mIsLoading:Bool;
    private var mTimeoutID:UInt;
    
    private var mTextures:Map<String, Texture>;
    private var mAtlases:Map<String, TextureAtlas>;
    private var mSounds:Map<String, Sound>;
    private var mXmls:Map<String, Xml>;
    private var mObjects:Map<String, Dynamic>;
    private var mByteArrays:Map<String, ByteArray>;
    
    /** helper objects */
    private static var sNames:Array<String> = new Array<String>();
    
    /** Regex for name / extension extraction from URL. */
    private static var NAME_REGEX:EReg = ~/([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;

    /** Create a new AssetManager. The 'scaleFactor' and 'useMipmaps' parameters define
     *  how enqueued bitmaps will be converted to textures. */
    public function new(scaleFactor:Float=1, useMipmaps:Bool=false)
    {
        mDefaultTextureOptions = new TextureOptions(scaleFactor, useMipmaps);
        mTextures = new Map<String, Texture>();
        mAtlases = new Map<String, TextureAtlas>();
        mSounds = new Map<String, Sound>();
        mXmls = new Map<String, Xml>();
        mObjects = new Map<String, Dynamic>();
        mByteArrays = new Map<String, ByteArray>();
        mQueue = [];
    }
    
    /** Disposes all contained textures. */
    public function dispose():Void
    {
        for(texture in mTextures)
            texture.dispose();
        
        for(atlas in mAtlases)
            atlas.dispose();
        
        //for(xml in mXmls)
        //    System.disposeXML(xml);
        
        for(byteArray in mByteArrays)
            byteArray.clear();
    }
    
    // retrieving
    
    /** Returns a texture with a certain name. The method first looks through the directly
     *  added textures; if no texture with that name is found, it scans through all 
     *  texture atlases. */
    public function getTexture(name:String):Texture
    {
        if (mTextures.exists(name)) return mTextures[name];
        else
        {
            for(atlas in mAtlases)
            {
                var texture:Texture = atlas.getTexture(name);
                if (texture != null) return texture;
            }
            return null;
        }
    }
    
    /** Returns all textures that start with a certain string, sorted alphabetically
     *  (especially useful for "MovieClip"). */
    public function getTextures(prefix:String="", result:Array<Texture>=null):Array<Texture>
    {
        if (result == null) result = new Array<Texture>();
        
        for (name in getTextureNames(prefix, sNames))
            result.push(getTexture(name));
        
        sNames = [];
        return result;
    }
    
    /** Returns all texture names that start with a certain string, sorted alphabetically. */
    public function getTextureNames(prefix:String="", result:Array<String>=null):Array<String>
    {
        result = getDictionaryKeys(mTextures, prefix, result);
        
        for(atlas in mAtlases)
            atlas.getNames(prefix, result);
        
        result.sort(compare);
        return result;
    }
    
    /** Returns a texture atlas with a certain name, or null if it's not found. */
    public function getTextureAtlas(name:String):TextureAtlas
    {
        return cast(mAtlases[name], TextureAtlas);
    }
    
    /** Returns a sound with a certain name, or null if it's not found. */
    public function getSound(name:String):Sound
    {
        return mSounds[name];
    }
    
    /** Returns all sound names that start with a certain string, sorted alphabetically.
     *  If you pass a result vector, the names will be added to that vector. */
    public function getSoundNames(prefix:String="", result:Array<String>=null):Array<String>
    {
        return getDictionaryKeys(mSounds, prefix, result);
    }
    
    /** Generates a new SoundChannel object to play back the sound. This method returns a 
     *  SoundChannel object, which you can access to stop the sound and to control volume. */ 
    public function playSound(name:String, startTime:Float=0, loops:Int=0, 
                              transform:SoundTransform=null):SoundChannel
    {
        if (mSounds.exists(name))
            return getSound(name).play(startTime, loops, transform);
        else 
            return null;
    }
    
    /** Returns an XML with a certain name, or null if it's not found. */
    public function getXml(name:String):Xml
    {
        return mXmls[name];
    }
    
    /** Returns all XML names that start with a certain string, sorted alphabetically. 
     *  If you pass a result vector, the names will be added to that vector. */
    public function getXmlNames(prefix:String="", result:Array<String>=null):Array<String>
    {
        return getDictionaryKeys(mXmls, prefix, result);
    }

    /** Returns an object with a certain name, or null if it's not found. Enqueued JSON
     *  data is parsed and can be accessed with this method. */
    public function getObject(name:String):Dynamic
    {
        return mObjects[name];
    }
    
    /** Returns all object names that start with a certain string, sorted alphabetically. 
     *  If you pass a result vector, the names will be added to that vector. */
    public function getObjectNames(prefix:String="", result:Array<String>=null):Array<String>
    {
        return getDictionaryKeys(mObjects, prefix, result);
    }
    
    /** Returns a byte array with a certain name, or null if it's not found. */
    public function getByteArray(name:String):ByteArray
    {
        return mByteArrays[name];
    }
    
    /** Returns all byte array names that start with a certain string, sorted alphabetically. 
     *  If you pass a result vector, the names will be added to that vector. */
    public function getByteArrayNames(prefix:String="", result:Array<String>=null):Array<String>
    {
        return getDictionaryKeys(mByteArrays, prefix, result);
    }
    
    // direct adding
    
    /** Register a texture under a certain name. It will be available right away.
     *  If the name was already taken, the existing texture will be disposed and replaced
     *  by the new one. */
    public function addTexture(name:String, texture:Texture):Void
    {
        log("Adding texture '" + name + "'");
        
        if (mTextures.exists(name))
        {
            log("Warning: name was already in use; the previous texture will be replaced.");
            mTextures[name].dispose();
        }
        
        mTextures[name] = texture;
    }
    
    /** Register a texture atlas under a certain name. It will be available right away. 
     *  If the name was already taken, the existing atlas will be disposed and replaced
     *  by the new one. */
    public function addTextureAtlas(name:String, atlas:TextureAtlas):Void
    {
        log("Adding texture atlas '" + name + "'");
        
        if (mAtlases.exists(name))
        {
            log("Warning: name was already in use; the previous atlas will be replaced.");
            mAtlases[name].dispose();
        }
        
        mAtlases[name] = atlas;
    }
    
    /** Register a sound under a certain name. It will be available right away.
     *  If the name was already taken, the existing sound will be replaced by the new one. */
    public function addSound(name:String, sound:Sound):Void
    {
        log("Adding sound '" + name + "'");
        
        if (mSounds.exists(name))
            log("Warning: name was already in use; the previous sound will be replaced.");

        mSounds[name] = sound;
    }
    
    /** Register an XML object under a certain name. It will be available right away.
     *  If the name was already taken, the existing XML will be disposed and replaced
     *  by the new one. */
    public function addXml(name:String, xml:Xml):Void
    {
        log("Adding XML '" + name + "'");
        
        if (mXmls.exists(name))
        {
            log("Warning: name was already in use; the previous XML will be replaced.");
            //System.disposeXML(mXmls[name]);
        }

        mXmls[name] = xml;
    }
    
    /** Register an arbitrary object under a certain name. It will be available right away. 
     *  If the name was already taken, the existing object will be replaced by the new one. */
    public function addObject(name:String, object:Dynamic):Void
    {
        log("Adding object '" + name + "'");
        
        if (mObjects.exists(name))
            log("Warning: name was already in use; the previous object will be replaced.");
        
        mObjects[name] = object;
    }
    
    /** Register a byte array under a certain name. It will be available right away.
     *  If the name was already taken, the existing byte array will be cleared and replaced
     *  by the new one. */
    public function addByteArray(name:String, byteArray:ByteArray):Void
    {
        log("Adding byte array '" + name + "'");
        
        if (mByteArrays.exists(name))
        {
            log("Warning: name was already in use; the previous byte array will be replaced.");
            mByteArrays[name].clear();
        }
        
        mByteArrays[name] = byteArray;
    }
    
    // removing
    
    /** Removes a certain texture, optionally disposing it. */
    public function removeTexture(name:String, dispose:Bool=true):Void
    {
        log("Removing texture '" + name + "'");
        
        if (dispose && mTextures.exists(name))
            mTextures[name].dispose();
        
        mTextures.remove(name);
    }
    
    /** Removes a certain texture atlas, optionally disposing it. */
    public function removeTextureAtlas(name:String, dispose:Bool=true):Void
    {
        log("Removing texture atlas '" + name + "'");
        
        if (dispose && mAtlases.exists(name))
            mAtlases[name].dispose();
        
        mAtlases.remove(name);
    }
    
    /** Removes a certain sound. */
    public function removeSound(name:String):Void
    {
        log("Removing sound '"+ name + "'");
        mSounds.remove(name);
    }
    
    /** Removes a certain Xml object, optionally disposing it. */
    public function removeXml(name:String, dispose:Bool=true):Void
    {
        log("Removing xml '"+ name + "'");
        
        //if (dispose && mXmls.exists(name))
        //    System.disposeXML(mXmls[name]);
        
        mXmls.remove(name);
    }
    
    /** Removes a certain object. */
    public function removeObject(name:String):Void
    {
        log("Removing object '"+ name + "'");
        mObjects.remove(name);
    }
    
    /** Removes a certain byte array, optionally disposing its memory right away. */
    public function removeByteArray(name:String, dispose:Bool=true):Void
    {
        log("Removing byte array '"+ name + "'");
        
        if (dispose && mByteArrays.exists(name))
            mByteArrays[name].clear();
        
        mByteArrays.remove(name);
    }
    
    /** Empties the queue and aborts any pending load operations. */
    public function purgeQueue():Void
    {
        mIsLoading = false;
        mQueue = [];
        //clearTimeout(mTimeoutID);
        dispatchEventWith(Event.CANCEL);
    }
    
    /** Removes assets of all types, empties the queue and aborts any pending load operations.*/
    public function purge():Void
    {
        log("Purging all assets, emptying queue");
        
        purgeQueue();
        dispose();

        mTextures = new Map<String, Texture>();
        mAtlases = new Map<String, TextureAtlas>();
        mSounds = new Map<String, Sound>();
        mXmls = new Map<String, Xml>();
        mObjects = new Map<String, Dynamic>();
        mByteArrays = new Map<String, ByteArray>();
    }
    
    // queued adding
    
    /** Enqueues one or more raw assets; they will only be available after successfully 
     *  executing the "loadQueue" method. This method accepts a variety of different objects:
     *  
     *  <ul>
     *    <li>Strings containing an URL to a local or remote resource. Supported types:
     *        <code>png, jpg, gif, atf, mp3, xml, fnt, json, binary</code>.</li>
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
     *  <p>XMLs that contain texture atlases or bitmap fonts are processed directly: fonts are
     *  registered at the TextField class, atlas textures can be acquired with the
     *  "getTexture()" method. All other XMLs are available via "getXml()".</p>
     *  
     *  <p>If you pass in JSON data, it will be parsed into an object and will be available via
     *  "getObject()".</p>
     */
    public function enqueue(rawAssets:Array<Dynamic>):Void
    {
        for(rawAsset in rawAssets)
        {
            if (Std.is(rawAsset, Array))
            {
                enqueue(rawAsset);
            }
/*            else if (Std.is(rawAsset, Class))
            {
                var cls:Class<Dynamic> = cast(rawAsset, Class<Dynamic>);
                if (mVerbose)
                    log("Looking for static embedded assets in '" + 
                        cls + "'"); 
                
                for (childNode in typeXml.constant.att.type == "Class")
                    enqueueWithName(rawAsset[childNode.att.name], childNode.att.name);
                
                for (childNode in typeXml.variable.att.type == "Class")
                    enqueueWithName(rawAsset[childNode.att.name], childNode.att.name);
            }
            else if (Type.getClassName(rawAsset) == "flash.filesystem::File")
            {
                if (!rawAsset["exists"])
                {
                    log("File or directory not found: '" + rawAsset["url"] + "'");
                }
                else if (!rawAsset["isHidden"])
                {
                    if (rawAsset["isDirectory"])
                        enqueue(rawAsset["getDirectoryListing"]());
                    else
                        enqueueWithName(rawAsset);
                }
            }*/
            else if (Std.is(rawAsset, String))
            {
                enqueueWithName(rawAsset);
            }
            else
            {
                log("Ignoring unsupported asset type: " + Type.getClassName(rawAsset));
            }
        }
    }
    
    /** Enqueues a single asset with a custom name that can be used to access it later.
     *  If the asset is a texture, you can also add custom texture options.
     *  
     *  @param asset:   The asset that will be enqueued; accepts the same objects as the
     *                  'enqueue' method.
     *  @param name:    The name under which the asset will be found later. If you pass null or
     *                  omit the parameter, it's attempted to generate a name automatically.
     *  @param options: Custom options that will be used if 'asset' points to texture data.
     *  @return         the name under which the asset was registered. */
    public function enqueueWithName(asset:Dynamic, name:String=null,
                                    options:TextureOptions=null):String
    {
        //if (Type.getClassName(asset) == "flash.filesystem::File")
        //    asset = unescape(asset["url"]);
        
        if (name == null)    name = getName(asset);
        if (options == null) options = mDefaultTextureOptions;
        else                 options = options.clone();
        
        log("Enqueuing '" + name + "'");
        
        mQueue.push({
            name: name,
            asset: asset,
            options: options
        });
        
        return name;
    }
    
    /** Loads all enqueued assets asynchronously. The 'onProgress' function will be called
     *  with a 'ratio' between '0.0' and '1.0', with '1.0' meaning that it's complete.
     *
     *  <p>When you call this method, the manager will save a reference to "Starling.current";
     *  all textures that are loaded will be accessible only from within this instance. Thus,
     *  if you are working with more than one Starling instance, be sure to call
     *  "makeCurrent()" on the appropriate instance before processing the queue.</p>
     *
     *  @param onProgress: <code>function(ratio:Float):Void;</code> 
     */
    public function loadQueue(onProgress:Float->Void):Void
    {
        mStarling = Starling.current;
        
        if (mStarling == null || mStarling.context == null)
            throw new Error("The Starling instance needs to be ready before textures can be loaded.");
        
        if (mIsLoading)
            throw new Error("The queue is already being processed");
        
        var xmls:Array<Xml> = new Array<Xml>();
        var numElements:Int = mQueue.length;
        var currentRatio:Float = 0.0;
        
        mIsLoading = true;

        var processNext:Void->Void = null;
        var processXmls:Void->Void = null;
        var progress:Float->Void = null;
        function resume():Void
        {
            currentRatio = mQueue.length != 0 ? 1.0 - (mQueue.length / numElements) : 1.0;
            
            if (mQueue.length != 0)
                processNext();//mTimeoutID = setTimeout(processNext, 1);
            else
            {
                processXmls();
                mIsLoading = false;
            }
            
            if (onProgress != null)
                onProgress(currentRatio);
        }
        
        processNext = function():Void
        {
            var assetInfo:Dynamic = mQueue.shift();
            //clearTimeout(mTimeoutID);
            processRawAsset(assetInfo.name, assetInfo.asset, assetInfo.options,
                            xmls, progress, resume);
        }
        
        processXmls = function():Void
        {
            // xmls are processed seperately at the end, because the textures they reference
            // have to be available for other XMLs. Texture atlases are processed first:
            // that way, their textures can be referenced, too.
            
            xmls.sort(function(a:Xml, b:Xml):Int { 
                return a.nodeName.split(":").pop() == "TextureAtlas" ? -1 : 1; 
            });
            
            for(xml in xmls)
            {
                var name:String;
                var texture:Texture;
                var rootNode:String = xml.nodeName.split(":").pop();
                
                if (rootNode == "TextureAtlas")
                {
                    name = getName(xml.get("imagePath").toString());
                    texture = getTexture(name);
                    
                    if (texture != null)
                    {
                        addTextureAtlas(name, new TextureAtlas(texture, xml));

                        if (mKeepAtlasXmls) addXml(name, xml);
                        //else System.disposeXML(xml);
                    }
                    else log("Cannot create atlas: texture '" + name + "' is missing.");
                }
                else if (rootNode == "font")
                {
                    name = getName(xml.elementsNamed("pages").next().elementsNamed("page").next().get("file"));
                    texture = getTexture(name);
                    
                    if (texture != null)
                    {
                        log("Adding bitmap font '" + name + "'");
                        TextField.registerBitmapFont(new BitmapFont(texture, xml), name);

                        if (mKeepFontXmls) addXml(name, xml);
                        //else System.disposeXML(xml);
                    }
                    else log("Cannot create bitmap font: texture '" + name + "' is missing.");
                }
                else
                    throw new Error("XML contents not recognized: " + rootNode);
            }
        }
        
        progress = function(ratio:Float):Void
        {
            onProgress(currentRatio + (1.0 / numElements) * Math.min(1.0, ratio) * 0.99);
        }
        resume();
    }
    
    private function processRawAsset(name:String, rawAsset:Dynamic, options:TextureOptions,
                                     xmls:Array<Xml>,
                                     onProgress:Float->Void, onComplete:Void->Void):Void
    {
        var canceled:Bool = false;

        var cancel:Void->Void = null;
        function process(asset:Dynamic):Void
        {
            var texture:Texture;
            var bytes:ByteArray;
            
            // the 'current' instance might have changed by now
            // if we're running in a set-up with multiple instances.
            mStarling.makeCurrent();
            
            if (canceled)
            {
                // do nothing
            }
            else if (asset == null)
            {
                onComplete();
            }
            else if (Std.is(asset, Sound))
            {
                addSound(name, cast(asset, Sound));
                onComplete();
            }
            else if (Std.is(asset, Xml))
            {
                var xml:Xml = cast(asset, Xml);
                var firstElement:Xml = xml.firstElement();
                var rootNode:String = firstElement.nodeName.split(":").pop();
                
                if (rootNode == "TextureAtlas" || rootNode == "font")
                    xmls.push(firstElement);
                else
                    addXml(name, firstElement);
                
                onComplete();
            }
            else if (Starling.handleLostContext && mStarling.context.driverInfo == "Disposed")
            {
                log("Context lost while processing assets, retrying ...");
                //setTimeout(process, 1, asset);
                process(asset);
                return; // to keep CANCEL event listener intact
            }
            else if (Std.is(asset, Bitmap))
            {
                texture = Texture.fromData(asset, options);
                texture.root.onRestore = function():Void
                {
                    mNumLostTextures++;
                    loadRawAsset(rawAsset, null, function(asset:Dynamic):Void
                    {
                        try { texture.root.uploadBitmap(cast(asset, Bitmap)); }
                        catch (e:Error) { log("Texture restoration failed: " + e.message); }
                        
                        asset.bitmapData.dispose();
                        mNumRestoredTextures++;
                        
                        if (mNumLostTextures == mNumRestoredTextures)
                            dispatchEventWith(Event.TEXTURES_RESTORED);
                    });
                };

                asset.bitmapData.dispose();
                addTexture(name, texture);
                onComplete();
            }
            else if (Std.is(asset, ByteArray))
            {
                bytes = cast(asset, ByteArray);
                
                if (AtfData.isAtfData(bytes))
                {
                    options.onReady = onComplete;
                    texture = Texture.fromData(bytes, options);
                    texture.root.onRestore = function():Void
                    {
                        mNumLostTextures++;
                        loadRawAsset(rawAsset, null, function(asset:Dynamic):Void
                        {
                            try { texture.root.uploadAtfData(cast(asset, ByteArray), 0); }
                            catch (e:Error) { log("Texture restoration failed: " + e.message); }
                            
                            asset.clear();
                            mNumRestoredTextures++;
                            
                            if (mNumLostTextures == mNumRestoredTextures)
                                dispatchEventWith(Event.TEXTURES_RESTORED);
                        });
                    };
                    
                    bytes.clear();
                    addTexture(name, texture);
                }
                else if (byteArrayStartsWith(bytes, "{") || byteArrayStartsWith(bytes, "["))
                {
                    addObject(name, Json.parse(bytes.readUTFBytes(bytes.length)));
                    bytes.clear();
                    onComplete();
                }
                else if (byteArrayStartsWith(bytes, "<"))
                {
                    process(Xml.parse(bytes.toString()));
                    bytes.clear();
                }
                else
                {
                    addByteArray(name, bytes);
                    onComplete();
                }
            }
            else
            {
                log("Ignoring unsupported asset type: " + Type.getClassName(asset));
                onComplete();
            }
            
            // avoid that objects stay in memory (through 'onRestore' functions)
            asset = null;
            bytes = null;
            
            removeEventListener(Event.CANCEL, cancel);
        }
        
        function progress(ratio:Float):Void
        {
            if (!canceled) onProgress(ratio);
        }
        
        cancel = function():Void
        {
            canceled = true;
        }
        addEventListener(Event.CANCEL, cancel);
        loadRawAsset(rawAsset, progress, process);
    }
    
    private function loadRawAsset(rawAsset:Dynamic, onProgress:Float->Void, onComplete:Dynamic->Void):Void
    {
        var extension:String = null;
        var urlLoader:URLLoader = null;
        var url:String = null;

        var complete:Dynamic->Void = null;
        var onLoaderComplete:Dynamic->Void = null;
        function onIoError(event:IOErrorEvent):Void
        {
            log("IO error: " + event.text);
            complete(null);
        }
        
        function onHttpResponseStatus(event:HTTPStatusEvent):Void
        {
            if (extension == null)
            {
                var headers:Array<Dynamic> = event.responseHeaders;
                var contentType:String = getHttpHeader(headers, "Content-Type");

                if (contentType != null && ~/(audio|image)\//.split(contentType) != null)
                    extension = contentType.split("/").pop();
            }
        }

        function onLoadProgress(event:ProgressEvent):Void
        {
            if (onProgress != null)
                onProgress(event.bytesLoaded / event.bytesTotal);
        }
        
        function onUrlLoaderComplete(event:Dynamic):Void
        {
            var bytes:ByteArray = transformData(cast(urlLoader.data, ByteArray), url);
            var sound:Sound;
            
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
            urlLoader.removeEventListener(HTTP_RESPONSE_STATUS, onHttpResponseStatus);
            urlLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
            urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderComplete);
            
            if (extension != null)
                extension = extension.toLowerCase();

            switch (extension)
            {
                case "mpeg", "mp3":
                    sound = new Sound();
                    sound.loadCompressedDataFromByteArray(bytes, bytes.length);
                    bytes.clear();
                    complete(sound);
                case "jpg", "jpeg", "png", "gif":
                    //var loaderContext:LoaderContext = new LoaderContext(mCheckPolicyFile);
                    var loader:Loader = new Loader();
                    //loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
                    //loader.loadBytes(bytes, loaderContext);
                    loader.loadBytes(bytes);
                default: // any XML / JSON / binary data 
                    complete(bytes);
            }
        }
        
        onLoaderComplete = function(event:Dynamic):Void
        {
            urlLoader.data.clear();
            event.target.removeEventListener(Event.COMPLETE, onLoaderComplete);
            complete(event.target.content);
        }
        
        complete = function(asset:Dynamic):Void
        {
            // On mobile, it is not allowed / endorsed to make stage3D calls while the app
            // is in the background. Thus, we pause queue processing if that's the case.
            
            //if (SystemUtil.isDesktop)
                onComplete(asset);
            //else
            //    SystemUtil.executeWhenApplicationIsActive(onComplete, asset);
        }
        
        if (Std.is(rawAsset, Class))
        {
            //setTimeout(complete, 1, new rawAsset());
            Type.createInstance(rawAsset, []);
        }
        else if (Std.is(rawAsset, String))
        {
            url = cast(rawAsset, String);
            extension = getExtensionFromUrl(url);
            
            urlLoader = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            urlLoader.addEventListener(HTTP_RESPONSE_STATUS, onHttpResponseStatus);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
            urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
            urlLoader.load(new URLRequest(url));
        }
    }
    
    // helpers
    
    /** This method is called by 'enqueue' to determine the name under which an asset will be
     *  accessible; override it if you need a custom naming scheme. Typically, 'rawAsset' is 
     *  either a String or a FileReference. Note that this method won't be called for embedded
     *  assets. */
    private function getName(rawAsset:Dynamic):String
    {
        //var matches:Array;
        var name:String;
        
        if (Std.is(rawAsset, String)/* || Std.is(rawAsset, FileReference)*/)
        {
            //name = Std.is(rawAsset, String) ? cast(rawAsset, String) : cast(rawAsset, FileReference).name;
            name = cast(rawAsset, String);
            name = (~/%20/g).replace(name, " "); // URLs use '%20' for spaces
            name = getBasenameFromUrl(name);
            
            if (name != null) return name;
            else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
        }
        else
        {
            name = Type.getClassName(rawAsset);
            throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
        }
    }

    /** This method is called when raw byte data has been loaded from an URL or a file.
     *  Override it to process the downloaded data in some way (e.g. decompression) or
     *  to cache it on disk. */
    private function transformData(data:ByteArray, url:String):ByteArray
    {
        return data;
    }

    /** This method is called during loading of assets when 'verbose' is activated. Per
     *  default, it traces 'message' to the console. */
    private function log(message:String):Void
    {
        if (mVerbose) trace("[AssetManager]", message);
    }
    
    private function byteArrayStartsWith(bytes:ByteArray, char:String):Bool
    {
        var start:Int = 0;
        var length:Int = bytes.length;
        var wanted:Int = char.charCodeAt(0);
        
        // recognize BOMs
        
        if (length >= 4 &&
            (bytes.__get(0) == 0x00 && bytes.__get(1) == 0x00 && bytes.__get(2) == 0xfe && bytes.__get(3) == 0xff) ||
            (bytes.__get(0) == 0xff && bytes.__get(1) == 0xfe && bytes.__get(2) == 0x00 && bytes.__get(3) == 0x00))
        {
            start = 4; // UTF-32
        }
        else if (length >= 3 && bytes.__get(0) == 0xef && bytes.__get(1) == 0xbb && bytes.__get(2) == 0xbf)
        {
            start = 3; // UTF-8
        }
        else if (length >= 2 &&
            (bytes.__get(0) == 0xfe && bytes.__get(1) == 0xff) || (bytes.__get(0) == 0xff && bytes.__get(1) == 0xfe))
        {
            start = 2; // UTF-16
        }
        
        // find first meaningful letter
        
        for (i in start ... length)
        {
            var byte:Int = bytes.__get(i);
            if (byte == 0 || byte == 10 || byte == 13 || byte == 32) continue; // null, \n, \r, space
            else return byte == wanted;
        }
        
        return false;
    }
    
    private function getDictionaryKeys(dictionary:Map<String, Dynamic>, prefix:String="",
                                       result:Array<String>=null):Array<String>
    {
        if (result == null) result = new Array<String>();
        
        for (name in dictionary.keys())
            if (name.indexOf(prefix) == 0)
                result.push(name);
        
        //result.sort(Array.CASEINSENSITIVE);
        result.sort(compare);
        return result;
    }
    
    private function getHttpHeader(headers:Array<Dynamic>, headerName:String):String
    {
        if (headers != null)
        {
            for(header in headers)
                if (header.name == headerName) return header.value;
        }
        return null;
    }

    private function getBasenameFromUrl(url:String):String
    {
        var isMatched:Bool = NAME_REGEX.match(url);
        if (isMatched) return NAME_REGEX.matched(1);
        else return null;
    }

    private function getExtensionFromUrl(url:String):String
    {
        var isMatched:Bool = NAME_REGEX.match(url);
        if (isMatched) return NAME_REGEX.matched(2);
        else return null;
    }

    private function compare(a:String, b:String) {return (a < b) ? -1 : (a > b) ? 1 : 0;}

    // properties
    
    /** The queue contains one 'Object' for each enqueued asset. Each object has 'asset'
     *  and 'name' properties, pointing to the raw asset and its name, respectively. */
    private var queue(get, never):Array<Dynamic>;
    private function get_queue():Array<Dynamic> { return mQueue; }
    
    /** Returns the number of raw assets that have been enqueued, but not yet loaded. */
    public var numQueuedAssets(get, never):Int;
    public function get_numQueuedAssets():Int { return mQueue.length; }
    
    /** When activated, the class will trace information about added/enqueued assets. */
    public var verbose(get, set):Bool;
    public function get_verbose():Bool { return mVerbose; }
    public function set_verbose(value:Bool):Bool { return mVerbose = value; }
    
    /** For bitmap textures, this flag indicates if mip maps should be generated when they 
     *  are loaded; for ATF textures, it indicates if mip maps are valid and should be
     *  used. */
    public var useMipMaps(get, set):Bool;
    public function get_useMipMaps():Bool { return mDefaultTextureOptions.mipMapping; }
    public function set_useMipMaps(value:Bool):Bool { return mDefaultTextureOptions.mipMapping = value; }
    
    /** Textures that are created from Bitmaps or ATF files will have the scale factor 
     *  assigned here. */
    public var scaleFactor(get, set):Float;
    public function get_scaleFactor():Float { return mDefaultTextureOptions.scale; }
    public function set_scaleFactor(value:Float):Float { return mDefaultTextureOptions.scale = value; }
    
    /** Specifies whether a check should be made for the existence of a URL policy file before
     *  loading an object from a remote server. More information about this topic can be found 
     *  in the 'flash.system.LoaderContext' documentation. */
    public var checkPolicyFile(get, set):Bool;
    public function get_checkPolicyFile():Bool { return mCheckPolicyFile; }
    public function set_checkPolicyFile(value:Bool):Bool { return mCheckPolicyFile = value; }

    /** Indicates if atlas XML data should be stored for access via the 'getXml' method.
     *  If true, you can access an XML under the same name as the atlas.
     *  If false, XMLs will be disposed when the atlas was created. @default false. */
    public var keepAtlasXmls(get, set):Bool;
    public function get_keepAtlasXmls():Bool { return mKeepAtlasXmls; }
    public function set_keepAtlasXmls(value:Bool):Bool { return mKeepAtlasXmls = value; }

    /** Indicates if bitmap font XML data should be stored for access via the 'getXml' method.
     *  If true, you can access an XML under the same name as the bitmap font.
     *  If false, XMLs will be disposed when the font was created. @default false. */
    public var keepFontXmls(get, set):Bool;
    public function get_keepFontXmls():Bool { return mKeepFontXmls; }
    public function set_keepFontXmls(value:Bool):Bool { return mKeepFontXmls = value; }
}

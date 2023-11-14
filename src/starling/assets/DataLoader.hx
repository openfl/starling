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

import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestHeader;
import openfl.utils.ByteArray;

import starling.utils.Execute;

/** Loads binary data from a local or remote URL with a very simple callback system.
 *
 *  <p>The DataLoader is used by the AssetManager to load any local or remote data.
 *  Its single purpose is to get the binary data that's stored at a specific URL.</p>
 *
 *  <p>You can use this class for your own purposes (as an easier to use 'URLLoader'
 *  alternative), or you can extend the class to modify the AssetManager's behavior.
 *  E.g. you could extend this class to add a caching mechanism for remote assets.
 *  Assign an instance of your extended class to the AssetManager's <code>dataLoader</code>
 *  property.</p>
 */
class DataLoader
{
    // This HTTPStatusEvent is only available in AIR
    private static var HTTP_RESPONSE_STATUS:String = "httpResponseStatus";

    private var _urlLoaders:Map<URLLoader, Bool>;

    /** Creates a new DataLoader instance. */
    public function new()
    {
        _urlLoaders = new Map<URLLoader, Bool>();
    }

    /** Loads the binary data from a specific URL. Always supply both 'onComplete' and
     *  'onError' parameters; in case of an error, only the latter will be called.
     *
     *  <p>The 'onComplete' callback may have up to four parameters, all of them being optional.
     *  If you pass a callback that just takes zero or one, it will work just as well. The
     *  additional parameters may be used to describe the name and type of the downloaded
     *  data. They are not provided by the base class, but the AssetManager will check
     *  if they are available.</p>
     *
     * @param url          a String containing an URL.
     * @param onComplete   will be called when the data has been loaded.
     * <code>function(data:ByteArray, mimeType:String, name:String, extension:String):void</code>
     * @param onError      will be called in case of an error. The 2nd parameter is optional.
     *                     <code>function(error:String, httpStatus:int):void</code>
     * @param onProgress   will be called multiple times with the current load ratio (0-1).
     *                     <code>function(ratio:Number):void</code>
     */
    public function load(url:String, onComplete:?ByteArray->?String->?String->?String->Void,
                         onError:String->Void, onProgress:Float->Void=null):Void
    {
        var loader:URLLoader = null;
        var message:String;
        var mimeType:String = null;
        var httpStatus:Int = 0;
        var request:URLRequest = null;
        
        var cleanup:Void->Void = null;
        var onHttpResponseStatus:HTTPStatusEvent->Void = null;
        var onLoadError:ErrorEvent->Void = null;
        var onLoadProgress:ProgressEvent->Void = null;
        var onLoadComplete:Dynamic->Void = null;
        
        cleanup = function ():Void
        {
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
            loader.removeEventListener(HTTP_RESPONSE_STATUS, onHttpResponseStatus);
            loader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
            loader.removeEventListener(Event.COMPLETE, onLoadComplete);
            _urlLoaders.remove(loader);
        }

        onHttpResponseStatus = function (event:HTTPStatusEvent):Void
        {
            httpStatus = event.status;
            mimeType = getHttpHeader(event.responseHeaders, "Content-Type");
        }

        onLoadError = function (event:ErrorEvent):Void
        {
            cleanup();
            message = event.type + " - " + event.text;
            Execute.execute(onError, [message]);
        }

        onLoadProgress = function (event:ProgressEvent):Void
        {
            if (onProgress != null && event.bytesTotal > 0)
                onProgress(event.bytesLoaded / event.bytesTotal);
        }

        onLoadComplete = function (event:Dynamic):Void
        {
            cleanup();

            if (httpStatus < 400)
                Execute.execute(onComplete, [loader.data, mimeType]);
            else
                Execute.execute(onError, ["Unexpected HTTP status '" + httpStatus + "'. URL: " + request.url]);
        }
        
        request = new URLRequest(url);
        
        loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
        loader.addEventListener(HTTP_RESPONSE_STATUS, onHttpResponseStatus);
        loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
        loader.addEventListener(Event.COMPLETE, onLoadComplete);
        loader.load(request);

        _urlLoaders[loader] = true;
    }

    /** Aborts all current load operations. The loader can still be used, though. */
    public function close():Void
    {
        for (loader in _urlLoaders.keys())
        {
            try { loader.close(); }
            catch (e:Dynamic) {}
        }

        _urlLoaders =new Map<URLLoader, Bool>();
    }

    private static function getHttpHeader(headers:Array<URLRequestHeader>, headerName:String):String
    {
        if (headers != null)
        {
            for (header in headers)
                if (header.name == headerName) return header.value;
        }
        return null;
    }
}
package;

import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.system.System;
import openfl.utils.ByteArray;
import haxe.Timer;

import lime.system.System in LimeSystem;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.RenderTexture;
import starling.utils.AssetManager;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import starling.utils.SystemUtil;
import starling.utils.StringUtil.formatString;

import utils.ProgressBar;

class Scaffold extends Sprite
{
    private static inline var StageWidth:Int  = 320;
    private static inline var StageHeight:Int = 480;

    private var mStarling:Starling;
    private var mBackground:Loader;
    private var mProgressBar:ProgressBar;

    public function new()
    {
        super();

        // We develop the game in a *fixed* coordinate system of 320x480. The game might
        // then run on a device with a different resolution; for that case, we zoom the
        // viewPort to the optimal size for any display and load the optimal textures.

        var iOS:Bool = SystemUtil.platform == "IOS";
        var stageSize:Rectangle  = new Rectangle(0, 0, StageWidth, StageHeight);
        //var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        var screenSize:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        var viewPort:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL);
        var scaleFactor:Int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640

        Starling.multitouchEnabled = true; // useful on mobile devices
        Starling.handleLostContext = true; // recommended everywhere when using AssetManager
        RenderTexture.optimizePersistentBuffers = iOS; // safe on iOS, dangerous on Android

        mStarling = new Starling(Root, stage, viewPort, null, "auto", "auto");
        mStarling.stage.stageWidth    = StageWidth;  // <- same size on all devices!
        mStarling.stage.stageHeight   = StageHeight; // <- same size on all devices!
        mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():Void
        {
            loadAssets(scaleFactor, startGame);
        });

        mStarling.start();
        initElements(scaleFactor);

        // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
        // would report a very long 'passedTime' when the app is reactivated.

        if (!SystemUtil.isDesktop)
        {
            stage.addEventListener(
                flash.events.Event.ACTIVATE, function (e):Void { mStarling.start(); });
            stage.addEventListener(
                flash.events.Event.DEACTIVATE, function (e):Void { mStarling.stop(true); });
        }
    }

    private function loadAssets(scaleFactor:Int, onComplete:Dynamic):Void
    {
        // Our assets are loaded and managed by the 'AssetManager'. To use that class,
        // we first have to enqueue pointers to all assets we want it to load.

        var appDir:String = LimeSystem.applicationDirectory;
        if (appDir == null) appDir = "";
        var assets:AssetManager = new AssetManager(scaleFactor);

        assets.verbose = Capabilities.isDebugger;
        assets.enqueue([
            appDir + "/audio",
            appDir + formatString("/fonts/{0}x", [ scaleFactor ]),
            appDir + formatString("/textures/{0}x", [ scaleFactor ])
        ]);

        // Now, while the AssetManager now contains pointers to all the assets, it actually
        // has not loaded them yet. This happens in the "loadQueue" method; and since this
        // will take a while, we'll update the progress bar accordingly.

        assets.loadQueue(function(ratio:Float):Void
        {
            mProgressBar.ratio = ratio;
            if (ratio == 1)
            {
                // now would be a good time for a clean-up
                //System.pauseForGCIfCollectionImminent(0);
                System.gc();

                onComplete(assets);
            }
        });
    }

    private function startGame(assets:AssetManager):Void
    {
        var root:Root = cast mStarling.root;
        root.start(assets);
        Timer.delay(removeElements, 150); // delay to make 100% sure there's no flickering.
    }

    private function initElements(scaleFactor:Int):Void
    {
        // Add background image. By using "loadBytes", we can avoid any flickering.

        var appDir:String = LimeSystem.applicationDirectory;
        if (appDir == null) appDir = "assets";

        var bgPath:String = formatString("textures/{0}x/background.jpg", [scaleFactor]);
        var bgFile:String = appDir + "/" + bgPath;
        var bytes:ByteArray = ByteArray.fromFile(bgPath);

        mBackground = new Loader();
        mBackground.loadBytes(bytes);
        mBackground.scaleX = 1.0 / scaleFactor;
        mBackground.scaleY = 1.0 / scaleFactor;
        mStarling.nativeOverlay.addChild(mBackground);

        mBackground.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
            function(e:Dynamic):Void
            {
                cast (mBackground.content, Bitmap).smoothing = true;
            });

        // While the assets are loaded, we will display a progress bar.

        mProgressBar = new ProgressBar(175, 20);
        mProgressBar.x = (StageWidth - mProgressBar.width) / 2;
        mProgressBar.y =  StageHeight * 0.7;
        mStarling.nativeOverlay.addChild(mProgressBar);
    }

    private function removeElements():Void
    {
        if (mBackground != null)
        {
            mStarling.nativeOverlay.removeChild(mBackground);
            mBackground = null;
        }

        if (mProgressBar != null)
        {
            mStarling.nativeOverlay.removeChild(mProgressBar);
            mProgressBar = null;
        }
    }
}
package;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.system.Capabilities;
#if 0
import flash.utils.setTimeout;
#end
import haxe.Timer;
import openfl.Assets;
import openfl.display3D.Context3DRenderMode;
import openfl.errors.Error;
import openfl.geom.Rectangle;
import starling.display.Stage;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Max;
import starling.utils.RectangleUtil;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.RenderTexture;
import starling.utils.AssetManager;

import utils.ProgressBar;

// If you set this class as your 'default application', it will run without a preloader.
// To use a preloader, see 'Demo_Web_Preloader.as'.

// This project requires the sources of the "demo" project. Add them either by
// referencing the "demo/src" directory as a "source path", or by copying the files.
// The "media" folder of this project has to be added to its "source paths" as well,
// to make sure the icon and startup images are added to the compiled mobile app.

#if 0
[SWF(width="320", height="480", frameRate="60", backgroundColor="#222222")]
#end
class Demo_Web extends Sprite
{
    private var mStarling:Starling;
    private var mBackground:Bitmap;
    private var mProgressBar:ProgressBar;

    public function new()
    {
        super();
        if (stage != null) start();
        else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Dynamic):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        start();
    }

    private function start():Void
    {
        // We develop the game in a *fixed* coordinate system of 320x480. The game might
        // then run on a device with a different resolution; for that case, we zoom the
        // viewPort to the optimal size for any display and load the optimal textures.

        Starling.multitouchEnabled = true; // for Multitouch Scene
        Starling.handleLostContext = true; // recommended everywhere when using AssetManager
        RenderTexture.optimizePersistentBuffers = true; // should be safe on Desktop

        mStarling = new Starling(Game, stage, null, null, Context3DRenderMode.AUTO, "auto");
        mStarling.stage.stageWidth = Constants.GameWidth;
        mStarling.stage.stageHeight = Constants.GameHeight;
        mStarling.simulateMultitouch = true;
        mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.addEventListener(Event.ROOT_CREATED, function():Void
        {
            loadAssets(startGame);
        });
        
        this.stage.addEventListener(Event.RESIZE, onResize, false, Max.INT_MAX_VALUE, true);

        mStarling.start();
        initElements();
    }

    private function loadAssets(onComplete:AssetManager->Void):Void
    {
        // Our assets are loaded and managed by the 'AssetManager'. To use that class,
        // we first have to enqueue pointers to all assets we want it to load.

        var assets:AssetManager = new AssetManager();

        assets.verbose = Capabilities.isDebugger;
        #if 0
        assets.enqueue(EmbeddedAssets);
        #elseif 0
        assets.enqueue(
        [
            "assets/textures/1x/atlas.xml",
            "assets/textures/1x/atlas.png",
            "assets/textures/1x/background.jpg",
            #if 0
            "assets/textures/1x/compressed_texture.atf",
            #end
            "assets/fonts/1x/desyrel.fnt",
            "assets/fonts/1x/desyrel.png",
            "assets/audio/wing_flap.ogg"
        ]);
        #else
        Timer.delay(function()
        {
            var atlasTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/textures/1x/atlas.png"), false);
            var atlasXml:Xml = Xml.parse(Assets.getText("assets/textures/1x/atlas.xml")).firstElement();
            var desyrelTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/fonts/1x/desyrel.png"), false);
            var desyrelXml:Xml = Xml.parse(Assets.getText("assets/fonts/1x/desyrel.fnt")).firstElement();
            TextField.registerBitmapFont(new BitmapFont(desyrelTexture, desyrelXml));
            assets.addTexture("atlas", atlasTexture);
            assets.addTextureAtlas("atlas", new TextureAtlas(atlasTexture, atlasXml));
            assets.addTexture("background", Texture.fromBitmapData(Assets.getBitmapData("assets/textures/1x/background.jpg"), false));
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.ogg"));
            
            onComplete(assets);
        }, 0);
        #end

        // Now, while the AssetManager now contains pointers to all the assets, it actually
        // has not loaded them yet. This happens in the "loadQueue" method; and since this
        // will take a while, we'll update the progress bar accordingly.

        #if 0
        assets.loadQueue(function(ratio:Float):Void
        {
            #if 0
            mProgressBar.ratio = ratio;
            #end
            if (ratio == 1) onComplete(assets);
        });
        #end
    }

    private function startGame(assets:AssetManager):Void
    {
        var game:Game = cast(mStarling.root, Game);
        game.start(assets);
        Timer.delay(removeElements, 150); // delay to make 100% sure there's no flickering.
    }

    private function initElements():Void
    {
        // Add background image.

        #if 0
        mBackground = Type.createInstance(EmbeddedAssets.background, []);
        mBackground.smoothing = true;
        addChild(mBackground);

        // While the assets are loaded, we will display a progress bar.

        mProgressBar = new ProgressBar(175, 20);
        mProgressBar.x = (mBackground.width - mProgressBar.width) / 2;
        mProgressBar.y =  mBackground.height * 0.7;
        addChild(mProgressBar);
        #end
    }

    private function removeElements():Void
    {
        if (mBackground != null)
        {
            removeChild(mBackground);
            mBackground = null;
        }

        if (mProgressBar != null)
        {
            removeChild(mProgressBar);
            mProgressBar = null;
        }
    }
    
    private function onResize(e:openfl.events.Event):Void
    {
        var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        try
        {
            this.mStarling.viewPort = viewPort;
        }
        catch(error:Error) {}
    }
}
package;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display3D.Context3DRenderMode;
import flash.errors.Error;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.System;
import openfl.display.StageScaleMode;
import openfl.utils.ByteArray;

import haxe.Timer;

import openfl.Assets;
import openfl.Vector;

import starling.core.Starling;
import starling.display.Stage;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;
import starling.utils.Max;
import starling.utils.RectangleUtil;

import utils.ProgressBar;

class Demo extends Sprite
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
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
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
        var assets:AssetManager = new AssetManager();

        assets.verbose = Capabilities.isDebugger;

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
            #if flash
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.mp3"));
            var compressedTexture:ByteArray = Assets.getBytes("assets/textures/1x/compressed_texture.atf");
            assets.addByteArray("compressed_texture", compressedTexture);
            #else
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.ogg"));
            var compressedTexture:ByteArray = Assets.getBytes("assets/textures/1x/compressed_texture.atf.gzip");
            assets.addByteArray("compressed_texture", lime.utils.compress.GZip.decompress(compressedTexture));
            #end
            
            onComplete(assets);
        }, 0);
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

        mBackground = new Bitmap(Assets.getBitmapData("assets/textures/1x/background.jpg"));
        mBackground.smoothing = true;
        addChild(mBackground);

        // While the assets are loaded, we will display a progress bar.

        //mProgressBar = new ProgressBar(175, 20);
        //mProgressBar.x = (mBackground.width - mProgressBar.width) / 2;
        //mProgressBar.y =  mBackground.height * 0.7;
        //addChild(mProgressBar);
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
package;
import flash.display.Sprite;
import flash.system.Capabilities;
import openfl.Assets;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.errors.Error;
import openfl.events.TouchEvent;
import openfl.geom.Rectangle;
import starling.utils.Max;
import starling.utils.RectangleUtil;

import starling.core.Starling;
import starling.textures.Texture;
import starling.utils.AssetManager;
import starling.events.Event;

import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.events.MouseEvent;

import Game;

// If you set this class as your 'default application', it will run without a preloader.
// To use a preloader, see 'Demo_Web_Preloader.as'.

//[SWF(width="320", height="480", frameRate="60", backgroundColor="#222222")]
class Demo_Web extends Sprite
{
    //[Embed(source = "/startup.jpg")]
    //private var Background:Class<Dynamic>;
    
    private var mStarling:Starling;
    
    public function new()
    {
        super();

        if (stage != null) start();
        else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
    private function start():Void
    {
        var profile:Context3DProfile = Context3DProfile.BASELINE_CONSTRAINED;
        
        Starling.multitouchEnabled = true; // for Multitouch Scene
        //Starling.handleLostContext = true; // required on Windows, needs more memory
        
        mStarling = new Starling(Game, stage, new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), null, Context3DRenderMode.AUTO, profile);
        
        mStarling.statsDisplayFontName = Constants.DefaultFont;
        mStarling.simulateMultitouch = true;
        //mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.enableErrorChecking = false;
        mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        
        #if nodejs
        // check if gc is enabled
        if (untyped global.gc == null)
            trace("--expose-gc is not enabled.");
        #end
        
        mStarling.start();
        this.stage.addEventListener(Event.RESIZE, onResize, false, Max.INT_MAX_VALUE, true);
    }
    
    private function onAddedToStage(event:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        start();
    }
    
    private function onRootCreated(event:Event):Void
    {
        // set framerate to 30 in software mode
        //if (mStarling.context.driverInfo.toLowerCase().indexOf("software") != -1)
        //    mStarling.nativeStage.frameRate = 30;
        
        // define which resources to load
        var assets:AssetManager = new AssetManager();
        //assets.verbose = Capabilities.isDebugger;
        assets.verbose = true;
        //assets.enqueue();
        
        // background texture is embedded, because we need it right away!
        var bgTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("startup.jpg"), false);
        
        // load font
        Assets.getFont("assets/fonts/Ubuntu-R.ttf");
        
        // game will first load resources, then start menu
        var game = cast(event.data, Game);
        game.start(bgTexture, assets);
    }

    private function onResize(e:openfl.events.Event):Void
    {
        //this.mStarling.stage.stageWidth = this.stage.stageWidth;
        //this.mStarling.stage.stageHeight = this.stage.stageHeight;

        var viewPort:Rectangle = RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        try
        {
            this.mStarling.viewPort = viewPort;
        }
        catch(error:Error) {}
    }
}
package;
import flash.display.Sprite;
import flash.system.Capabilities;
import openfl.Assets;
import openfl.events.TouchEvent;
import openfl.geom.Rectangle;

import starling.core.Starling;
import starling.textures.Texture;
import starling.utils.AssetManager;
import starling.events.Event;

import starling.containers.View2D;

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
    private var _view:View2D;
    
    public function new()
    {
        super();
        stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

        if (stage != null) start();
        else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
    private function start():Void
    {
        //setup the view
        var profile:String = "baselineConstrained";
        var rect:Rectangle = new Rectangle(0, 0, 320, 480);
        _view = new View2D(false, profile, rect.width / rect.height);
        this.addChild(_view);
        
        Starling.multitouchEnabled = true; // for Multitouch Scene
        Starling.handleLostContext = true; // required on Windows, needs more memory
        
        mStarling = new Starling(Game, stage, rect, _view.stage3DProxy.stage3D, "auto", profile);
        mStarling.simulateMultitouch = true;
        //mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.enableErrorChecking = false;
        mStarling.start();
        _view.starlingPtr = mStarling;
        
        // this event is dispatched when stage3D is set up
        mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
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
        
        // add listeners
		_view.setRenderCallback(_onEnterFrame);
        
        // define which resources to load
        var assets:AssetManager = new AssetManager();
        //assets.verbose = Capabilities.isDebugger;
        assets.verbose = true;
        //assets.enqueue();
        
        // background texture is embedded, because we need it right away!
        var bgTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("startup.jpg"), false);
        
        // game will first load resources, then start menu
        var game = cast(event.data, Game);
        game.start(bgTexture, assets);
    }

    /**
    * render loop
    */
    private function _onEnterFrame(e:openfl.events.Event):Void
    {
        _view.render();
    }
}
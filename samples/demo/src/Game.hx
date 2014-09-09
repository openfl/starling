package;
import flash.system.System;
import flash.ui.Keyboard;
import openfl.Assets;
import starling.textures.TextureAtlas;

import scenes.Scene;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.textures.Texture;
import starling.utils.AssetManager;

import utils.ProgressBar;

class Game extends Sprite
{
    // Embed the Ubuntu Font. Beware: the 'embedAsCFF'-part IS REQUIRED!!!
    //[Embed(source="../../demo/assets/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
    private static var UbuntuRegular:Class<Dynamic>;
    
    private var mLoadingProgress:ProgressBar;
    private var mMainMenu:MainMenu;
    private var mCurrentScene:Scene;
    private var _container:Sprite;
    
    private static var sAssets:AssetManager;
    
    public function new()
    {
        super();
        // nothing to do here -- Startup will call "start" immediately.
    }
    
    public function start(background:Texture, assets:AssetManager):Void
    {
        sAssets = assets;
        
        // The background is passed into this method for two reasons:
        // 
        // 1) we need it right away, otherwise we have an empty frame
        // 2) the Startup class can decide on the right image, depending on the device.
        
        addChild(new Image(background));
        
        // The AssetManager contains all the raw asset data, but has not created the textures
        // yet. This takes some time (the assets might be loaded from disk or even via the
        // network), during which we display a progress indicator. 
        
        //mLoadingProgress = new ProgressBar(175, 20);
        //mLoadingProgress.x = (background.width  - mLoadingProgress.width) / 2;
        //mLoadingProgress.y = background.height * 0.7;
        //addChild(mLoadingProgress);
        //
        //assets.loadQueue(function(ratio:Float):Void
        //{
            //mLoadingProgress.ratio = ratio;
//
            //// a progress bar should always show the 100% for a while,
            //// so we show the main menu only after a short delay. 
            //
            //if (ratio == 1)
                //Starling.current.juggler.delayCall(function(unused:Dynamic):Void
                //{
                    //mLoadingProgress.removeFromParent(true);
                    //mLoadingProgress = null;
                    //showMainMenu();
                //}, 0.15, []);
        //});
        var atlasTexture:Texture = Texture.fromBitmapData(Assets.getBitmapData("assets/textures/1x/atlas.png"), false);
        var atlasXml:Xml = Xml.parse(Assets.getText("assets/textures/1x/atlas.xml"));
        var atlas:Xml = null;
        for (a in atlasXml.elementsNamed("TextureAtlas"))
            if (a.get("imagePath") == "atlas.png")
            {
                atlas = a;
                break;
            }
        assets.addTexture("atlas", atlasTexture);
        assets.addTextureAtlas("atlas_xml", new TextureAtlas(atlasTexture, atlas));
        
        addEventListener(Event.TRIGGERED, onButtonTriggered);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        showMainMenu();
    }
    
    private function showMainMenu():Void
    {
        // now would be a good time for a clean-up 
        //System.pauseForGCIfCollectionImminent(0);
        System.gc();
        
        if (mMainMenu == null)
            mMainMenu = new MainMenu();
        
        addChild(mMainMenu);
    }
    
    private function onKey(event:KeyboardEvent):Void
    {
        if (event.keyCode == Keyboard.SPACE)
            Starling.current.showStats = !Starling.current.showStats;
        else if (event.keyCode == Keyboard.X)
            Starling.current.context.dispose();
    }
    
    private function onButtonTriggered(event:Event):Void
    {
        var button:Button = cast(event.target, Button);
        
        if (button.name == "backButton")
            closeScene();
        else
            showScene(button.name);
    }
    
    private function closeScene():Void
    {
        mCurrentScene.removeFromParent(true);
        mCurrentScene = null;
        showMainMenu();
    }
    
    private function showScene(name:String):Void
    {
        if (mCurrentScene != null) return;
        
        var sceneClass:Class<Dynamic> = Type.resolveClass(name);
        mCurrentScene = Type.createInstance(sceneClass, []);
        mMainMenu.removeFromParent();
        addChild(mCurrentScene);
    }
    
    public static var assets(get, never):AssetManager;
    public static function get_assets():AssetManager { return sAssets; }
}
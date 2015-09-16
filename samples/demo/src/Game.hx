package;
import flash.system.System;
import flash.ui.Keyboard;
#if 0
import flash.utils.getDefinitionByName;
#end

import scenes.Scene;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.utils.AssetManager;

@:keep class Game extends Sprite
{
    // Embed the Ubuntu Font. Beware: the 'embedAsCFF'-part IS REQUIRED!!!
    #if 0
    [Embed(source="../../demo/assets/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
    private static const UbuntuRegular:Class;
    #end
    
    private var mMainMenu:MainMenu;
    private var mCurrentScene:Scene;
    
    private static var sAssets:AssetManager;
    
    public function new()
    {
        super();
        // nothing to do here -- Startup will call "start" immediately.
    }
    
    public function start(assets:AssetManager):Void
    {
        sAssets = assets;
        addChild(new Image(assets.getTexture("background")));
        showMainMenu();

        addEventListener(Event.TRIGGERED, onButtonTriggered);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
    }
    
    private function showMainMenu():Void
    {
        // now would be a good time for a clean-up
        #if 0
        System.pauseForGCIfCollectionImminent(0);
        #end
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
        mCurrentScene = cast(Type.createInstance(sceneClass, []), Scene);
        mMainMenu.removeFromParent();
        addChild(mCurrentScene);
    }
    
    public static var assets(get, never):AssetManager;
    @:noCompletion private static function get_assets():AssetManager { return sAssets; }
}
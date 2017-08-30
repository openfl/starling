package;

import openfl.system.System;
import openfl.ui.Keyboard;

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
    
    private var _mainMenu:MainMenu;
    private var _currentScene:Scene;
    
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
        
        if (_mainMenu == null)
            _mainMenu = new MainMenu();
        
        addChild(_mainMenu);
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
        _currentScene.removeFromParent(true);
        _currentScene = null;
        showMainMenu();
    }
    
    private function showScene(name:String):Void
    {
        if (_currentScene != null) return;
        
        var sceneClass:Class<Dynamic> = Type.resolveClass(name);
        _currentScene = cast(Type.createInstance(sceneClass, []), Scene);
        _mainMenu.removeFromParent();
        addChild(_currentScene);
    }
    
    public static var assets(get, never):AssetManager;
    @:noCompletion private static function get_assets():AssetManager { return sAssets; }
}
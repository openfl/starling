import System from "openfl/system/System";
import Keyboard from "openfl/ui/Keyboard";

import Scene from "./scenes/scene";
import MainMenu from "./mainMenu";

import Starling from "starling/core/Starling";
import Button from "starling/display/Button";
import Image from "starling/display/Image";
import Sprite from "starling/display/Sprite";
import Event from "starling/events/Event";
import KeyboardEvent from "starling/events/KeyboardEvent";
import AssetManager from "starling/utils/AssetManager";

class Game extends Sprite
{   
    private _mainMenu:MainMenu;
    private _currentScene:Scene;
    
    private static sAssets:AssetManager;
    
    public constructor()
    {
        super();
        // nothing to do here -- Startup will call "start" immediately.
    }
    
    public start(assets:AssetManager):void
    {
        Game.sAssets = assets;
        this.addChild(new Image(assets.getTexture("background")));
        this.showMainMenu();

        this.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
        this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
    }
    
    private showMainMenu():void
    {
        // now would be a good time for a clean-up
        System.gc();
        
        if (this._mainMenu == null)
            this._mainMenu = new MainMenu();
        
        this.addChild(this._mainMenu);
    }
    
    private onKey = (event:KeyboardEvent):void =>
    {
        if (event.keyCode == Keyboard.SPACE)
            Starling.current.showStats = !Starling.current.showStats;
        else if (event.keyCode == Keyboard.X)
            Starling.current.context.dispose();
    }
    
    private onButtonTriggered = (event:Event):void =>
    {
        var button:Button = event.target as Button;
        
        if (button.name == "backButton")
            this.closeScene();
        else
            this.showScene(button.name);
    }
    
    private closeScene():void
    {
        this._currentScene.removeFromParent(true);
        this._currentScene = null;
        this.showMainMenu();
    }
    
    private showScene(name:string):void
    {
        if (this._currentScene != null) return;
        
        var sceneClass = this._mainMenu.sceneClasses[name];
        this._currentScene = new sceneClass ();
        this._mainMenu.removeFromParent();
        this.addChild(this._currentScene);
    }
    
    public static get assets():AssetManager { return Game.sAssets; }
}

export default Game;
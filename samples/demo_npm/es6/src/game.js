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
    constructor()
    {
        super();
        // nothing to do here -- Startup will call "start" immediately.
    }
    
    start(assets)
    {
        Game.sAssets = assets;
        this.addChild(new Image(assets.getTexture("background")));
        this.showMainMenu();

        this.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
        this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
    }
    
    showMainMenu()
    {
        // now would be a good time for a clean-up
        System.gc();
        
        if (this._mainMenu == null)
            this._mainMenu = new MainMenu();
        
        this.addChild(this._mainMenu);
    }
    
    onKey = (event) =>
    {
        if (event.keyCode == Keyboard.SPACE)
            Starling.current.showStats = !Starling.current.showStats;
        else if (event.keyCode == Keyboard.X)
            Starling.current.context.dispose();
    }
    
    onButtonTriggered = (event) =>
    {
        var button = event.target;
        
        if (button.name == "backButton")
            this.closeScene();
        else
            this.showScene(button.name);
    }
    
    closeScene()
    {
        this._currentScene.removeFromParent(true);
        this._currentScene = null;
        this.showMainMenu();
    }
    
    showScene(name)
    {
        if (this._currentScene != null) return;
        
        var sceneClass = this._mainMenu.sceneClasses[name];
        this._currentScene = new sceneClass ();
        this._mainMenu.removeFromParent();
        this.addChild(this._currentScene);
    }
    
    static get assets() { return Game.sAssets; }
}

export default Game;
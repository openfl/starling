var System = require ("openfl/system/System").default;
var Keyboard = require ("openfl/ui/Keyboard").default;

var Starling = require ("starling/core/Starling").default;
var Button = require ("starling/display/Button").default;
var Image = require ("starling/display/Image").default;
var Sprite = require ("starling/display/Sprite").default;
var Event = require ("starling/events/Event").default;
var KeyboardEvent = require ("starling/events/KeyboardEvent").default;
var AssetManager = require ("starling/utils/AssetManager").default;

var Game = function()
{
    Sprite.call(this);
    
    this.onKey = this.onKey.bind(this);
    this.onButtonTriggered = this.onButtonTriggered.bind(this);
    // nothing to do here -- Startup will call "start" immediately.
}

Game.prototype = Object.create(Sprite.prototype);
Game.prototype.constructor = Game;

Game.prototype.start = function(assets)
{
    Game.sAssets = assets;
    this.addChild(new Image(assets.getTexture("background")));
    this.showMainMenu();

    this.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
    this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
}

Game.prototype.showMainMenu = function()
{
    // now would be a good time for a clean-up
    System.gc();
    
    if (this._mainMenu == null)
        this._mainMenu = new MainMenu();
    
    this.addChild(this._mainMenu);
}

Game.prototype.onKey = function(event)
{
    if (event.keyCode == Keyboard.SPACE)
        Starling.current.showStats = !Starling.current.showStats;
    else if (event.keyCode == Keyboard.X)
        Starling.current.context.dispose();
}

Game.prototype.onButtonTriggered = function(event)
{
    var button = event.target;
    
    if (button.name == "backButton")
        this.closeScene();
    else
        this.showScene(button.name);
}

Game.prototype.closeScene = function()
{
    this._currentScene.removeFromParent(true);
    this._currentScene = null;
    this.showMainMenu();
}

Game.prototype.showScene = function(name)
{
    if (this._currentScene != null) return;
    
    var sceneClass = this._mainMenu.sceneClasses[name];
    this._currentScene = new sceneClass ();
    this._mainMenu.removeFromParent();
    this.addChild(this._currentScene);
}

Object.defineProperty(Game, "assets", {
    get: function() { return Game.sAssets; }
});

module.exports.Game = Game;
module.exports.default = Game;

var Scene = require ("./scenes/scene").default;
var MainMenu = require ("./mainMenu").default;
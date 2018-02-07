var AnimationScene = require ("./scenes/animationScene").default;
var BenchmarkScene = require ("./scenes/benchmarkScene").default;
var BlendModeScene = require ("./scenes/blendModeScene").default;
var CustomHitTestScene = require ("./scenes/customHitTestScene").default;
var FilterScene = require ("./scenes/filterScene").default;
var MaskScene = require ("./scenes/maskScene").default;
var MovieScene = require ("./scenes/movieScene").default;
var RenderTextureScene = require ("./scenes/renderTextureScene").default;
var Sprite3DScene = require ("./scenes/sprite3DScene").default;
var TextScene = require ("./scenes/textScene").default;
var TextureScene = require ("./scenes/textureScene").default;
var TouchScene = require ("./scenes/touchScene").default;
// var VideoScene = require ("./scenes/videoScene").default;

var Starling = require ("starling/core/Starling").default;
var Button = require ("starling/display/Button").default;
var Image = require ("starling/display/Image").default;
var Sprite = require ("starling/display/Sprite").default;
var TouchEvent = require ("starling/events/TouchEvent").default;
var TouchPhase = require ("starling/events/TouchPhase").default;
var TextField = require ("starling/text/TextField").default;
var Align = require ("starling/utils/Align").default;

var MenuButton = require ("./utils/menuButton").default;
var Game = require ("./game").default;

var MainMenu = function()
{
    Sprite.call(this);
    
    this.onInfoTextTouched = this.onInfoTextTouched.bind(this);
    this.sceneClasses = [];
    
    this.init();
}

MainMenu.prototype = Object.create(Sprite.prototype);
MainMenu.prototype.constructor = MainMenu;

MainMenu.prototype.init = function()
{
    var logo = new Image(Game.assets.getTexture("logo"));
    this.addChild(logo);
    
    var scenesToCreate = [
        ["Textures", TextureScene],
        ["Multitouch", TouchScene],
        ["TextFields", TextScene],
        ["Animations", AnimationScene],
        ["Custom hit-test", CustomHitTestScene],
        ["Movie Clip", MovieScene],
        ["Filters", FilterScene],
        ["Blend Modes", BlendModeScene],
        ["Render Texture", RenderTextureScene],
        ["Benchmark", BenchmarkScene],
        ["Masks", MaskScene],
        ["Sprite 3D", Sprite3DScene]
        // ,["Video", VideoScene]
    ];
    
    var count = 0;
    
    for (var i = 0; i < scenesToCreate.length; i++)
    {
        var sceneToCreate = scenesToCreate[i];
        var sceneTitle = sceneToCreate[0];
        var sceneClass = sceneToCreate[1];
        
        var button = new MenuButton(sceneTitle);
        button.height = 42;
        button.readjustSize();
        button.x = count % 2 == 0 ? 28 : 167;
        button.y = /* 145 */ 155 + Math.floor(count / 2) * 46;
        button.name = this.sceneClasses.length;
        this.sceneClasses.push(sceneClass);
        this.addChild(button);
        
        if (scenesToCreate.length % 2 != 0 && count % 2 == 1)
            button.y += 24;
        
        ++count;
    }
    
    // show information about rendering method (hardware/software)
    
    var driverInfo = Starling.current.context.driverInfo;
    var infoText = new TextField(310, 64, driverInfo);
    infoText.format.font = "DejaVu Sans";
    infoText.format.size = 10;
    infoText.format.verticalAlign = Align.BOTTOM;
    infoText.x = 5;
    infoText.y = 475 - infoText.height;
    infoText.addEventListener(TouchEvent.TOUCH, this.onInfoTextTouched);
    this.addChildAt(infoText, 0);
}

MainMenu.prototype.onInfoTextTouched = function(event)
{
    if (event.getTouch(this, TouchPhase.ENDED) != null)
        Starling.current.showStats = !Starling.current.showStats;
}

module.exports.MainMenu = MainMenu;
module.exports.default = MainMenu;
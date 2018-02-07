'use strict';
var TextField = require ("starling/text/TextField").default;
var Align = require ("starling/utils/Align").default;

var RoundButton = require ("./../utils/roundButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var CustomHitTestScene = function()
{
    Scene.call(this);
    var description = 
        "Pushing the bird only works when the touch occurs within a circle." + 
        "This can be accomplished by overriding the method 'hitTest'.";
    
    var infoText = new TextField(300, 100, description);
    infoText.format.font = "DejaVu Sans";
    infoText.x = infoText.y = 10;
    infoText.format.verticalAlign = Align.TOP;
    infoText.format.horizontalAlign = Align.CENTER;
    this.addChild(infoText);
    
    // 'RoundButton' is a helper class of the Demo, not a part of Starling!
    // Have a look at its code to understand this sample.
    
    var button = new RoundButton(Game.assets.getTexture("starling_round"));
    button.x = (Constants.CenterX - button.width / 2);
    button.y = 150;
    this.addChild(button);
}

CustomHitTestScene.prototype = Object.create(Scene.prototype);
CustomHitTestScene.prototype.constructor = CustomHitTestScene;

module.exports.CustomHitTestScene = CustomHitTestScene;
module.exports.default = CustomHitTestScene;
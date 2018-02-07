import BlendMode from "starling/display/BlendMode";
import Button from "starling/display/Button";
import Image from "starling/display/Image";
import Event from "starling/events/Event";
import TextField from "starling/text/TextField";

import MenuButton from "./../utils/menuButton";
import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class BlendModeScene extends Scene
{
    _blendModes = [
        BlendMode.NORMAL,
        BlendMode.MULTIPLY,
        BlendMode.SCREEN,
        BlendMode.ADD,
        BlendMode.ERASE,
        BlendMode.NONE
    ];
    
    constructor()
    {
        super();
        
        this._button = new MenuButton("Switch Mode");
        this._button.x = (Constants.CenterX - this._button.width / 2);
        this._button.y = 15;
        this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
        this.addChild(this._button);
        
        this._image = new Image(Game.assets.getTexture("starling_rocket"));
        this._image.x = (Constants.CenterX - this._image.width / 2);
        this._image.y = 170;
        this.addChild(this._image);
        
        this._infoText = new TextField(300, 32);
        this._infoText.format.size = 19;
        this._infoText.format.font = "DejaVu Sans";
        this._infoText.x = 10;
        this._infoText.y = 330;
        this.addChild(this._infoText);
        
        this.onButtonTriggered();
    }
    
    onButtonTriggered = () =>
    {
        var blendMode = this._blendModes.shift();
        this._blendModes.push(blendMode);
        
        this._infoText.text = blendMode;
        this._image.blendMode = blendMode;
    }
}

export default BlendModeScene;
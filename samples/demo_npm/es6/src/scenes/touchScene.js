import Image from "starling/display/Image";
import TextField from "starling/text/TextField";
import MathUtil from "starling/utils/MathUtil";

import TouchSheet from "./../utils/touchSheet";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class TouchScene extends Scene
{
    constructor()
    {
        super();
        var description = "[use Ctrl/Cmd & Shift to simulate multi-touch]";
        
        var infoText = new TextField(300, 25, description);
        infoText.format.font = "DejaVu Sans";
        infoText.x = infoText.y = 10;
        this.addChild(infoText);
        
        // to find out how to react to touch events have a look at the TouchSheet class! 
        // It's part of the demo.
        
        var sheet = new TouchSheet(new Image(Game.assets.getTexture("starling_sheet")));
        sheet.x = Constants.CenterX;
        sheet.y = Constants.CenterY;
        sheet.rotation = MathUtil.deg2rad(10);
        this.addChild(sheet);
    }
}

export default TouchScene;
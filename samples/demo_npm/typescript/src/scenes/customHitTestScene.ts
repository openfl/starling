import TextField from "starling/text/TextField";
import Align from "starling/utils/Align";

import RoundButton from "./../utils/roundButton";
import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class CustomHitTestScene extends Scene
{
    public constructor()
    {
        super();
        var description:String = 
            "Pushing the bird only works when the touch occurs within a circle." + 
            "This can be accomplished by overriding the method 'hitTest'.";
        
        var infoText:TextField = new TextField(300, 100, description);
        infoText.format.font = "DejaVu Sans";
        infoText.x = infoText.y = 10;
        infoText.format.verticalAlign = Align.TOP;
        infoText.format.horizontalAlign = Align.CENTER;
        this.addChild(infoText);
        
        // 'RoundButton' is a helper class of the Demo, not a part of Starling!
        // Have a look at its code to understand this sample.
        
        var button:RoundButton = new RoundButton(Game.assets.getTexture("starling_round"));
        button.x = (Constants.CenterX - button.width / 2);
        button.y = 150;
        this.addChild(button);
    }
}

export default CustomHitTestScene;
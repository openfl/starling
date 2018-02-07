import Rectangle from "openfl/geom/Rectangle";

import Button from "starling/display/Button";
import Sprite from "starling/display/Sprite";

import MenuButton from "utils/MenuButton";
import Constants from "./../constants";

class Scene extends Sprite
{
    private _backButton:Button;
    
    public constructor()
    {
        super();
        // the main menu listens for TRIGGERED events, so we just need to add the button.
        // (the event will bubble up when it's dispatched.)
        
        this._backButton = new MenuButton("Back", 88, 50);
        this._backButton.x = Constants.CenterX - this._backButton.width / 2;
        this._backButton.y = Constants.GameHeight - this._backButton.height + 4;
        this._backButton.name = "backButton";
        this._backButton.textBounds.y -= 3;
        this._backButton.readjustSize(); // forces textBounds to update
        this.addChild(this._backButton);
    }
}

export default Scene;
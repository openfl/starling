import Rectangle from "openfl/geom/Rectangle";

import Button from "starling/display/Button";

import Game from "./../game";

/** A simple button that uses "scale9grid" with a single texture. */
class MenuButton extends Button
{
    constructor(text, width=128, height=32)
    {
        super(Game.assets.getTexture("button_normal"), text);
    
        this.textFormat.font = "DejaVu Sans";
        this.scale9Grid = new Rectangle(12.5, 12.5, 20, 20);
        this.width = width;
        this.height = height;
    }
}

export default MenuButton;
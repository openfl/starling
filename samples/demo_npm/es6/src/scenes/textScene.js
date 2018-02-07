import BitmapFont from "starling/text/BitmapFont";
import TextField from "starling/text/TextField";
import TextFormat from "starling/text/TextFormat";
import Align from "starling/utils/Align";
import Color from "starling/utils/Color";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class TextScene extends Scene
{
    constructor()
    {
        super();
        this.init();
    }

    init()
    {
        // TrueType fonts
        
        var offset = 10;
        var ttFont = "Ubuntu";
        var ttFontSize = 19;
        
        var colorTF = new TextField(300, 80, 
            "TextFields can have a border and a color. They can be aligned in different ways, ...");
        colorTF.format.setTo(ttFont, ttFontSize, 0x33399);
        colorTF.x = colorTF.y = offset;
        colorTF.border = true;
        this.addChild(colorTF);
        
        var leftTF = new TextField(145, 80, "... e.g.\ntop-left ...");
        leftTF.format.setTo(ttFont, ttFontSize, 0x996633);
        leftTF.format.horizontalAlign = Align.LEFT;
        leftTF.format.verticalAlign = Align.TOP;
        leftTF.x = offset;
        leftTF.y = colorTF.y + colorTF.height + offset;
        leftTF.border = true;
        this.addChild(leftTF);
        
        var rightTF = new TextField(145, 80, "... or\nbottom right ...");
        rightTF.format.setTo(ttFont, ttFontSize, 0x208020);
        rightTF.format.horizontalAlign = Align.RIGHT;
        rightTF.format.verticalAlign = Align.TOP;
        rightTF.border = true;
        rightTF.x = 2 * offset + leftTF.width;
        rightTF.y = leftTF.y;
        this.addChild(rightTF);
        
        var fontTF = new TextField(300, 80,
            "... or centered. Embedded fonts are detected automatically and " +
            "<font color='#208080'>support</font> " +
            "<font color='#996633'>basic</font> " +
            "<font color='#333399'>HTML</font> " +
            "<font color='#208020'>formatting</font>.");
        fontTF.format.setTo(ttFont, ttFontSize);
        fontTF.x = offset;
        fontTF.y = leftTF.y + leftTF.height + offset;
        fontTF.border = true;
        fontTF.isHtmlText = true;
        this.addChild(fontTF);

        // Bitmap fonts!
        
        // First, you will need to create a bitmap font texture.
        //
        // E.g. with this tool: www.angelcode.com/products/bmfont/ or one that uses the same
        // data format. Export the font data as an XML file, and the texture as a png with
        // white (!) characters on a transparent background (32 bit).
        //
        // Then, you just have to register the font at the TextField class.
        // Look at the file "Assets.as" to see how this is done.
        // After that, you can use them just like a conventional TrueType font.
        
        var bmpFontTF = new TextField(300, 150, 
            "It is very easy to use Bitmap fonts,\nas well!");
        bmpFontTF.format.font = "Desyrel";
        bmpFontTF.format.size = BitmapFont.NATIVE_SIZE; // the native bitmap font size, no scaling
        bmpFontTF.format.color = Color.WHITE; // white will draw the texture as is (no tinting)
        bmpFontTF.x = offset;
        bmpFontTF.y = fontTF.y + fontTF.height + offset;
        this.addChild(bmpFontTF);
        
        // A tip: you can also add the font-texture to your standard texture atlas!
    }
}

export default TextScene;
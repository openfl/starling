import BitmapData from "openfl/display/BitmapData";
import Error from "openfl/errors/Error";
import ByteArray from "openfl/utils/ByteArray";

import Image from "starling/display/Image";
import TextField from "starling/text/TextField";
import Texture from "starling/textures/Texture";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class TextureScene extends Scene
{
    public constructor()
    {
        super();
        // the flight textures are actually loaded from an atlas texture.
        // the "AssetManager" class wraps it away for us.
        
        var image1:Image = new Image(Game.assets.getTexture("flight_00"));
        image1.x = -20;
        image1.y = 0;
        this.addChild(image1);
        
        var image2:Image = new Image(Game.assets.getTexture("flight_04"));
        image2.x = 90;
        image2.y = 85;
        this.addChild(image2);
        
        var image3:Image = new Image(Game.assets.getTexture("flight_08"));
        image3.x = 100;
        image3.y = -60;
        this.addChild(image3);
        
        try
        {
            // display a compressed texture

            var compressedBA:ByteArray = Game.assets.getByteArray("compressed_texture");
            var compressedTexture:Texture = Texture.fromAtfData(compressedBA);
            var image4:Image = new Image(compressedTexture);
            image4.x = Constants.CenterX - image4.width / 2;
            image4.y = 280;
            this.addChild(image4);
        }
        catch (e)
        {
            // if it fails, it's probably not supported
            var textValue = "ATF textures are not fully supported in non Flash/Air targets.";
            var textField:TextField = new TextField(220, 128, textValue);
            textField.format.font = "DejaVu Sans";
            textField.format.size = 14;
            textField.x = Constants.CenterX - textField.width / 2;
            textField.y = 280;
            this.addChild(textField);
        }
    }
}

export default TextureScene;
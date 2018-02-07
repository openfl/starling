import BitmapData from "openfl/display/BitmapData";
import BitmapDataChannel from "openfl/display/BitmapDataChannel";

import Starling from "starling/core/Starling";
import Button from "starling/display/Button";
import Image from "starling/display/Image";
import Event from "starling/events/Event";
import BlurFilter from "starling/filters/BlurFilter";
import ColorMatrixFilter from "starling/filters/ColorMatrixFilter";
import DisplacementMapFilter from "starling/filters/DisplacementMapFilter";
import DropShadowFilter from "starling/filters/DropShadowFilter";
import FilterChain from "starling/filters/FilterChain";
import FragmentFilter from "starling/filters/FragmentFilter";
import GlowFilter from "starling/filters/GlowFilter";
import TextField from "starling/text/TextField";
import Texture from "starling/textures/Texture";

import MenuButton from "./../utils/menuButton";
import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class FilterScene extends Scene
{
    constructor()
    {
        super();
        
        this._button = new MenuButton("Switch Filter");
        this._button.x = (Constants.CenterX - this._button.width / 2);
        this._button.y = 15;
        this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
        this.addChild(this._button);
        
        this._image = new Image(Game.assets.getTexture("starling_rocket"));
        this._image.x = (Constants.CenterX - this._image.width / 2);
        this._image.y = 170;
        this.addChild(this._image);
        
        this._infoText = new TextField(300, 32);
        this._infoText.format.font = "DejaVu Sans";
        this._infoText.format.size = 19;
        this._infoText.x = 10;
        this._infoText.y = 330;
        this.addChild(this._infoText);
        
        this.initFilters();
        this.onButtonTriggered();
    }
    
    dispose()
    {
        this._displacementMap.dispose();
        super.dispose();
    }
    
    onButtonTriggered = () =>
    {
        var filterInfo = this._filterInfos.shift();
        this._filterInfos.push(filterInfo);
        
        this._infoText.text = filterInfo[0];
        this._image.filter  = filterInfo[1];
    }
    
    initFilters()
    {
        this._filterInfos = [
            ["Identity", new FragmentFilter()],
            ["Blur", new BlurFilter()],
            ["Drop Shadow", new DropShadowFilter()],
            ["Glow", new GlowFilter()]
        ];
        
        this._displacementMap = this.createDisplacementMap(this._image.width, this._image.height);
        
        var displacementFilter = new DisplacementMapFilter(
            this._displacementMap, BitmapDataChannel.RED, BitmapDataChannel.GREEN, 25, 25);
            this._filterInfos.push(["Displacement Map", displacementFilter]);
        
        var invertFilter = new ColorMatrixFilter();
        invertFilter.invert();
        this._filterInfos.push(["Invert", invertFilter]);
        
        var grayscaleFilter = new ColorMatrixFilter();
        grayscaleFilter.adjustSaturation(-1);
        this._filterInfos.push(["Grayscale", grayscaleFilter]);
        
        var saturationFilter = new ColorMatrixFilter();
        saturationFilter.adjustSaturation(1);
        this._filterInfos.push(["Saturation", saturationFilter]);
        
        var contrastFilter = new ColorMatrixFilter();
        contrastFilter.adjustContrast(0.75);
        this._filterInfos.push(["Contrast", contrastFilter]);

        var brightnessFilter = new ColorMatrixFilter();
        brightnessFilter.adjustBrightness(-0.25);
        this._filterInfos.push(["Brightness", brightnessFilter]);

        var hueFilter = new ColorMatrixFilter();
        hueFilter.adjustHue(1);
        this._filterInfos.push(["Hue", hueFilter]);
        
        var chain = new FilterChain([hueFilter, new DropShadowFilter()]);
        this._filterInfos.push(["Hue + Shadow", chain]);
    }
    
    createDisplacementMap(width, height)
    {
        var scale = Starling.current.contentScaleFactor;
        var map = new BitmapData((width*scale), (height*scale), false);
        map.perlinNoise(20*scale, 20*scale, 3, 5, false, true);
        var texture = Texture.fromBitmapData(map, false, false, scale);
        return texture;
    }
}

export default FilterScene;
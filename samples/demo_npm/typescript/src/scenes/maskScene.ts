import Point from "openfl/geom/Point";

import Starling from "starling/core/Starling";
import Canvas from "starling/display/Canvas";
import Image from "starling/display/Image";
import Quad from "starling/display/Quad";
import Sprite from "starling/display/Sprite";
import Touch from "starling/events/Touch";
import TouchEvent from "starling/events/TouchEvent";
import TouchPhase from "starling/events/TouchPhase";
import ColorMatrixFilter from "starling/filters/ColorMatrixFilter";
import TextField from "starling/text/TextField";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class MaskScene extends Scene
{
    private _contents:Sprite;
    private _mask2:Canvas;
    private _maskDisplay:Canvas;
    
    public constructor()
    {
        super();
        this._contents = new Sprite();
        this.addChild(this._contents);
        
        var stageWidth:number  = Starling.current.stage.stageWidth;
        var stageHeight:number = Starling.current.stage.stageHeight;
        
        var touchQuad:Quad = new Quad(stageWidth, stageHeight);
        touchQuad.alpha = 0; // only used to get touch events
        this.addChildAt(touchQuad, 0);
        
        var image:Image = new Image(Game.assets.getTexture("flight_00"));
        image.x = (stageWidth - image.width) / 2;
        image.y = 80;
        this._contents.addChild(image);

        // just to prove it works, use a filter on the image.
        var cm:ColorMatrixFilter = new ColorMatrixFilter();
        cm.adjustHue(-0.5);
        image.filter = cm;
        
        var maskText:TextField = new TextField(256, 128,
            "Move the mouse (or a finger) over the screen to move the mask.");
        maskText.format.font = "DejaVu Sans";
        maskText.x = (stageWidth - maskText.width) / 2;
        maskText.y = 260;
        maskText.format.size = 20;
        this._contents.addChild(maskText);
        
        this._maskDisplay = this.createCircle();
        this._maskDisplay.alpha = 0.1;
        this._maskDisplay.touchable = false;
        this.addChild(this._maskDisplay);

        this._mask2 = this.createCircle();
        this._contents.mask = this._mask2;
        
        this.addEventListener(TouchEvent.TOUCH, this.onTouch);
    }
    
    private onTouch = (event:TouchEvent):void =>
    {
        var touch:Touch = event.getTouch(this, TouchPhase.HOVER);
        if (touch == null) touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch == null) touch = event.getTouch(this, TouchPhase.MOVED);

        if (touch != null)
        {
            var localPos:Point = touch.getLocation(this);
            this._mask2.x = this._maskDisplay.x = localPos.x;
            this._mask2.y = this._maskDisplay.y = localPos.y;
        }
    }

    private createCircle():Canvas
    {
        var circle:Canvas = new Canvas();
        circle.beginFill(0xEA8220);
        circle.drawCircle(0, 0, 100);
        circle.endFill();
        return circle;
    }

}

export default MaskScene;
import Matrix from "openfl/geom/Matrix";
import Point from "openfl/geom/Point";
import Vector from "openfl/Vector";

import BlendMode from "starling/display/BlendMode";
import Button from "starling/display/Button";
import DisplayObject from "starling/display/DisplayObject";
import Image from "starling/display/Image";
import Event from "starling/events/Event";
import Touch from "starling/events/Touch";
import TouchEvent from "starling/events/TouchEvent";
import TouchPhase from "starling/events/TouchPhase";
import TextField from "starling/text/TextField";
import RenderTexture from "starling/textures/RenderTexture";
import Max from "starling/utils/Max";

import MenuButton from "./../utils/menuButton";
import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class RenderTextureScene extends Scene
{
    private _renderTexture:RenderTexture;
    private _canvas:Image;
    private _brush:Image;
    private _button:Button;
    private _colors:Map<number, number>;
    
    public constructor()
    {
        super();
        this._colors = new Map<number, number>();
        this._renderTexture = new RenderTexture(320, 435);
        
        this._canvas = new Image(this._renderTexture);
        this._canvas.addEventListener(TouchEvent.TOUCH, this.onTouch);
        this.addChild(this._canvas);
        
        this._brush = new Image(Game.assets.getTexture("brush"));
        this._brush.pivotX = this._brush.width / 2;
        this._brush.pivotY = this._brush.height / 2;
        this._brush.blendMode = BlendMode.NORMAL;
        
        var infoText:TextField = new TextField(256, 128, "Touch the screen\nto draw!");
        infoText.format.font = "DejaVu Sans";
        infoText.format.size = 24;
        infoText.x = Constants.CenterX - infoText.width / 2;
        infoText.y = Constants.CenterY - infoText.height / 2;
        this._renderTexture.draw(infoText);
        infoText.dispose();
        
        this._button = new MenuButton("Mode: Draw");
        this._button.x = (Constants.CenterX - this._button.width / 2);
        this._button.y = 15;
        this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
        this.addChild(this._button);
    }
    
    private onTouch = (event:TouchEvent):void =>
    {
        // touching the canvas will draw a brush texture. The 'drawBundled' method is not
        // strictly necessary, but it's faster when you are drawing with several fingers
        // simultaneously.
        
        this._renderTexture.drawBundled(():void =>
        {
            var touches:Vector<Touch> = event.getTouches(this._canvas);
        
            for (var i = 0; i < touches.length; i++)
            {
                var touch = touches[i];
                
                if (touch.phase == TouchPhase.BEGAN)
                    this._colors[touch.id] = Math.round(Math.random() * 0xFFFFFF);
                
                if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
                    continue;
                
                var brushColor = this._colors[touch.id];
                var location:Point = touch.getLocation(this._canvas);
                this._brush.x = location.x;
                this._brush.y = location.y;
                this._brush.color = brushColor;
                this._brush.rotation = Math.random() * Math.PI * 2.0;
                
                this._renderTexture.draw(this._brush);
                
                // necessary because 'Starling.skipUnchangedFrames == true'
                this.setRequiresRedraw();
            }
        });
    }
    
    private onButtonTriggered = ():void =>
    {
        if (this._brush.blendMode == BlendMode.NORMAL)
        {
            this._brush.blendMode = BlendMode.ERASE;
            this._button.text = "Mode: Erase";
        }
        else
        {
            this._brush.blendMode = BlendMode.NORMAL;
            this._button.text = "Mode: Draw";
        }
    }
    
    public dispose():void
    {
        this._renderTexture.dispose();
        super.dispose();
    }
}

export default RenderTextureScene;
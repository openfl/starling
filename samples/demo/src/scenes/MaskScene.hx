package scenes;
import openfl.geom.Point;

import starling.core.Starling;
import starling.display.Canvas;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;

@:keep class MaskScene extends Scene
{
    private var _contents:Sprite;
    private var _mask2:Canvas;
    private var _maskDisplay:Canvas;
    
    public function new()
    {
        super();
        _contents = new Sprite();
        addChild(_contents);
        
        var stageWidth:Float  = Starling.current.stage.stageWidth;
        var stageHeight:Float = Starling.current.stage.stageHeight;
        
        var touchQuad:Quad = new Quad(stageWidth, stageHeight);
        touchQuad.alpha = 0; // only used to get touch events
        addChildAt(touchQuad, 0);
        
        var image:Image = new Image(Game.assets.getTexture("flight_00"));
        image.x = (stageWidth - image.width) / 2;
        image.y = 80;
        _contents.addChild(image);

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
        _contents.addChild(maskText);
        
        _maskDisplay = createCircle();
        _maskDisplay.alpha = 0.1;
        _maskDisplay.touchable = false;
        addChild(_maskDisplay);

        _mask2 = createCircle();
        _contents.mask = _mask2;
        addChild(_mask2);
        
        addEventListener(TouchEvent.TOUCH, onTouch);
    }
    
    private function onTouch(event:TouchEvent):Void
    {
        var touch:Touch = event.getTouch(this, TouchPhase.HOVER);
        if (touch == null) touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch == null) touch = event.getTouch(this, TouchPhase.MOVED);

        if (touch != null)
        {
            var localPos:Point = touch.getLocation(this);
            _mask2.x = _maskDisplay.x = localPos.x;
            _mask2.y = _maskDisplay.y = localPos.y;
        }
    }

    private function createCircle():Canvas
    {
        var circle:Canvas = new Canvas();
        circle.beginFill(0xEA8220);
        circle.drawCircle(0, 0, 100);
        circle.endFill();
        return circle;
    }

}

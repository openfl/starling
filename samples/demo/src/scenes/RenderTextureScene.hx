package scenes;
import flash.geom.Point;
import flash.geom.Matrix;
import starling.display.DisplayObject;
import starling.utils.Max;

import starling.display.BlendMode;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.RenderTexture;

class RenderTextureScene extends Scene
{
    private var mRenderTexture:RenderTexture;
    private var mCanvas:Image;
    private var mBrush:Image;
    private var mButton:Button;
    private var mColors:Map<Int, UInt>;
    
    public function new()
    {
        super();
        mColors = new Map<Int, UInt>();
        mRenderTexture = new RenderTexture(320, 435);
        
        mCanvas = new Image(mRenderTexture);
        mCanvas.addEventListener(TouchEvent.TOUCH, onTouch);
        addChild(mCanvas);
        
        mBrush = new Image(Game.assets.getTexture("brush"));
        mBrush.pivotX = mBrush.width / 2;
        mBrush.pivotY = mBrush.height / 2;
        mBrush.blendMode = BlendMode.NORMAL;
        
        var infoText:TextField = new TextField(256, 128, "Touch the screen\nto draw!");
        infoText.fontSize = 24;
        infoText.x = Constants.CenterX - infoText.width / 2;
        infoText.y = Constants.CenterY - infoText.height / 2;
        mRenderTexture.draw(infoText);
        
        mButton = new Button(Game.assets.getTexture("button_normal"), "Mode: Draw");
        mButton.fontName = Constants.DefaultFont;
        mButton.x = Std.int(Constants.CenterX - mButton.width / 2);
        mButton.y = 15;
        mButton.addEventListener(Event.TRIGGERED, onButtonTriggered);
        addChild(mButton);
    }
    
    private override function onTouch(event:TouchEvent):Void
    {
        // touching the canvas will draw a brush texture. The 'drawBundled' method is not
        // strictly necessary, but it's faster when you are drawing with several fingers
        // simultaneously.
        
        mRenderTexture.drawBundled(function(unused0:DisplayObject, unused1:Matrix, unused2:Float):Void
        {
            var touches:Array<Touch> = event.getTouches(mCanvas);
        
            for (touch in touches)
            {
                if (touch.phase == TouchPhase.BEGAN)
                    mColors[touch.id] = cast(Math.random() * Max.UINT_MAX_VALUE, UInt);
                
                if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
                    continue;
                
                var location:Point = touch.getLocation(mCanvas);
                mBrush.x = location.x;
                mBrush.y = location.y;
                mBrush.color = mColors[touch.id];
                mBrush.rotation = Math.random() * Math.PI * 2.0;
                
                mRenderTexture.draw(mBrush);
            }
        });
    }
    
    private function onButtonTriggered(unused:Dynamic):Void
    {
        if (mBrush.blendMode == BlendMode.NORMAL)
        {
            mBrush.blendMode = BlendMode.ERASE;
            mButton.text = "Mode: Erase";
        }
        else
        {
            mBrush.blendMode = BlendMode.NORMAL;
            mButton.text = "Mode: Draw";
        }
    }
    
    public override function dispose():Void
    {
        mRenderTexture.dispose();
        super.dispose();
    }
}
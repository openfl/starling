package scenes;
import starling.display.BlendMode;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

@:keep class BlendModeScene extends Scene
{
    private var mButton:Button;
    private var mImage:Image;
    private var mInfoText:TextField;
    
    private var mBlendModes:Array<String> = [
        BlendMode.NORMAL,
        BlendMode.MULTIPLY,
        BlendMode.SCREEN,
        BlendMode.ADD,
        BlendMode.ERASE,
        BlendMode.NONE
    ];
    
    public function new()
    {
        super();
        mButton = new Button(Game.assets.getTexture("button_normal"), "Switch Mode");
        mButton.x = Std.int(Constants.CenterX - mButton.width / 2);
        mButton.y = 15;
        mButton.addEventListener(Event.TRIGGERED, onButtonTriggered);
        addChild(mButton);
        
        mImage = new Image(Game.assets.getTexture("starling_rocket"));
        mImage.x = Std.int(Constants.CenterX - mImage.width / 2);
        mImage.y = 170;
        addChild(mImage);
        
        mInfoText = new TextField(300, 32, "", "Verdana", 19);
        mInfoText.x = 10;
        mInfoText.y = 330;
        addChild(mInfoText);
        
        onButtonTriggered();
    }
    
    private function onButtonTriggered():Void
    {
        var blendMode:String = mBlendModes.shift();
        mBlendModes.push(blendMode);
        
        mInfoText.text = blendMode;
        mImage.blendMode = blendMode;
    }
}
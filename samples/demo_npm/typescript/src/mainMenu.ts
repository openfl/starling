import AnimationScene from "./scenes/animationScene";
import BenchmarkScene from "./scenes/benchmarkScene";
import BlendModeScene from "./scenes/blendModeScene";
import CustomHitTestScene from "./scenes/customHitTestScene";
import FilterScene from "./scenes/filterScene";
import MaskScene from "./scenes/maskScene";
import MovieScene from "./scenes/movieScene";
import RenderTextureScene from "./scenes/renderTextureScene";
import Sprite3DScene from "./scenes/sprite3DScene";
import TextScene from "./scenes/textScene";
import TextureScene from "./scenes/textureScene";
import TouchScene from "./scenes/touchScene";
// import VideoScene from "./scenes/videoScene";

import Starling from "starling/core/Starling";
import Button from "starling/display/Button";
import Image from "starling/display/Image";
import Sprite from "starling/display/Sprite";
import TouchEvent from "starling/events/TouchEvent";
import TouchPhase from "starling/events/TouchPhase";
import TextField from "starling/text/TextField";
import Align from "starling/utils/Align";

import MenuButton from "./utils/menuButton";
import Game from "./game";

class MainMenu extends Sprite
{
    public sceneClasses:Array<any> = [];
    
    public constructor()
    {
        super();
        this.init();
    }
    
    private init():void
    {
        var logo:Image = new Image(Game.assets.getTexture("logo"));
        this.addChild(logo);
        
        var scenesToCreate:Array<Array<any>> = [
            ["Textures", TextureScene],
            ["Multitouch", TouchScene],
            ["TextFields", TextScene],
            ["Animations", AnimationScene],
            ["Custom hit-test", CustomHitTestScene],
            ["Movie Clip", MovieScene],
            ["Filters", FilterScene],
            ["Blend Modes", BlendModeScene],
            ["Render Texture", RenderTextureScene],
            ["Benchmark", BenchmarkScene],
            ["Masks", MaskScene],
            ["Sprite 3D", Sprite3DScene]
            // ,["Video", VideoScene]
        ];
        
        var count:number = 0;
        
        for (var sceneToCreate of scenesToCreate)
        {
            var sceneTitle:string = sceneToCreate[0];
            var sceneClass = sceneToCreate[1];
            
            var button:Button = new MenuButton(sceneTitle);
            button.height = 42;
            button.readjustSize();
            button.x = count % 2 == 0 ? 28 : 167;
            button.y = /* 145 */ 155 + Math.floor(count / 2) * 46;
            button.name = this.sceneClasses.length;
            this.sceneClasses.push(sceneClass);
            this.addChild(button);
            
            if (scenesToCreate.length % 2 != 0 && count % 2 == 1)
                button.y += 24;
            
            ++count;
        }
        
        // show information about rendering method (hardware/software)
        
        var driverInfo:string = Starling.current.context.driverInfo;
        var infoText:TextField = new TextField(310, 64, driverInfo);
        infoText.format.font = "DejaVu Sans";
        infoText.format.size = 10;
        infoText.format.verticalAlign = Align.BOTTOM;
        infoText.x = 5;
        infoText.y = 475 - infoText.height;
        infoText.addEventListener(TouchEvent.TOUCH, this.onInfoTextTouched);
        this.addChildAt(infoText, 0);
    }
    
    private onInfoTextTouched = (event:TouchEvent):void =>
    {
        if (event.getTouch(this, TouchPhase.ENDED) != null)
            Starling.current.showStats = !Starling.current.showStats;
    }
}

export default MainMenu;
package {

    import scenes.AnimationScene;
    import scenes.BenchmarkScene;
    import scenes.BlendModeScene;
    import scenes.CustomHitTestScene;
    import scenes.FilterScene;
    import scenes.MaskScene;
    import scenes.MovieScene;
    import scenes.RenderTextureScene;
    import scenes.Sprite3DScene;
    import scenes.TextScene;
    import scenes.TextureScene;
    import scenes.TouchScene;
    
    // #if demo_video
    // import scenes.VideoScene;
    // #end

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.utils.Align;

    import utils.MenuButton;

    public class MainMenu extends Sprite
    {
        public function get sceneClasses ():Array { return _sceneClasses; }
        private var _sceneClasses:Array = [];
        
        public function MainMenu()
        {
            super();
            init();
        }
        
        private function init():void
        {
            var logo:Image = new Image(Game.assets.getTexture("logo"));
            addChild(logo);
            
            var scenesToCreate:Array = [
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
                // #if demo_video
                // ,["Video", VideoScene]
                // #end
            ];
            
            var count:int = 0;
            
            for each (var sceneToCreate:Array in scenesToCreate)
            {
                var sceneTitle:String = sceneToCreate[0];
                var sceneClass:Class  = sceneToCreate[1];
                
                var button:Button = new MenuButton(sceneTitle);
                button.height = 42;
                button.readjustSize();
                button.x = count % 2 == 0 ? 28 : 167;
                button.y = /*#if demo_video 145 #else*/ 155 /*#end*/ + int(count / 2) * 46;
                // button.name = getQualifiedClassName(sceneClass);
                button.name = String(_sceneClasses.length);
                _sceneClasses.push(sceneClass);
                addChild(button);
                
                if (scenesToCreate.length % 2 != 0 && count % 2 == 1)
                    button.y += 24;
                
                ++count;
            }
            
            // show information about rendering method (hardware/software)
            
            var driverInfo:String = Starling.current.context.driverInfo;
            var infoText:TextField = new TextField(310, 64, driverInfo);
            infoText.format.font = "DejaVu Sans";
            infoText.format.size = 10;
            infoText.format.verticalAlign = Align.BOTTOM;
            infoText.x = 5;
            infoText.y = 475 - infoText.height;
            infoText.addEventListener(TouchEvent.TOUCH, onInfoTextTouched);
            addChildAt(infoText, 0);
        }
        
        private function onInfoTextTouched(event:TouchEvent):void
        {
            if (event.getTouch(this, TouchPhase.ENDED) != null)
                Starling.current.showStats = !Starling.current.showStats;
        }
    }
    
}
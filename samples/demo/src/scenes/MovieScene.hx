package scenes;
import flash.media.Sound;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;

@:keep class MovieScene extends Scene
{
    private var _movie:MovieClip;
    
    public function new()
    {
        super();
        var frames:Array<Texture> = Game.assets.getTextures("flight");
        _movie = new MovieClip(frames, 15);
        
        // add sounds
        var stepSound:Sound = Game.assets.getSound("wing_flap");
        _movie.setFrameSound(2, stepSound);
        
        // move the clip to the center and add it to the stage
        _movie.x = Constants.CenterX - Std.int(_movie.width / 2);
        _movie.y = Constants.CenterY - Std.int(_movie.height / 2);
        addChild(_movie);
        
        // like any animation, the movie needs to be added to the juggler!
        // this is the recommended way to do that.
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage():Void
    {
        Starling.current.juggler.add(_movie);
    }
    
    private function onRemovedFromStage():Void
    {
        Starling.current.juggler.remove(_movie);
    }
    
    public override function dispose():Void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        super.dispose();
    }
}
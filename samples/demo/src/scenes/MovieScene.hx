package scenes;
import flash.media.Sound;
import openfl.Assets;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;

@:keep class MovieScene extends Scene
{
    private var mMovie:MovieClip;
    
    public function new()
    {
        super();
        var frames:Array<Texture> = Game.assets.getTextures("flight");
        mMovie = new MovieClip(frames, 15);
        
        // add sounds
        var stepSound:Sound = Assets.getSound("assets/audio/wing_flap.ogg");
        mMovie.setFrameSound(2, stepSound);
        
        // move the clip to the center and add it to the stage
        mMovie.x = Constants.CenterX - Std.int(mMovie.width / 2);
        mMovie.y = Constants.CenterY - Std.int(mMovie.height / 2);
        addChild(mMovie);
        
        // like any animation, the movie needs to be added to the juggler!
        // this is the recommended way to do that.
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage(unused:Dynamic):Void
    {
        Starling.current.juggler.add(mMovie);
    }
    
    private function onRemovedFromStage(unused:Dynamic):Void
    {
        Starling.current.juggler.remove(mMovie);
    }
    
    public override function dispose():Void
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        super.dispose();
    }
}
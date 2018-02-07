import Sound from "openfl/media/Sound";
import Vector from "openfl/Vector";

import Starling from "starling/core/Starling";
import MovieClip from "starling/display/MovieClip";
import Event from "starling/events/Event";
import Texture from "starling/textures/Texture";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class MovieScene extends Scene
{
    private _movie:MovieClip;
    
    public constructor()
    {
        super();
        var frames:Vector<Texture> = Game.assets.getTextures("flight");
        this._movie = new MovieClip(frames, 15);
        
        // add sounds
        var stepSound:Sound = Game.assets.getSound("wing_flap");
        this._movie.setFrameSound(2, stepSound);
        
        // move the clip to the center and add it to the stage
        this._movie.x = Constants.CenterX - (this._movie.width / 2);
        this._movie.y = Constants.CenterY - (this._movie.height / 2);
        this.addChild(this._movie);
        
        // like any animation, the movie needs to be added to the juggler!
        // this is the recommended way to do that.
        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    
    private onAddedToStage = ():void =>
    {
        Starling.current.juggler.add(this._movie);
    }
    
    private onRemovedFromStage = ():void =>
    {
        Starling.current.juggler.remove(this._movie);
    }
    
    public dispose():void
    {
        this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        super.dispose();
    }
}

export default MovieScene;
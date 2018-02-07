'use strict';
var Sound = require ("openfl/media/Sound").default;
var Vector = require ("openfl/Vector").default;

var Starling = require ("starling/core/Starling").default;
var MovieClip = require ("starling/display/MovieClip").default;
var Event = require ("starling/events/Event").default;
var Texture = require ("starling/textures/Texture").default;

var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var MovieScene = function()
{
    Scene.call(this);
    
    this.onAddedToStage = this.onAddedToStage.bind(this);
    this.onRemovedFromStage = this.onRemovedFromStage.bind(this);
    
    var frames = Game.assets.getTextures("flight");
    this._movie = new MovieClip(frames, 15);
    
    // add sounds
    var stepSound = Game.assets.getSound("wing_flap");
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

MovieScene.prototype = Object.create(Scene.prototype);
MovieScene.prototype.constructor = MovieScene;

MovieScene.prototype.onAddedToStage = function()
{
    Starling.current.juggler.add(this._movie);
}

MovieScene.prototype.onRemovedFromStage = function()
{
    Starling.current.juggler.remove(this._movie);
}

MovieScene.prototype.dispose = function()
{
    this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    Scene.prototype.dispose.call(this);
}

module.exports.MovieScene = MovieScene;
module.exports.default = MovieScene;
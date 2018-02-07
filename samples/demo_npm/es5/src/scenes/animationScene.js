'use strict';
var Transitions = require ("starling/animation/Transitions").default;
var Tween = require ("starling/animation/Tween").default;
var Starling = require ("starling/core/Starling").default;
var Button = require ("starling/display/Button").default;
var Image = require ("starling/display/Image").default;
var Event = require ("starling/events/Event").default;
var TextField = require ("starling/text/TextField").default;
var Color = require ("starling/utils/Color").default;
var MathUtil = require ("starling/utils/MathUtil").default;
var Vector = require ("openfl/Vector").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var AnimationScene = function()
{
    Scene.call(this);
    
    this.onStartButtonTriggered = this.onStartButtonTriggered.bind(this);
    this.onDelayButtonTriggered = this.onDelayButtonTriggered.bind(this);
    this.colorizeEgg = this.colorizeEgg.bind(this);
    
    this._transitions = [Transitions.LINEAR, Transitions.EASE_IN_OUT,
                    Transitions.EASE_OUT_BACK, Transitions.EASE_OUT_BOUNCE,
                    Transitions.EASE_OUT_ELASTIC];
    
    // create a button that starts the tween
    this._startButton = new MenuButton("Start animation");
    this._startButton.addEventListener(Event.TRIGGERED, this.onStartButtonTriggered);
    this._startButton.x = Constants.CenterX - (this._startButton.width / 2);
    this._startButton.y = 20;
    this.addChild(this._startButton);
    
    // this button will show you how to call a method with a delay
    this._delayButton = new MenuButton("Delayed call");
    this._delayButton.addEventListener(Event.TRIGGERED, this.onDelayButtonTriggered);
    this._delayButton.x = this._startButton.x;
    this._delayButton.y = this._startButton.y + 40;
    this.addChild(this._delayButton);
    
    // the Starling will be tweened
    this._egg = new Image(Game.assets.getTexture("starling_front"));
    this.addChild(this._egg);
    this.resetEgg();
    
    this._transitionLabel = new TextField(320, 30);
    this._transitionLabel.format.size = 20;
    this._transitionLabel.format.bold = true;
    this._transitionLabel.format.font = "DejaVu Sans";
    this._transitionLabel.y = this._delayButton.y + 40;
    this._transitionLabel.alpha = 0.0; // invisible, will be shown later
    this.addChild(this._transitionLabel);
}

AnimationScene.prototype = Object.create(Scene.prototype);
AnimationScene.prototype.constructor = AnimationScene;

AnimationScene.prototype.resetEgg = function()
{
    this._egg.x = 20;
    this._egg.y = 100;
    this._egg.scaleX = this._egg.scaleY = 1.0;
    this._egg.rotation = 0.0;
}

AnimationScene.prototype.onStartButtonTriggered = function()
{
    this._startButton.enabled = false;
    this.resetEgg();
    
    // get next transition style from array and enqueue it at the end
    var transition = this._transitions.shift();
    this._transitions.push(transition);
    
    // to animate any numeric property of an arbitrary object (not just display objects!), 
    // you can create a 'Tween'. One tween object animates one target for a certain time, 
    // a with certain transition function.
    var tween = new Tween(this._egg, 2.0, transition);
    
    // you can animate any property as long as it's numeric (int, uint, Number). 
    // it is animated from it's current value to a target value.  
    tween.animate("rotation", MathUtil.deg2rad(90)); // conventional 'animate' call
    tween.moveTo(300, 360);                 // convenience method for animating 'x' and 'y'
    tween.scaleTo(0.5);                     // convenience method for 'scaleX' and 'scaleY'
    tween.onComplete = () => { this._startButton.enabled = true; };
    
    // the tween alone is useless -- for an animation to be carried out, it has to be 
    // advance once in every frame.            
    // This is done by the 'Juggler'. It receives the tween and will carry it out.
    // We use the default juggler here, but you can create your own jugglers, as well.            
    // That way, you can group animations into logical parts.  
    Starling.current.juggler.add(tween);
    
    // show which tweening function is used
    this._transitionLabel.text = transition;
    this._transitionLabel.alpha = 1.0;
    
    var hideTween = new Tween(this._transitionLabel, 2.0, Transitions.EASE_IN);
    hideTween.animate("alpha", 0.0);
    Starling.current.juggler.add(hideTween);
}

AnimationScene.prototype.onDelayButtonTriggered = function()
{
    this._delayButton.enabled = false;
    
    // Using the juggler, you can delay a method call. This is especially useful when
    // you use your own juggler in a component of your game, because it gives you perfect 
    // control over the flow of time and animations. 
    
    Starling.current.juggler.delayCall(this.colorizeEgg, 1.0, [true]);
    Starling.current.juggler.delayCall(this.colorizeEgg, 2.0, [false]);
    Starling.current.juggler.delayCall(() => { this._delayButton.enabled = true; }, 2.0);
}

AnimationScene.prototype.colorizeEgg = function(colorize)
{
    this. _egg.color = colorize ? 0xEA8220 : Color.WHITE;
}

AnimationScene.prototype.dispose = function()
{
    this._startButton.removeEventListener(Event.TRIGGERED, this.onStartButtonTriggered);
    this._delayButton.removeEventListener(Event.TRIGGERED, this.onDelayButtonTriggered);
    Scene.prototype.dispose.call(this);
}

module.exports.AnimationScene = AnimationScene;
module.exports.default = AnimationScene;
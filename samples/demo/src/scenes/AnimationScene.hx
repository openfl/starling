package scenes;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.MathUtil.deg2rad;
import openfl.Vector;

@:keep class AnimationScene extends Scene
{
    private var mStartButton:Button;
    private var mDelayButton:Button;
    private var mEgg:Image;
    private var mTransitionLabel:TextField;
    private var mTransitions:Array<String>;
    
    public function new()
    {
        super();
        mTransitions = [Transitions.LINEAR, Transitions.EASE_IN_OUT,
                        Transitions.EASE_OUT_BACK, Transitions.EASE_OUT_BOUNCE,
                        Transitions.EASE_OUT_ELASTIC];
        
        var buttonTexture:Texture = Game.assets.getTexture("button_normal");
        
        // create a button that starts the tween
        mStartButton = new Button(buttonTexture, "Start animation");
        mStartButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
        mStartButton.x = Constants.CenterX - Std.int(mStartButton.width / 2);
        mStartButton.y = 20;
        addChild(mStartButton);
        
        // this button will show you how to call a method with a delay
        mDelayButton = new Button(buttonTexture, "Delayed call");
        mDelayButton.addEventListener(Event.TRIGGERED, onDelayButtonTriggered);
        mDelayButton.x = mStartButton.x;
        mDelayButton.y = mStartButton.y + 40;
        addChild(mDelayButton);
        
        // the Starling will be tweened
        mEgg = new Image(Game.assets.getTexture("starling_front"));
        addChild(mEgg);
        resetEgg();
        
        mTransitionLabel = new TextField(320, 30, "", "Verdana", 20, 0, true);
        mTransitionLabel.y = mDelayButton.y + 40;
        mTransitionLabel.alpha = 0.0; // invisible, will be shown later
        addChild(mTransitionLabel);
    }
    
    private function resetEgg():Void
    {
        mEgg.x = 20;
        mEgg.y = 100;
        mEgg.scaleX = mEgg.scaleY = 1.0;
        mEgg.rotation = 0.0;
    }
    
    private function onStartButtonTriggered():Void
    {
        mStartButton.enabled = false;
        resetEgg();
        
        // get next transition style from array and enqueue it at the end
        var transition:String = mTransitions.shift();
        mTransitions.push(transition);
        
        // to animate any numeric property of an arbitrary object (not just display objects!), 
        // you can create a 'Tween'. One tween object animates one target for a certain time, 
        // a with certain transition function.
        var tween:Tween = new Tween(mEgg, 2.0, transition);
        
        // you can animate any property as long as it's numeric (int, uint, Number). 
        // it is animated from it's current value to a target value.  
        tween.animate("rotation", deg2rad(90)); // conventional 'animate' call
        tween.moveTo(300, 360);                 // convenience method for animating 'x' and 'y'
        tween.scaleTo(0.5);                     // convenience method for 'scaleX' and 'scaleY'
        tween.onComplete = function():Void { mStartButton.enabled = true; };
        
        // the tween alone is useless -- for an animation to be carried out, it has to be 
        // advance once in every frame.            
        // This is done by the 'Juggler'. It receives the tween and will carry it out.
        // We use the default juggler here, but you can create your own jugglers, as well.            
        // That way, you can group animations into logical parts.  
        Starling.current.juggler.add(tween);
        
        // show which tweening function is used
        mTransitionLabel.text = transition;
        mTransitionLabel.alpha = 1.0;
        
        var hideTween:Tween = new Tween(mTransitionLabel, 2.0, Transitions.EASE_IN);
        hideTween.animate("alpha", 0.0);
        Starling.current.juggler.add(hideTween);
    }
    
    private function onDelayButtonTriggered():Void
    {
        mDelayButton.enabled = false;
        
        // Using the juggler, you can delay a method call. This is especially useful when
        // you use your own juggler in a component of your game, because it gives you perfect 
        // control over the flow of time and animations. 
        
        Starling.current.juggler.delayCall(colorizeEgg, 1.0, [true]);
        Starling.current.juggler.delayCall(colorizeEgg, 2.0, [false]);
        Starling.current.juggler.delayCall(function(?unused):Void { mDelayButton.enabled = true; }, 2.0);
    }
    
    private function colorizeEgg(colorize:Bool):Void
    {
        mEgg.color = colorize ? Color.RED : Color.WHITE;
    }
    
    public override function dispose():Void
    {
        mStartButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
        mDelayButton.removeEventListener(Event.TRIGGERED, onDelayButtonTriggered);
        super.dispose();
    }
}
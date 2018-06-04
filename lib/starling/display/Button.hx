// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.errors.ArgumentError;
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;

/** Dispatched when the user triggers the button. Bubbles. */
@:meta(Event(name="triggered", type="starling.events.Event"))

/** A simple button composed of an image and, optionally, text.
 *  
 *  <p>You can use different textures for various states of the button. If you're providing
 *  only an up state, the button is simply scaled a little when it is touched.</p>
 *
 *  <p>In addition, you can overlay text on the button. To customize the text, you can use
 *  properties equivalent to those of the TextField class. Move the text to a certain position
 *  by updating the <code>textBounds</code> property.</p>
 *  
 *  <p>To react on touches on a button, there is special <code>Event.TRIGGERED</code> event.
 *  Use this event instead of normal touch events. That way, users can cancel button
 *  activation by moving the mouse/finger away from the button before releasing.</p>
 */

@:jsRequire("starling/display/Button", "default")

extern class Button extends DisplayObjectContainer
{
    /** Creates a button with a set of state-textures and (optionally) some text.
     * Any state that is left 'null' will display the up-state texture. Beware that all
     * state textures should have the same dimensions. */
    public function new(upState:Texture, text:String="", downState:Texture=null,
                        overState:Texture=null, disabledState:Texture=null);
    
    /** @inheritDoc */
    public override function dispose():Void;
    
    /** Readjusts the dimensions of the button according to its current state texture.
     * Call this method to synchronize button and texture size after assigning a texture
     * with a different size. Per default, this method also resets the bounds of the
     * button's text. */
    public function readjustSize(resetTextBounds:Bool=true):Void;

    /** The current state of the button. The corresponding strings are found
     * in the ButtonState class. */
    public var state(get, set):String;
    private function get_state():String;
    private function set_state(value:String):String;

    /** The scale factor of the button on touch. Per default, a button without a down state
     * texture will be made slightly smaller, while a button with a down state texture
     * remains unscaled. */
    public var scaleWhenDown(get, set):Float;
    private function get_scaleWhenDown():Float;
    private function set_scaleWhenDown(value:Float):Float;

    /** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */
    public var scaleWhenOver(get, set):Float;
    private function get_scaleWhenOver():Float;
    private function set_scaleWhenOver(value:Float):Float;

    /** The alpha value of the button on touch. @default 1.0 */
    public var alphaWhenDown(get, set):Float;
    private function get_alphaWhenDown():Float;
    private function set_alphaWhenDown(value:Float):Float;

    /** The alpha value of the button when it is disabled. @default 0.5 */
    public var alphaWhenDisabled(get, set):Float;
    private function get_alphaWhenDisabled():Float;
    private function set_alphaWhenDisabled(value:Float):Float;
    
    /** Indicates if the button can be triggered. */
    public var enabled(get, set):Bool;
    private function get_enabled():Bool;
    private function set_enabled(value:Bool):Bool;
    
    /** The text that is displayed on the button. */
    public var text(get, set):String;
    private function get_text():String;
    private function set_text(value:String):String;

    /** The format of the button's TextField. */
    public var textFormat(get, set):TextFormat;
    private function get_textFormat():TextFormat;

    private function set_textFormat(value:TextFormat):TextFormat;

    /** The style that is used to render the button's TextField. */
    public var textStyle(get, set):MeshStyle;
    private function get_textStyle():MeshStyle;

    private function set_textStyle(value:MeshStyle):MeshStyle;

    /** The style that is used to render the button.
     *  Note that a style instance may only be used on one mesh at a time. */
    public var style(get, set):MeshStyle;
    private function get_style():MeshStyle;
    private function set_style(value:MeshStyle):MeshStyle;
    
    /** The texture that is displayed when the button is not being touched. */
    public var upState(get, set):Texture;
    private function get_upState():Texture;
    private function set_upState(value:Texture):Texture;
    
    /** The texture that is displayed while the button is touched. */
    public var downState(get, set):Texture;
    private function get_downState():Texture;
    private function set_downState(value:Texture):Texture;

    /** The texture that is displayed while mouse hovers over the button. */
    public var overState(get, set):Texture;
    private function get_overState():Texture;
    private function set_overState(value:Texture):Texture;

    /** The texture that is displayed when the button is disabled. */
    public var disabledState(get, set):Texture;
    private function get_disabledState():Texture;
    private function set_disabledState(value:Texture):Texture;
    
    /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
    public var textBounds(get, set):Rectangle;
    private function get_textBounds():Rectangle;
    private function set_textBounds(value:Rectangle):Rectangle;
    
    /** The color of the button's state image. Just like every image object, each pixel's
     * color is multiplied with this value. @default white */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;

    /** The smoothing type used for the button's state image. */
    public var textureSmoothing(get, set):String;
    private function get_textureSmoothing():String;
    private function set_textureSmoothing(value:String):String;

    /** The overlay sprite is displayed on top of the button contents. It scales with the
     * button when pressed. Use it to add additional objects to the button (e.g. an icon). */
    public var overlay(get, never):Sprite;
    private function get_overlay():Sprite;

    /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
     * @default true */
    private override function get_useHandCursor():Bool;
    private override function set_useHandCursor(value:Bool):Bool;
    
    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default true */
    public var pixelSnapping(get, set):Bool;
    private function get_pixelSnapping():Bool;
    private function set_pixelSnapping(value:Bool):Bool;

    /** @private */
    override private function set_width(value:Float):Float;

    /** @private */
    override private function set_height(value:Float):Float;

    /** The current scaling grid used for the button's state image. Use this property to create
     *  buttons that resize in a smart way, i.e. with the four corners keeping the same size
     *  and only stretching the center area.
     *
     *  @see Image#scale9Grid
     *  @default null
     */
    public var scale9Grid(get, set):Rectangle;
    private function get_scale9Grid():Rectangle;
    private function set_scale9Grid(value:Rectangle):Rectangle;
}
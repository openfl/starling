// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.text.AntiAliasType;
import openfl.text.TextField;

import starling.textures.ConcreteTexture;
import starling.display.MeshBatch;
import starling.display.Quad;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.MathUtil;
import starling.utils.SystemUtil;

/** This text compositor uses a Flash TextField to render system- or embedded fonts into
 *  a texture.
 *
 *  <p>You typically don't have to instantiate this class. It will be used internally by
 *  Starling's text fields.</p>
 */

@:jsRequire("starling/text/TrueTypeCompositor", "default")

extern class TrueTypeCompositor implements ITextCompositor
{
    /** Creates a new TrueTypeCompositor instance. */
    public function new();

    /** @inheritDoc */
    public function dispose():Void;

    /** @inheritDoc */
    public function fillMeshBatch(meshBatch:MeshBatch, width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions=null):Void;

    /** @inheritDoc */
    public function clearMeshBatch(meshBatch:MeshBatch):Void;
    
    /** @private */
    public function getDefaultMeshStyle(previousStyle:MeshStyle,
                                        format:TextFormat, options:TextOptions):MeshStyle;
}

extern class BitmapDataEx extends BitmapData
{
    public var scale(get, set):Float;
    private function get_scale():Float;
    private function set_scale(value:Float):Float;
}

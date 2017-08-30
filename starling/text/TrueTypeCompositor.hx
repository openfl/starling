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

import starling.display.MeshBatch;
import starling.display.Quad;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.SystemUtil;

/** This text compositor uses a Flash TextField to render system- or embedded fonts into
 *  a texture.
 *
 *  <p>You typically don't have to instantiate this class. It will be used internally by
 *  Starling's text fields.</p>
 */
class TrueTypeCompositor implements ITextCompositor
{
    // helpers
    private static var sHelperMatrix:Matrix = new Matrix();
    private static var sHelperQuad:Quad = new Quad(100, 100);
    private static var sNativeTextField:openfl.text.TextField = new openfl.text.TextField();
    private static var sNativeFormat:openfl.text.TextFormat = new openfl.text.TextFormat();

    /** Creates a new TrueTypeCompositor instance. */
    public function new()
    { }

    /** @inheritDoc */
    public function dispose():Void
    {}

    /** @inheritDoc */
    public function fillMeshBatch(meshBatch:MeshBatch, width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions=null):Void
    {
        if (text == null || text == "") return;

        var texture:Texture;
        var textureFormat:String = options.textureFormat;
        var bitmapData:BitmapDataEx = renderText(width, height, text, format, options);

        texture = Texture.fromBitmapData(bitmapData, false, false, bitmapData.scale, textureFormat);
        texture.root.onRestore = function():Void
        {
            bitmapData = renderText(width, height, text, format, options);
            texture.root.uploadBitmapData(bitmapData);
            bitmapData.dispose();
            bitmapData = null;
        };

        bitmapData.dispose();
        bitmapData = null;

        sHelperQuad.texture = texture;
        sHelperQuad.readjustSize();

        if (format.horizontalAlign == Align.LEFT) sHelperQuad.x = 0;
        else if (format.horizontalAlign == Align.CENTER) sHelperQuad.x = Std.int((width - texture.width) / 2);
        else sHelperQuad.x = width - texture.width;

        if (format.verticalAlign == Align.TOP) sHelperQuad.y = 0;
        else if (format.verticalAlign == Align.CENTER) sHelperQuad.y = Std.int((height - texture.height) / 2);
        else sHelperQuad.y = height - texture.height;

        meshBatch.addMesh(sHelperQuad);

        sHelperQuad.texture = null;
    }

    /** @inheritDoc */
    public function clearMeshBatch(meshBatch:MeshBatch):Void
    {
        meshBatch.clear();
        if (meshBatch.texture != null) meshBatch.texture.dispose();
    }

    private function renderText(width:Float, height:Float, text:String,
                                format:TextFormat, options:TextOptions):BitmapDataEx
    {
        var scaledWidth:Float  = width  * options.textureScale;
        var scaledHeight:Float = height * options.textureScale;
        var hAlign:String = format.horizontalAlign;

        format.toNativeFormat(sNativeFormat);

        sNativeFormat.size = Std.int((sNativeFormat.size == null ? 0 : sNativeFormat.size) * options.textureScale);
        sNativeTextField.embedFonts = SystemUtil.isEmbeddedFont(format.font, format.bold, format.italic);
        #if flash
        sNativeTextField.styleSheet = null; // only to make sure 'defaultTextFormat' is assignable
        #end
        sNativeTextField.defaultTextFormat = sNativeFormat;
        #if flash
        sNativeTextField.styleSheet = options.styleSheet;
        #end
        sNativeTextField.width  = scaledWidth;
        sNativeTextField.height = scaledHeight;
        sNativeTextField.antiAliasType = AntiAliasType.ADVANCED;
        sNativeTextField.selectable = false;
        sNativeTextField.multiline = true;
        sNativeTextField.wordWrap = options.wordWrap;

        if (options.isHtmlText) sNativeTextField.htmlText = text;
        else                    sNativeTextField.text     = text;

        if (options.autoScale)
            autoScaleNativeTextField(sNativeTextField, text, options.isHtmlText);

        var textWidth:Float  = sNativeTextField.textWidth;
        var textHeight:Float = sNativeTextField.textHeight;
        var bitmapWidth:Int   = Math.ceil(textWidth)  + 4;
        var bitmapHeight:Int  = Math.ceil(textHeight) + 4;
        var maxTextureSize:Int = Texture.maxSize;
        var minTextureSize:Int = 1;
        var offsetX:Float = 0.0;

        // HTML text may have its own alignment -> use the complete width
        if (options.isHtmlText) textWidth = bitmapWidth = Math.ceil(scaledWidth);

        // check for invalid texture sizes
        if (bitmapWidth  < minTextureSize) bitmapWidth  = 1;
        if (bitmapHeight < minTextureSize) bitmapHeight = 1;
        if (bitmapHeight > maxTextureSize || bitmapWidth > maxTextureSize)
        {
            options.textureScale *= maxTextureSize / Math.max(bitmapWidth, bitmapHeight);
            return renderText(width, height, text, format, options);
        }
        else
        {
            if (!options.isHtmlText)
            {
                if      (hAlign == Align.RIGHT)  offsetX =  scaledWidth - textWidth - 4;
                else if (hAlign == Align.CENTER) offsetX = (scaledWidth - textWidth - 4) / 2.0;
            }

            // finally: draw TextField to bitmap data
            var bitmapData:BitmapDataEx = new BitmapDataEx(bitmapWidth, bitmapHeight);
            sHelperMatrix.setTo(1, 0, 0, 1, -offsetX, 0);
            bitmapData.draw(sNativeTextField, sHelperMatrix);
            bitmapData.scale = options.textureScale;
            sNativeTextField.text = "";
            return bitmapData;
        }
    }

    private function autoScaleNativeTextField(textField:openfl.text.TextField,
                                              text:String, isHtmlText:Bool):Void
    {
        var textFormat:openfl.text.TextFormat = textField.defaultTextFormat;
        var maxTextWidth:Int  = Std.int(textField.width)  - 4;
        var maxTextHeight:Int = Std.int(textField.height) - 4;
        var size:Float = textFormat.size == null ? 0 : textFormat.size;

        while (textField.textWidth > maxTextWidth || textField.textHeight > maxTextHeight)
        {
            if (size <= 4) break;

            textFormat.size = Std.int(size--);
            textField.defaultTextFormat = textFormat;

            if (isHtmlText) textField.htmlText = text;
            else            textField.text     = text;
        }
    }
}



class BitmapDataEx extends BitmapData
{
    private var _scale:Float = 1.0;

    @:allow(starling) function new(width:Int, height:Int, transparent:Bool=true, fillColor:UInt=0x0)
    {
        super(width, height, transparent, fillColor);
    }

    public var scale(get, set):Float;
    private function get_scale():Float { return _scale; }
    private function set_scale(value:Float):Float { return _scale = value; }
}

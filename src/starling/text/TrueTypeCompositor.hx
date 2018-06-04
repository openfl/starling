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
        texture.root.onRestore = function(textureRoot:ConcreteTexture):Void
        {
            bitmapData = renderText(width, height, text, format, options);
            textureRoot.uploadBitmapData(bitmapData);
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
        if (meshBatch.texture != null)
        {
            meshBatch.texture.dispose();
            meshBatch.texture = null;
        }
    }
    
    /** @private */
    public function getDefaultMeshStyle(previousStyle:MeshStyle,
                                        format:TextFormat, options:TextOptions):MeshStyle
    {
        return null;
    }


    private function renderText(width:Float, height:Float, text:String,
                                format:TextFormat, options:TextOptions):BitmapDataEx
    {
        var scale:Float = options.textureScale;
        var scaledWidth:Float  = width  * scale;
        var scaledHeight:Float = height * scale;
        var hAlign:String = format.horizontalAlign;

        format.toNativeFormat(sNativeFormat);

        sNativeFormat.size = Std.int((sNativeFormat.size == null ? 0 : sNativeFormat.size) * scale);
        sNativeTextField.embedFonts = SystemUtil.isEmbeddedFont(format.font, format.bold, format.italic);
        #if (flash && !display)
        sNativeTextField.styleSheet = null; // only to make sure 'defaultTextFormat' is assignable
        #end
        sNativeTextField.defaultTextFormat = sNativeFormat;
        #if (flash && !display)
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

        var minTextureSize:Int = 1;
        var maxTextureSize:Int = Texture.getMaxSize(options.textureFormat);
        var paddingX:Float = options.padding * scale;
        var paddingY:Float = options.padding * scale;
        var textWidth:Float  = sNativeTextField.textWidth  + 4;
        var textHeight:Float = sNativeTextField.textHeight + 4;
        var bitmapWidth:Int   = Std.int(Math.ceil(textWidth)  + 2 * paddingX);
        var bitmapHeight:Int  = Std.int(Math.ceil(textHeight) + 2 * paddingY);

        // if text + padding doesn't fit into the bitmap, reduce padding & cap bitmap size.
        if (bitmapWidth > scaledWidth)
        {
            paddingX = MathUtil.max(0, (scaledWidth - textWidth) / 2);
            bitmapWidth = Math.ceil(scaledWidth);
        }
        if (bitmapHeight > scaledHeight)
        {
            paddingY = MathUtil.max(0, (scaledHeight - textHeight) / 2);
            bitmapHeight = Math.ceil(scaledHeight);
        }

        // HTML text may have its own alignment -> use the complete width
        if (options.isHtmlText) textWidth = bitmapWidth = Std.int(scaledWidth);

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
            var offsetX:Float = -paddingX;
            var offsetY:Float = -paddingY;

            if (!options.isHtmlText)
            {
                if      (hAlign == Align.RIGHT)  offsetX =  scaledWidth - textWidth - paddingX;
                else if (hAlign == Align.CENTER) offsetX = (scaledWidth - textWidth) / 2.0 - paddingX;
            }

            // finally: draw TextField to bitmap data
            var bitmapData:BitmapDataEx = new BitmapDataEx(bitmapWidth, bitmapHeight);
            sHelperMatrix.setTo(1, 0, 0, 1, -offsetX, -offsetY);
            bitmapData.draw(sNativeTextField, sHelperMatrix);
            bitmapData.scale = scale;
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

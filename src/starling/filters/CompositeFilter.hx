// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.errors.ArgumentError;
import openfl.geom.Point;
import openfl.Vector;

import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.RenderUtil;
import starling.utils.StringUtil;

/** The CompositeFilter class allows to combine several layers of textures into one texture.
 *  It's mainly used as a building block for more complex filters; e.g. the DropShadowFilter
 *  uses this class to draw the shadow (the result of a BlurFilter) behind an object.
 */
class CompositeFilter extends FragmentFilter
{
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (CompositeFilter.prototype, {
            "compositeEffect": { get: untyped __js__ ("function () { return this.get_compositeEffect (); }") },
            "numLayers": { get: untyped __js__ ("function () { return this.get_numLayers (); }") },
        });
        
    }
    #end
    
    /** Creates a new instance. */
    public function new()
    {
        super();
    }

    /** Combines up to four input textures into one new texture,
     *  adhering to the properties of each layer. */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        compositeEffect.texture = input0;
        compositeEffect.getLayerAt(1).texture = input1;
        compositeEffect.getLayerAt(2).texture = input2;
        compositeEffect.getLayerAt(3).texture = input3;

        if (input1 != null) input1.setupTextureCoordinates(vertexData, 0, "texCoords1");
        if (input2 != null) input2.setupTextureCoordinates(vertexData, 0, "texCoords2");
        if (input3 != null) input3.setupTextureCoordinates(vertexData, 0, "texCoords3");

        return super.process(painter, helper, input0, input1, input2, input3);
    }

    /** @private */
    override private function createEffect():FilterEffect
    {
        return new CompositeEffect();
    }

    /** Returns the position (in points) at which a certain layer will be drawn. */
    public function getOffsetAt(layerID:Int, out:Point=null):Point
    {
        if (out == null) out = new Point();

        out.x = compositeEffect.getLayerAt(layerID).x;
        out.y = compositeEffect.getLayerAt(layerID).y;

        return out;
    }

    /** Indicates the position (in points) at which a certain layer will be drawn. */
    public function setOffsetAt(layerID:Int, x:Float, y:Float):Void
    {
        compositeEffect.getLayerAt(layerID).x = x;
        compositeEffect.getLayerAt(layerID).y = y;
    }

    /** Returns the RGB color with which a layer is tinted when it is being drawn.
     *  @default 0xffffff */
    public function getColorAt(layerID:Int):UInt
    {
        return compositeEffect.getLayerAt(layerID).color;
    }
	
	/** Indicates if the color of the given layer is replaced (true) or tinted (false). */
	public function getReplaceColorAt(layerID:Int):Bool
	{
		return compositeEffect.getLayerAt(layerID).replaceColor;
	}

    /** Adjusts the RGB color with which a layer is tinted when it is being drawn.
     *  If <code>replace</code> is enabled, the pixels are not tinted, but instead
     *  the RGB channels will replace the texture's color entirely.
     */
    public function setColorAt(layerID:Int, color:UInt, replace:Bool=false):Void
    {
        compositeEffect.getLayerAt(layerID).color = color;
        compositeEffect.getLayerAt(layerID).replaceColor = replace;
    }

    /** Indicates the alpha value with which the layer is drawn.
     *  @default 1.0 */
    public function getAlphaAt(layerID:Int):Float
    {
        return compositeEffect.getLayerAt(layerID).alpha;
    }

    /** Adjusts the alpha value with which the layer is drawn. */
    public function setAlphaAt(layerID:Int, alpha:Float):Void
    {
        compositeEffect.getLayerAt(layerID).alpha = alpha;
    }
	
	/** The mode with which the layer is drawn. @see starling.filters.CompositeMode */
	public function getModeAt(layerID:Int):String
	{
		return compositeEffect.getLayerAt(layerID).mode;
	}

	/** Sets the mode with which the layer is drawn. @see starling.filters.CompositeMode */
	public function setModeAt(layerID:Int, mode:String):Void
	{
		compositeEffect.getLayerAt(layerID).mode = mode;
	}

	/** Indicates if the alpha value of the given layer's fragments should be inverted,
	 *  effectively inverting the layer's silhouette. */
	public function getInvertAlphaAt(layerID:Int):Bool
	{
		return compositeEffect.getLayerAt(layerID).invertAlpha;
	}

	/** Activate this setting to invert the alpha values of this layer's fragments, which will
	 *  effectively invert the layer's silhouette. Note that this setting is only applied if
	 *  color replacement is activated on this layer. */
	public function setInvertAlphaAt(layerID:Int, value:Bool = true):Void
	{
		compositeEffect.getLayerAt(layerID).invertAlpha = value;
	}

    public var compositeEffect(get, never):CompositeEffect;
    private function get_compositeEffect():CompositeEffect
    {
        return cast this.effect;
    }
}


class CompositeEffect extends FilterEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat =
        FilterEffect.VERTEX_FORMAT.extend(
            "texCoords1:float2, texCoords2:float2, texCoords3:float2");

    private var _layers:Vector<CompositeLayer>;

    private static var sLayers:Array<CompositeLayer> = [];
    private static var sOffset:Vector<Float> = new Vector<Float>([0, 0, 0, 0.]);
    private static var sColor:Vector<Float>  = new Vector<Float>([0, 0, 0, 0.]);

    public function new(numLayers:Int=4)
    {
        super();

        if (numLayers < 1 || numLayers > 4)
            throw new ArgumentError("number of layers must be between 1 and 4");

        _layers = new Vector<CompositeLayer>(numLayers, true);

        for (i in 0...numLayers)
            _layers[i] = new CompositeLayer();
    }

    public function getLayerAt(layerID:Int):CompositeLayer
    {
        return _layers[layerID];
    }

    private function getUsedLayers(out:Array<CompositeLayer>=null):Array<CompositeLayer>
    {
        if (out == null) out = [];
        else out.splice(0, out.length);

        for (layer in _layers)
            if (layer.texture != null) out[out.length] = layer;

        return out;
    }

    override private function createProgram():Program
    {
        var layers:Array<CompositeLayer> = getUsedLayers(sLayers);
        var numLayers:Int = layers.length;
        var i:Int;

        if (numLayers != 0)
        {
            var vertexShader:Array<String> = ["m44 op, va0, vc0"]; // transform position to clip-space
            var layer:CompositeLayer = _layers[0];

            for (i in 0...numLayers) // v0-4 -> texture coords
                vertexShader.push(
                    'add v$i, va${i + 1}, vc${i + 4}' // add offset
                );

            var fragmentShader:Array<String> = [
                "sge ft5, v0, v0" // ft5 -> 1, 1, 1, 1
            ];

            for (i in 0...numLayers)
            {
                var fti:String = "ft" + i;
                var fci:String = "fc" + i;
                var vi:String  = "v"  + i;

                layer = _layers[i];

                fragmentShader.push(
                    FilterEffect.tex(fti, vi, i, layers[i].texture)  // fti => texture i color
                );

                if (layer.replaceColor)
                {
					if (layer.invertAlpha)
					{
                        fragmentShader.push(
                            "sub " + fti + ".w, ft5.w, " + fti + ".w"
                        );
					}
					
                    fragmentShader.push("mul " + fti + ".w,   " + fti + ".w,   " + fci + ".w");
                    fragmentShader.push("sat " + fti + ".w,   " + fti + ".w    "); // make sure alpha <= 1.0
                    fragmentShader.push("mul " + fti + ".xyz, " + fci + ".xyz, " + fti + ".www");
                }
                else
                    fragmentShader.push(
                        "mul " + fti + ", " + fti + ", " + fci // fti *= color
                    );

                if (i != 0)
                {
                    switch (layer.mode)
                    {
                        case CompositeMode.NORMAL:
                            // src × ONE + dst × ONE_MINUS_SOURCE_ALPHA
                            fragmentShader.push("sub ft4, ft5, " + fti + ".wwww"); // ft4 = 1 - src.alpha
                            fragmentShader.push("mul ft0, ft0, ft4");              // ft0 = dst * (1 - src.alpha)
                            fragmentShader.push("add ft0, ft0, " + fti);           // ft0 = src + (dst * (1 - src.alpha))
                            
                        case CompositeMode.INSIDE:
                            // src × DST_ALPHA + dst × ONE_MINUS_SOURCE_ALPHA
                            fragmentShader.push("mul ft4, ft0.wwww, " + fti);      // ft4 = src * dst.alpha
                            fragmentShader.push("sub ft6, ft5, " + fti + ".wwww"); // ft6 = 1 - src.alpha
                            fragmentShader.push("mul ft6, ft6, ft0");              // ft6 = dst * (1 - src.alpha)
                            fragmentShader.push("add ft0, ft6, ft4");              // ft0 = src * dst.alpha + dst * (1 - src.alpha)
                            
                        case CompositeMode.INSIDE_KNOCKOUT:
                            // src × DST_ALPHA
                            fragmentShader.push("mul ft0, ft0.wwww, " + fti);      // ft0 = src * dst.alpha
                            
                        case CompositeMode.OUTSIDE:
                            // src × ONE_MINUS_DST_ALPHA + dst
                            fragmentShader.push("sub ft4, ft5, ft0.wwww");   // ft4 = 1 - dst.alpha
                            fragmentShader.push("mul ft4, ft4, " + fti);     // ft4 = src * (1 - dst.alpha)
                            fragmentShader.push("add ft0, ft0, ft4");        // ft0 = src * (1 - dst.alpha) + dst
                            
                        case CompositeMode.OUTSIDE_KNOCKOUT:
                            // src × ONE_MINUS_DST_ALPHA
                            fragmentShader.push("sub ft4, ft5, ft0.wwww");   // ft4 = 1 - dst.alpha
                            fragmentShader.push("mul ft0, ft4, " + fti);     // ft0 = src * (1 - dst.alpha)
                            
                        default:
                            throw new ArgumentError("Invalid composite mode: " + layer.mode);
                    }
                }
            }

            fragmentShader.push("mov oc, ft0"); // done! :)

            return Program.fromSource(vertexShader.join("\n"), fragmentShader.join("\n"));
        }
        else
        {
            return super.createProgram();
        }
    }

    override private function get_programVariantName():UInt
    {
        var bits:UInt;
		var modeBits:UInt;
        var textureBits:UInt;
        var invertAlphaBit:UInt;
        var replaceColorBit:UInt;
        var totalBits:UInt = 0;
        var layer:CompositeLayer;
        var layers = getUsedLayers(sLayers);
        var numLayers:Int = layers.length;

        for (i in 0...numLayers)
        {
            layer = layers[i];
			textureBits = RenderUtil.getTextureVariantBits(layer.texture); // 3 bits
            modeBits = CompositeMode.getIndex(layer.mode); // 3 bits
            replaceColorBit = layer.replaceColor ? 1 : 0;
            invertAlphaBit = layer.invertAlpha ? 1 : 0;
            bits = textureBits | (modeBits << 3) | (replaceColorBit << 6) | (invertAlphaBit << 7);
            totalBits |= bits << (i * 8);
        }

        return totalBits;
    }

    /** vc0-vc3  — MVP matrix
     *  vc4-vc7  — layer offsets
     *  fs0-fs3  — input textures
     *  fc0-fc3  — input colors (RGBA+pma)
     *  va0      — vertex position (xy)
     *  va1-va4  — texture coordinates (without offset)
     *  v0-v3    — texture coordinates (with offset)
     */
    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);
        
        var layers:Array<CompositeLayer> = getUsedLayers(sLayers);
        var numLayers:Int = layers.length;

        if (numLayers != 0)
        {
            for (i in 0...numLayers)
            {
                var layer:CompositeLayer = layers[i];
                var texture:Texture = layer.texture;
                var alphaFactor:Float = layer.replaceColor ? 1.0 : layer.alpha;

                sOffset[0] = -layer.x / (texture.root.nativeWidth  / texture.scale);
                sOffset[1] = -layer.y / (texture.root.nativeHeight / texture.scale);
                sColor[0] = Color.getRed(layer.color)   * alphaFactor / 255.0;
                sColor[1] = Color.getGreen(layer.color) * alphaFactor / 255.0;
                sColor[2] = Color.getBlue(layer.color)  * alphaFactor / 255.0;
                sColor[3] = layer.alpha;

                context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, i + 4, sOffset);
                context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, i, sColor);
                
                if (i > 0)
                {
                    context.setTextureAt(i, texture.base);
                    RenderUtil.setSamplerStateAt(i, texture.mipMapping, textureSmoothing);
                    vertexFormat.setVertexBufferAt(i + 1, vertexBuffer, "texCoords" + i);
                }
            }
        }
    }

    override private function afterDraw(context:Context3D):Void
    {
        var layers:Array<CompositeLayer> = getUsedLayers(sLayers);
        var numLayers:Int = layers.length;

        for (i in 1...numLayers)
        {
            context.setTextureAt(i, null);
            context.setVertexBufferAt(i + 1, null);
        }

        super.afterDraw(context);
    }

    override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    // properties

    public var numLayers(get, never):Int;
    private function get_numLayers():Int { return _layers.length; }

    override private function set_texture(value:Texture):Texture
    {
        _layers[0].texture = value;
        super.texture = value;
        return value;
    }
}

class CompositeLayer
{
    public var texture:Texture;
    public var x:Float;
    public var y:Float;
    public var color:UInt;
    public var alpha:Float;
    public var replaceColor:Bool;
	public var invertAlpha:Bool;
    public var mode:String;

    public function new()
    {
        x = y = 0;
        alpha = 1.0;
        color = 0xffffff;
		mode = CompositeMode.NORMAL;
    }
}
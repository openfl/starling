// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.styles;
import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DProgramType;
import openfl.errors.Error;
import openfl.geom.Matrix;
import starling.core.Starling;
import starling.display.Mesh;
import starling.rendering.FilterEffect;
import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.RenderState;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.RenderUtil;

/**
   Provides a way to batch up to 5 (baseline profiles) or 16 different textures in one draw call, at the cost of more complex custom Fragment Shaders
   To use this, set Mesh.defaultStyle to MultiTextureStyle (ideally before Starling is initialised!)
**/
class MultiTextureStyle extends MeshStyle 
{
	/** The vertex format expected by this style. */
	public static var VERTEX_FORMAT:VertexDataFormat =
		MeshStyle.VERTEX_FORMAT.extend("texture:float1");
	
	/**
	   Maximum number of textures that can be batched.
	   Default value is 5 (which is the absolute max with baseline profile)
	   until <code>MultiTextureStyle.init()</code> has been called with Starling started
	   You can call it manually if you want/need, otherwise it will be called by the
	   first MultiTextureStyle instance created.
	**/
	public static var MAX_NUM_TEXTURES(get, never):Int;
	
	private static var __MAX_NUM_TEXTURES:Int = 5;
	private static function get_MAX_NUM_TEXTURES():Int { return __MAX_NUM_TEXTURES; }
	
	private var __dirty:Bool = true;
	private var __textures:Vector<Texture> = new Vector<Texture>();
	
	private static var sMaxTextures:Int = 2;
	private static var sTextureIndexMap:Array<Int> = new Array<Int>();
	
	/**
	   Maximum number of textures to be batched, default 2.
	**/
	public static var maxTextures(get, set):Int;
	private static function get_maxTextures():Int { return sMaxTextures; }
	private static function set_maxTextures(value:Int):Int
	{
		if (!__initDone) init();
		
		if (!__initDone)
		{
			// we don't know the profile yet, allow a max value of 16 (absolute max on non-baseline profile)
			// that number might be reduced when we can finally check profile
			value = value < 1 ? 1 : value > 16 ? 16 : value;
			sMaxTextures = value;
		}
		else
		{
			value = value < 1 ? 1 : value;
			sMaxTextures = value > __MAX_NUM_TEXTURES ? __MAX_NUM_TEXTURES : value;
		}
		return value;
	}
	
	private static var __TEXTURE_INDEX_FACTOR:Float;
	
	private static var __initDone:Bool = false;
	public static function init():Void
	{
		if (__initDone) return;
		if (Starling.current == null) return;
		
		var isBaseline:Bool = Starling.current.profile == Context3DProfile.BASELINE ||
							  Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED ||
							  Starling.current.profile == Context3DProfile.BASELINE_EXTENDED;
					   
		if (isBaseline)
		{
			__MAX_NUM_TEXTURES = 5;
			__TEXTURE_INDEX_FACTOR = 4.0;
		}
		else
		{
			__MAX_NUM_TEXTURES = 16;
			__TEXTURE_INDEX_FACTOR = 1.0;
		}
		
		__initDone = true;
	}

	public function new() 
	{
		super();
		
		if (!__initDone) init();
	}
	
	/** @private */
	override public function copyFrom(meshStyle:MeshStyle):Void 
	{
		var otherStyle:MultiTextureStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(meshStyle, MultiTextureStyle) ? cast meshStyle : null;
		
		if (otherStyle != null)
		{
			var length:Int = otherStyle.__textures.length;
			
			for (i in 0...length)
				__textures[i] = otherStyle.__textures[i];
			__textures.length = length;
		}
		
		super.copyFrom(meshStyle);
	}
	
	/** @private */
	override public function createEffect():MeshEffect 
	{
		return new MultiTextureEffect();
	}
	
	override public function updateEffect(effect:MeshEffect, state:RenderState):Void 
	{
		cast(effect, MultiTextureEffect).textures = __textures;
		
		super.updateEffect(effect, state);
	}
	
	override public function canBatchWith(meshStyle:MeshStyle):Bool 
	{
		var mtStyle:MultiTextureStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(meshStyle, MultiTextureStyle) ? cast meshStyle : null;
		
		if (mtStyle != null)
		{
			var numTexturesToAdd:Int = numTextures;
			var numTexturesHere:Int = mtStyle.numTextures;
			
			if (numTexturesToAdd > 0 && numTexturesHere > 0)
			{
				if (textureSmoothing == mtStyle.textureSmoothing &&
					textureRepeat == mtStyle.textureRepeat)
				{
					if (numTexturesHere + numTexturesToAdd > sMaxTextures)
					{
						var numSharedTextures:Int = 0;
						
						for (i in 0...numTexturesToAdd)
						{
							if (mtStyle.getTextureIndex(getTexture(i)) != -1)
								numSharedTextures ++;
						}
						return numTexturesHere + numTexturesToAdd - numSharedTextures <= sMaxTextures;
					}
					return true;
				}
			}
			else
			{
				return 0 == numTexturesToAdd && 0 == numTexturesHere;
			}
		}
		return false;
	}
	
	override public function batchVertexData(targetStyle:MeshStyle, targetVertexID:Int = 0,
											 matrix:Matrix = null, vertexID:Int = 0,
											 numVertices:Int = -1):Void 
	{
		var count:Int;
		
		if (matrix != null && __dirty)
		{
			count = vertexData.numVertices;
			for (i in 0...count)
				vertexData.setFloat(i, "texture", 0);
			__dirty = false;
		}
		
		super.batchVertexData(targetStyle, targetVertexID, matrix, vertexID, numVertices);
		
		var mtTarget:MultiTextureStyle = cast targetStyle;
		
		if (mtTarget != null)
		{
			var dirty:Bool = false;
			
			count = numTextures;
			for (i in 0...count)
			{
				var texture:Texture = getTexture(i);
				var textureIndexOnTarget:Int = mtTarget.getTextureIndex(texture);
				
				if (-1 == textureIndexOnTarget)
				{
					textureIndexOnTarget = mtTarget.numTextures;
					if (0 == textureIndexOnTarget)
						mtTarget.texture = texture;
					else
						mtTarget.__textures[mtTarget.__textures.length] = texture;
				}
				sTextureIndexMap[i] = textureIndexOnTarget;
				dirty = dirty || i != textureIndexOnTarget;
			}
			if (dirty)
			{
				var targetVertexData:VertexData = mtTarget.vertexData;
				if (numVertices < 0)
					numVertices = targetVertexData.numVertices - targetVertexID;
				for (i in 0...numVertices)
				{
					var sourceTexID:Int = Math.round(targetVertexData.getFloat(targetVertexID + i,
						"texture") * __TEXTURE_INDEX_FACTOR);
					var targetTexID:Int = sTextureIndexMap[sourceTexID];
					
					if (sourceTexID != targetTexID)
						targetVertexData.setFloat(targetVertexID + i, "texture", targetTexID / __TEXTURE_INDEX_FACTOR);
				}
			}
		}
	}
	
	/** @private */
	override function onTargetAssigned(target:Mesh):Void 
	{
		__dirty = true;
	}
	
	/** @private */
	override function get_vertexFormat():VertexDataFormat 
	{
		return VERTEX_FORMAT;
	}
	
	// Returns the texture's index in the shared texture list, or -1 if not
	// in the list.
	private function getTextureIndex(texture:Texture):Int
	{
		if (_textureRoot == texture) return 0;
		var length:Int = __textures.length;
		for (i in 0...length)
			if (__textures[i] == texture) return i + 1;
		return -1;
	}
	
	// Returns an element of the shared texture list.
	inline private function getTexture(index:Int):Texture
	{
		return index > 0 ? __textures[index - 1] : _textureRoot;
	}
	
	public var numTextures(get, never):Int;
	private function get_numTextures():Int { return _texture != null ? __textures.length + 1 : __textures.length; }
	
}

class MultiTextureEffect extends MeshEffect
{
	public static var VERTEX_FORMAT:VertexDataFormat = MultiTextureStyle.VERTEX_FORMAT;
	
	public var textures:Vector<Texture>;
	
	private var __isBaseline:Bool;
	
	private static var baselineTextureIndices:Vector<Float> = new Vector<Float>([
		0.125, 0.375, 0.625, 0.875,
		1, 0, 0, 0
	]);
	
	private static var textureIndices:Vector<Float> = new Vector<Float>([
		0.5, 1.5, 2.5, 3.5,
		4.5, 5.5, 6.5, 7.5,
		8.5, 9.5, 10.5, 11.5,
		12.5, 13.5, 14.5, 15.5
	]);
	
	private var _multiTexturingConstants:Vector<Float>;
	
	public function new()
	{
		super();
		__isBaseline = Starling.current.profile == Context3DProfile.BASELINE ||
					   Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED ||
					   Starling.current.profile == Context3DProfile.BASELINE_EXTENDED;
		
		if (__isBaseline)
		{
			_multiTexturingConstants = baselineTextureIndices;
		}
		else
		{
			_multiTexturingConstants = textureIndices;
		}
	}
	
	override function get_programVariantName():UInt 
	{
		var bits:UInt = super.get_programVariantName();
		
		for (i in 0...textures.length)
			bits |= RenderUtil.getTextureVariantBits(textures[i]) << (i + 4);
		
		return bits;
	}
	
	override function createProgram():Program 
	{
		var length:Int = textures.length;
		
		if (length > 0)
		{
			var fragmentShader:Array<String> = new Array<String>();
			var vertexShader:String = 
				"m44 op, va0, vc0\n" +	// 4x4 matrix transform to output clip-space
				"mov v0, va1\n" +		// pass texture coordinates to fragment program
				"mul v1, va2, vc4\n" +	// multiply alpha (vc4) with color (va2), pass to fp
				"mov v2, va3";			// pass texture sampler index to fp
			
			if (__isBaseline)
			{
				fragmentShader.push("slt ft4, v2.xxxx, fc0");
				fragmentShader.push(FilterEffect.tex("ft0", "v0", 0, texture));
				fragmentShader.push("min ft5, ft4.xxxx, ft0");
				fragmentShader.push("sub ft6, fc1.xxxx, ft4");
				fragmentShader.push(FilterEffect.tex("ft1", "v0", 1, textures[0]));
				
				if (length > 1)
				{
					fragmentShader.push("min ft6.xyz, ft6.xyz, ft4.yzw");
					fragmentShader.push("min ft0, ft6.xxxx, ft1");
					fragmentShader.push("add ft5, ft5, ft0");
					fragmentShader.push(FilterEffect.tex("ft2", "v0", 2, textures[1]));
					fragmentShader.push("min ft0, ft6.yyyy, ft2");
					
					if (length > 2)
					{
						fragmentShader.push("add ft5, ft5, ft0");
						fragmentShader.push(FilterEffect.tex("ft3", "v0", 3, textures[2]));
						fragmentShader.push("min ft0, ft6.zzzz, ft3");
						
						if (length > 3)
						{
							fragmentShader.push("add ft5, ft5, ft0");
							fragmentShader.push(FilterEffect.tex("ft4", "v0", 4, textures[3]));
							fragmentShader.push("min ft0, ft6.wwww, ft4");
						}
					}
				}
				else
				{
					fragmentShader.push("min ft0, ft6.xxxx, ft1");
				}
				fragmentShader.push("add ft5, ft5, ft0");
				fragmentShader.push("mul oc, ft5, v1");	// multiply color with texel color
			}
			else
			{
				textures.unshift(_texture); // add base texture temporarily
				multiTex(fragmentShader, textures);
				textures.shift(); // remove base texture
				
                fragmentShader.push(
                    "mul oc, ft0, v1" // multiply color with texel color
                );
			}
			return Program.fromSource(vertexShader, fragmentShader.join("\n"),
				   __isBaseline ? 1 : 2, !__isBaseline);
		}
		
		return super.createProgram();
	}
	
	private function multiTex(data:Array<String>, textures:Vector<Texture>, numTextures:Int = 0, textureOffset:Int = 0, textureRegister:String = "ft0", textureIndexSource:String = "v2.x", constantsStartIndex:Int = 0):Void
	{
		if (numTextures == 0) numTextures = textures.length;
		
		if (numTextures <= 2)
		{
			if (numTextures == 2)
			{
				checkTexIndex(data, textureOffset, textureIndexSource, constantsStartIndex);
				data[data.length] = RenderUtil.createAGALTexOperation(textureRegister, "v0", textureOffset, textures[textureOffset]);
				data[data.length] = "els";
				data[data.length] = RenderUtil.createAGALTexOperation(textureRegister, "v0", textureOffset + 1, textures[textureOffset + 1]);
				data[data.length] = "eif";
			}
			else
			{
				data[data.length] = RenderUtil.createAGALTexOperation(textureRegister, "v0", textureOffset, textures[textureOffset]);
			}
		}
		else
		{
			var halfNumTextures:Int = Math.ceil(numTextures / 2);
			var remainingTextures:Int = numTextures - halfNumTextures;
			
			checkTexIndex(data, textureOffset + halfNumTextures - 1, textureIndexSource, constantsStartIndex);
			multiTex(data, textures, halfNumTextures, textureOffset, textureRegister, textureIndexSource, constantsStartIndex);
			data[data.length] = "els";
			multiTex(data, textures, remainingTextures, textureOffset + halfNumTextures, textureRegister, textureIndexSource, constantsStartIndex);
			data[data.length] = "eif";
		}
	}
	
	private function checkTexIndex(data:Array<String>, textureNum:Int, textureIndexSource:String, constantsStartIndex:Int):Void
	{
		var constantIndex:Int = constantsStartIndex + Math.floor(textureNum / 4);
		var constantSubIndex:Int = textureNum % 4;
		var constant:String;
		
		switch (constantSubIndex)
		{
			case 0 :
				constant = " fc" + constantIndex + ".x";
			
			case 1 :
				constant = " fc" + constantIndex + ".y";
			
			case 2 :
				constant = " fc" + constantIndex + ".z";
			
			case 3 :
				constant = " fc" + constantIndex + ".w";
			
			default :
				throw new Error("incorrect constant sub index");
		}
		
		data[data.length] = "ifl " + textureIndexSource + constant;
	}
	
	override function beforeDraw(context:Context3D):Void 
	{
		super.beforeDraw(context);
		
		var length:Int = textures.length;
		
		if (length > 0)
		{
			for (i in 0...length)
			{
				var texture:Texture = textures[i];
				
				RenderUtil.setSamplerStateAt(i + 1, texture.mipMapping, textureSmoothing, textureRepeat);
				context.setTextureAt(i + 1, texture.base);
			}
			vertexFormat.setVertexBufferAt(3, vertexBuffer, "texture");
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,
				0, _multiTexturingConstants, __isBaseline ? 2 : Math.ceil((length + 1) / 4));
		}
	}
	
	override function afterDraw(context:Context3D):Void 
	{
		var length:Int = textures.length;
		
		if (length > 0)
		{
			for (i in 0...length) context.setTextureAt(i + 1, null);
			context.setVertexBufferAt(3, null);
		}
		
		super.afterDraw(context);
	}
	
	override function get_vertexFormat():VertexDataFormat 
	{
		return VERTEX_FORMAT;
	}
}
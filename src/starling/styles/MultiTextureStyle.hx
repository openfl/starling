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

/** Provides a way to batch up to 4 different textures in one draw call, at the cost of more complex custom Fragment Shaders
 *  To use this, set Mesh.defaultStyle to MultiTextureStyle (ideally before Starling is initialised!)
 **/
class MultiTextureStyle extends MeshStyle 
{
	/** The vertex format expected by this style. */
	public static var VERTEX_FORMAT:VertexDataFormat =
		MeshStyle.VERTEX_FORMAT.extend("texture:float1");
	
	/** Maximum number of textures that can be batched. */
	public static var MAX_NUM_TEXTURES:Int = 5;
	
	private var __dirty:Bool = true;
	private var __textures:Vector<Texture> = new Vector<Texture>();
	
	private static var sMaxTextures:Int = 2;
	private static var sTextureIndexMap:Array<Int> = new Array<Int>();
	
	public static var maxTextures(get, set):Int;
	private static function get_maxTextures():Int { return sMaxTextures; }
	private static function set_maxTextures(value:Int):Int
	{
		value = value < 1 ? 1 : value;
		sMaxTextures = value > MAX_NUM_TEXTURES ? MAX_NUM_TEXTURES : value;
		return value;
	}

	public function new() 
	{
		super();
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
						
						for (i in 0...numSharedTextures)
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
		var length:Int;
		
		if (matrix != null && __dirty)
		{
			length = vertexData.numVertices;
			for (i in 0...length)
				vertexData.setFloat(i, "texture", 0);
			__dirty = false;
		}
		
		super.batchVertexData(targetStyle, targetVertexID, matrix, vertexID, numVertices);
		
		var mtTarget:MultiTextureStyle = cast targetStyle;
		
		if (mtTarget != null)
		{
			var dirty:Bool = false;
			
			length = numTextures;
			for (i in 0...length)
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
						"texture") * 4);
					var targetTexID:Int = sTextureIndexMap[sourceTexID];
					
					if (sourceTexID != targetTexID)
						targetVertexData.setFloat(targetVertexID + i, "texture", targetTexID / 4);
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
		var length:Int = numTextures;
		for (i in 0...length)
			if (getTexture(i).root == texture.root) return i;
		return -1;
	}
	
	// Returns an element of the shared texture list.
	inline private function getTexture(index:Int):Texture
	{
		return index > 0 ? __textures[index - 1] : texture;
	}
	
	public var numTextures(get, never):Int;
	private function get_numTextures():Int { return texture != null ? __textures.length + 1 : __textures.length; }
	
}

class MultiTextureEffect extends MeshEffect
{
	public static var VERTEX_FORMAT:VertexDataFormat = MultiTextureStyle.VERTEX_FORMAT;
	
	public var textures:Vector<Texture>;
	
	private var __isBaseline:Bool;
	
	private static var kTextureIndices:Vector<Float> = new Vector<Float>([
		0.125, 0.375, 0.625, 0.875,
		1, 0, 0, 0
	]);
	
	public function new()
	{
		super();
		__isBaseline = Starling.current.profile == Context3DProfile.BASELINE ||
					   Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED ||
					   Starling.current.profile == Context3DProfile.BASELINE_EXTENDED;
	}
	
	override function get_programVariantName():UInt 
	{
		var bits:UInt = super.get_programVariantName();
		
		for (i in 0...textures.length)
			bits |= RenderUtil.getTextureVariantBits(textures[i]) << (4 * i + 4);
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
				if (length > 1)
				{
					fragmentShader.push("slt ft4, v2.xxxx, fc0");
					fragmentShader.push("sub ft6, fc1.xxxx, ft4");
					fragmentShader.push("min ft6.xyz, ft6.xyz, ft4.yzw");
					fragmentShader.push("ifg ft4.x, fc0.z");
					fragmentShader.push(FilterEffect.tex("ft5", "v0", 0, texture));
					fragmentShader.push("eif");
					fragmentShader.push("ifg ft6.x, fc0.z");
					fragmentShader.push(FilterEffect.tex("ft5", "v0", 1, textures[0]));
					fragmentShader.push("eif");
					fragmentShader.push("ifg ft6.y, fc0.z");
					fragmentShader.push(FilterEffect.tex("ft5", "v0", 2, textures[1]));
					fragmentShader.push("eif");
					
					if (length > 2)
					{
						fragmentShader.push("ifg ft6.z, fc0.z");
						fragmentShader.push(FilterEffect.tex("ft5", "v0", 3, textures[2]));
						fragmentShader.push("eif");
						
						if (length > 3)
						{
							fragmentShader.push("ifg ft6.w, fc0.z");
							fragmentShader.push(FilterEffect.tex("ft5", "v0", 4, textures[3]));
							fragmentShader.push("eif");
						}
					}
					
				}
				else
				{
					fragmentShader.push("ifl v2.x, fc0.x");
					fragmentShader.push(FilterEffect.tex("ft5", "v0", 0, texture));
					fragmentShader.push("els");
					fragmentShader.push(FilterEffect.tex("ft5", "v0", 1, textures[0]));
					fragmentShader.push("eif");
				}
				fragmentShader.push("mul oc, ft5, v1");	// multiply color with texel color
			}
			return Program.fromSource(vertexShader, fragmentShader.join("\n"),
				   __isBaseline ? 1 : 2);
		}
		
		return super.createProgram();
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
				0, kTextureIndices, length > 1 || __isBaseline ? -1 : 1);
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
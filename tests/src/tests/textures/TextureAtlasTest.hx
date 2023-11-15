// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.textures;

import openfl.Vector;
import openfl.geom.Rectangle;
import org.hamcrest.Matchers.closeTo;
import starling.display.Image;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import tests.utils.MockTexture;
import utest.Assert;
import utest.Test;

class TextureAtlasTest extends Test
{
	@:final private var E:Float = 0.0001;
	
	public function testXmlParsing():Void
	{
		var xml:String =
			'<TextureAtlas>
				<SubTexture name="ann" x="0"   y="0"  width="55.5" height="16" />
				<SubTexture name="bob" x="16"  y="32" width="16"   height="32" />
			</TextureAtlas>';
		
		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture, xml);
		
		var ann:Texture = atlas.getTexture("ann");            
		var bob:Texture = atlas.getTexture("bob");
		
		Assert.isOfType(ann, SubTexture);
		Assert.isOfType(bob, SubTexture);
		
		Assert.equals(55.5, ann.width);
		Assert.equals(16, ann.height);
		Assert.equals(16, bob.width);
		Assert.equals(32, bob.height);
		
		var annST:SubTexture = #if haxe4 Std.downcast #else Std.instance #end(ann, SubTexture);
		var bobST:SubTexture = #if haxe4 Std.downcast #else Std.instance #end(bob, SubTexture);
		
		Assert.equals(0, annST.region.x);
		Assert.equals(0, annST.region.y);
		Assert.equals(16, bobST.region.x);
		Assert.equals(32, bobST.region.y);
	}

	
	public function testPivotParsing():Void
	{
		var xml:String =
			'<TextureAtlas>
				<SubTexture name="ann" x="0" y="0" width="16" height="32" pivotX="8" pivotY="16"/>
				<SubTexture name="bob" x="16" y="0" width="16" height="32" pivotX="4.0"/>
				<SubTexture name="cal" x="32" y="0" width="16" height="32"/>
			</TextureAtlas>';

		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture, xml);

		var ann:Texture = atlas.getTexture("ann");
		var bob:Texture = atlas.getTexture("bob");
		var cal:Texture = atlas.getTexture("cal");

		var annImage:Image = new Image(ann);
		Helpers.assertThat(annImage.pivotX, closeTo(8.0, E));
		Helpers.assertThat(annImage.pivotY, closeTo(16.0, E));

		var bobImage:Image = new Image(bob);
		Assert.equals(bobImage.pivotX, 4.0);
		Assert.equals(bobImage.pivotY, 0.0);

		var calImage:Image = new Image(cal);
		Assert.equals(calImage.pivotX, 0.0);
		Assert.equals(calImage.pivotY, 0.0);
	}

	
	public function testPivotDuplication():Void
	{
		var xml:String =
			'<TextureAtlas>
				<SubTexture name="ann0001" x="0" y="0" width="16" height="32" pivotX="8" pivotY="16"/>
				<SubTexture name="ann0002" x="16" y="0" width="16" height="32"/>
				<SubTexture name="anne" x="32" y="0" width="16" height="32"/>
			</TextureAtlas>';

		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture, xml);

		var ann1:Texture = atlas.getTexture("ann0001");
		var ann2:Texture = atlas.getTexture("ann0002");
		var anne:Texture = atlas.getTexture("anna");

		var annImage1:Image = new Image(ann1);
		Helpers.assertThat(annImage1.pivotX, closeTo(8.0, E));
		Helpers.assertThat(annImage1.pivotY, closeTo(16.0, E));

		var annImage2:Image = new Image(ann2);
		Helpers.assertThat(annImage2.pivotX, closeTo(8.0, E));
		Helpers.assertThat(annImage2.pivotY, closeTo(16.0, E));

		var anneImage:Image = new Image(anne);
		Assert.equals(anneImage.pivotX, 0.0);
		Assert.equals(anneImage.pivotY, 0.0);
	}
	
	
	public function testManualCreation():Void
	{
		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture);
		
		atlas.addRegion("ann", new Rectangle(0, 0, 55.5, 16));
		atlas.addRegion("bob", new Rectangle(16, 32, 16, 32));
		
		Assert.notNull(atlas.getTexture("ann"));
		Assert.notNull(atlas.getTexture("bob"));
		Assert.isNull(atlas.getTexture("carl"));
		
		atlas.removeRegion("carl"); // should not blow up
		atlas.removeRegion("bob");
		
		Assert.isNull(atlas.getTexture("bob"));
	}

	
	public function testAddSubTexture():Void
	{
		var texture:Texture = new MockTexture(64, 64);
		var subTexture:SubTexture = new SubTexture(texture, new Rectangle(32, 32, 32, 32));
		var atlas:TextureAtlas = new TextureAtlas(texture);
		atlas.addSubTexture("subTexture", subTexture);
		Assert.equals(atlas.getTexture("subTexture"), subTexture);
	}
	
	
	public function testGetTextures():Void
	{
		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture);
		
		Assert.equals(texture, atlas.texture);
		
		atlas.addRegion("ann", new Rectangle(0, 0, 8, 8));
		atlas.addRegion("prefix_3", new Rectangle(8, 0, 3, 8));
		atlas.addRegion("prefix_1", new Rectangle(16, 0, 1, 8));
		atlas.addRegion("bob", new Rectangle(24, 0, 8, 8));
		atlas.addRegion("prefix_2", new Rectangle(32, 0, 2, 8));
		
		var textures:Vector<Texture> = atlas.getTextures("prefix_");
		
		Assert.equals(3, textures.length);
		Assert.equals(1, textures[0].width);
		Assert.equals(2, textures[1].width);
		Assert.equals(3, textures[2].width);
	}

	
	public function testRemoveRegion():Void
	{
		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture);

		atlas.addRegion("ann", new Rectangle(0, 0, 10, 10));
		atlas.addRegion("bob", new Rectangle(10, 0, 10, 10));

		atlas.removeRegion("ann");

		Assert.isNull(atlas.getTexture("ann"));
		Assert.notNull(atlas.getTexture("bob"));
	}

	
	public function testRemoveRegions():Void
	{
		var texture:Texture = new MockTexture(64, 64);
		var atlas:TextureAtlas = new TextureAtlas(texture);

		atlas.addRegion("albert", new Rectangle(0, 0, 10, 10));
		atlas.addRegion("anna", new Rectangle(0, 10, 10, 10));
		atlas.addRegion("bastian", new Rectangle(0, 20, 10, 10));
		atlas.addRegion("cesar", new Rectangle(0, 30, 10, 10));

		atlas.removeRegions("a");

		Assert.isNull(atlas.getTexture("albert"));
		Assert.isNull(atlas.getTexture("anna"));
		Assert.notNull(atlas.getTexture("bastian"));
		Assert.notNull(atlas.getTexture("cesar"));

		atlas.removeRegions();

		Assert.isNull(atlas.getTexture("bastian"));
		Assert.isNull(atlas.getTexture("cesar"));
	}
}
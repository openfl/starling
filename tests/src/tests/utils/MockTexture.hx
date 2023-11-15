// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.utils;

import starling.textures.ConcreteTexture;

class MockTexture extends ConcreteTexture
{
	private var _disposed:Bool = false;

	public function new(width:Int=16, height:Int=16, scale:Float=1)
	{
		super(null, "bgra", width, height, false, true, false, scale);
	}

	override public function dispose():Void
	{
		super.dispose();
		_disposed = true;
	}

	public var isDisposed(get, never):Bool;

	private function get_isDisposed():Bool { return _disposed; }
}
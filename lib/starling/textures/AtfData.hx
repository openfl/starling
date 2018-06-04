// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import openfl.display3D.Context3DTextureFormat;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.utils.ByteArray;

/** A parser for the ATF data format. */

@:jsRequire("starling/textures/AtfData", "default")

extern class AtfData
{
    /** Create a new instance by parsing the given byte array. */
    public function new(data:ByteArray);

    /** Checks the first 3 bytes of the data for the 'ATF' signature. */
    public static function isAtfData(data:ByteArray):Bool;

    /** The texture format. @see flash.display3D.textures.Context3DTextureFormat */
    public var format(get, never):String;
    private function get_format():String;

    /** The width of the texture in pixels. */
    public var width(get, never):Int;
    private function get_width():Int;

    /** The height of the texture in pixels. */
    public var height(get, never):Int;
    private function get_height():Int;

    /** The number of encoded textures. '1' means that there are no mip maps. */
    public var numTextures(get, never):Int;
    private function get_numTextures():Int;

    /** Indicates if the ATF data encodes a cube map. Not supported by Starling! */
    public var isCubeMap(get, never):Bool;
    private function get_isCubeMap():Bool;

    /** The actual byte data, including header. */
    public var data(get, never):ByteArray;
    private function get_data():ByteArray;
}
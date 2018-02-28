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

/** This class is an enumeration of possible types of bitmap fonts. */
class BitmapFontType
{
	/** A standard bitmap font uses a regular RGBA texture containing all glyphs. */
	public static inline var STANDARD:String = "standard";

	/** Indicates that the font texture contains a single channel distance field texture
	 *  to be rendered with the <em>DistanceFieldStyle</em>. */
	public static inline var DISTANCE_FIELD:String = "distanceField";

	/** Indicates that the font texture contains a multi channel distance field texture
	 *  to be rendered with the <em>DistanceFieldStyle</em>. */
	public static inline var MULTI_CHANNEL_DISTANCE_FIELD:String = "multiChannelDistanceField";
}

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

/** An enumeration class with the available modes that are offered by the CompositeFilter
 *  to draw layers on top of each other.
 *
 *  @see starling.filters.CompositeFilter
 */
class CompositeMode
{
    private static var allModes:Array<String> = [
		NORMAL, INSIDE, INSIDE_KNOCKOUT, OUTSIDE, OUTSIDE_KNOCKOUT
	];

	/** Draw layer on top of destination. Corresponds to BlendMode.NORMAL.
	 *  <code>src + dst × (1 - src.alpha)</code> */
	public static inline var NORMAL:String = "normal";

	/** Draw layer on top of the destination using the destination's alpha value.
	 *  <code>src × dst.alpha + dst × (1 - src.alpha)</code> */
	public static inline var INSIDE:String = "inside";

	/** Draw layer on top of the destination, using the destination's inverted alpha value.
	 *  <code>src × (1 - dst.alpha) + dst</code> */
	public static inline var OUTSIDE:String = "outside";

	/** Draw only the new layer (erasing the old), using the destination's alpha value.
	 *  <code>src × dst.alpha</code> */
	public static inline var INSIDE_KNOCKOUT:String = "insideKnockout";

	/** Draw only the new layer (erasing the old), using the destination's inverted alpha value.
	 *  <code>src × (1 - dst.alpha)</code> */
	public static inline var OUTSIDE_KNOCKOUT:String = "outsideKnockout";

	/** Returns a different integer for each mode. */
	public static function getIndex(mode:String):Int
	{
		return allModes.indexOf(mode);
	}
}
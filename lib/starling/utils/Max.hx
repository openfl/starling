package starling.utils;

/**
 * A Collection of largest/smallest representable numbers.
 */

@:jsRequire("starling/utils/Max", "default")

extern class Max
{
	/** The largest representable number. */
	public static var MAX_VALUE:Float;

	/** The smallest representable number. */
	public static var MIN_VALUE:Float;

	/** The largest representable 32-bit signed integer. */
	public static var INT_MAX_VALUE:Int;

	/** The smallest representable 32-bit signed integer. */
	public static var INT_MIN_VALUE:Int;

    /** he largest representable 32-bit unsigned integer. */
    public static var UINT_MAX_VALUE:UInt;
}
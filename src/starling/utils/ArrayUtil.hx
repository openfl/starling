package starling.utils;

/**
 * Array Utility.
 */
class ArrayUtil {
	/**
	 * Truncates an array to the specified length.
	 * @param arr The array to truncate.
	 * @param newSize The new size of the array.
	 */
	public static function truncate<T>(arr:Array<T>, newSize:Int):Void {
		if (newSize < arr.length) {
			arr.splice(newSize, arr.length - newSize);
		}
	}

	/**
	 * Extends an array to the specified length, filling new elements with the default value.
	 * @param arr The array to extend.
	 * @param newSize The new size of the array.
	 * @param defaultValue The value to fill new elements with.
	 */
	public static function extend<T>(arr:Array<T>, newSize:Int, defaultValue:T = null):Void {
		while (arr.length < newSize) {
			arr.push(defaultValue);
		}
	}

	/**
	 * Resizes an array to the specified length, truncating or extending as needed.
	 * @param arr The array to resize.
	 * @param newSize The new size of the array.
	 * @param defaultValue The value to fill new elements with when extending.
	 */
	public static function resize<T>(arr:Array<T>, newSize:Int, defaultValue:T = null):Void {
		if (newSize < arr.length) {
			truncate(arr, newSize);
		} else {
			extend(arr, newSize, defaultValue);
		}
	}
}

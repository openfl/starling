declare namespace starling.utils
{
	export class Execute
	{
		/** Executes a with the specified arguments. If the argument count does not match
		 *  the function, the argument list is cropped / filled up with <code>null</code> values. */
		public static execute(func:Function, args:Array<any> = null):void;
	}
}

export default starling.utils.Execute;
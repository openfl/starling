import Error from "openfl/errors/Error";

declare namespace starling.errors
{
	/** A NotSupportedError is thrown when you attempt to use a feature that is not supported
	 *  on the current platform. */
	export class NotSupportedError extends Error
	{
		/** Creates a new NotSupportedError object. */
		public constructor(message?:string, id?:number);
	}
}

export default starling.errors.NotSupportedError;
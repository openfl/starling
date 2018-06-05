import Error from "openfl/errors/Error";

declare namespace starling.errors
{
	/** An AbstractMethodError is thrown when you attempt to call an abstract method. */
	export class AbstractMethodError extends Error
	{
		/** Creates a new AbstractMethodError object. */
		public constructor(message?:string, id?:number);
	}
}

export default starling.errors.AbstractMethodError;
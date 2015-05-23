// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.errors;
import openfl.errors.Error;
/** An AbstractClassError is thrown when you attempt to create an instance of an abstract 
 *  class. */
class AbstractClassError extends Error
{
    /** Creates a new AbstractClassError object. */
    public function new(message="Cannot instantiate abstract class", id=0)
    {
        super(message, id);
    }
}
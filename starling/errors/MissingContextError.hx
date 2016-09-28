// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.errors;

import flash.errors.Error;

/** A MissingContextError is thrown when a Context3D object is required but not (yet) 
 *  available. */
class MissingContextError extends Error
{
    /** Creates a new MissingContextError object. */
    public function new(message="Starling context is missing", id=0)
    {
        super(message, id);
    }
}
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

import openfl.errors.ArgumentError;
import openfl.Vector;

import starling.events.Event;
import starling.rendering.Painter;
import starling.textures.Texture;
import starling.utils.Padding;

/** The FilterChain allows you to combine several filters into one. The filters will be
 *  processed in the given order, the number of draw calls per filter adding up.
 *  Just like conventional filters, a chain may be attached to any display object.
 */

@:jsRequire("starling/filters/FilterChain", "default")

extern class FilterChain extends FragmentFilter
{
    /** Creates a new chain with the given filters. */
    public function new(args:Array<FragmentFilter>);

    /** Disposes the filter chain itself as well as all contained filters. */
    override public function dispose():Void;

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    /** Returns the filter at a certain index. If you pass a negative index,
     *  '-1' will return the last filter, '-2' the second to last filter, etc. */
    public function getFilterAt(index:Int):FragmentFilter;

    /** Adds a filter to the chain. It will be appended at the very end. */
    public function addFilter(filter:FragmentFilter):Void;

    /** Adds a filter to the chain at the given index. */
    public function addFilterAt(filter:FragmentFilter, index:Int):Void;

    /** Removes a filter from the chain. If the filter is not part of the chain,
     *  nothing happens. If requested, the filter will be disposed right away. */
    public function removeFilter(filter:FragmentFilter, dispose:Bool=false):FragmentFilter;

    /** Removes the filter at a certain index. The indices of any subsequent filters
     *  are decremented. If requested, the filter will be disposed right away. */
    public function removeFilterAt(index:Int, dispose:Bool=false):FragmentFilter;

    /** Returns the index of a filter within the chain, or "-1" if it is not found. */
    public function getFilterIndex(filter:FragmentFilter):Int;

    /** Indicates the current chain length. */
    public var numFilters(get, never):Int;
    private function get_numFilters():Int;
}
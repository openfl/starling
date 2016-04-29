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
import starling.events.Event;
import starling.rendering.Painter;
import starling.textures.Texture;
import starling.utils.ArrayUtil;
import starling.utils.Padding;

/** The FilterChain allows you to combine several filters into one. The filters will be
 *  processed in the given order, the number of draw calls per filter adding up.
 *  Just like conventional filters, a chain may be attached to any display object.
 */
class FilterChain extends FragmentFilter
{
    private var _filters:Array<FragmentFilter>;

    // helpers
    private static var sPadding:Padding = new Padding();

    /** Creates a new chain with the given filters. */
    public function new(args:Array<FragmentFilter> = null)
    {
        super();
        #if 0
        _filters = new Array<FragmentFilter>();

        if (args != null)
        {
            for (i in 0 ... args.length)
            {
                var filter:FragmentFilter = args[i];
                if (filter) addFilterAt(filter, i);
                else throw new ArgumentError("pass only fragment filters to the constructor");
            }
        }
        #else
        _filters = args != null ? args.copy() : [];
        #end

        updatePadding();
    }

    /** Disposes the filter chain itself as well as all contained filters. */
    override public function dispose():Void
    {
        for (filter in _filters)
            filter.dispose();

        ArrayUtil.clear(_filters);

        super.dispose();
    }

    /** @private */
    override private function setRequiresRedraw():Void
    {
        updatePadding();
        super.setRequiresRedraw();
    }

    /** @private */
    override public function process(painter:Painter, pool:ITexturePool,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        var numFilters:Int = _filters.length;
        var outTexture:Texture = input0;
        var inTexture:Texture;

        for (i in 0 ... numFilters)
        {
            inTexture = outTexture;
            outTexture = _filters[i].process(painter, pool, inTexture);

            if (i != 0) pool.putTexture(inTexture);
        }

        return outTexture;
    }

    /** Returns the filter at a certain index. If you pass a negative index,
     *  '-1' will return the last filter, '-2' the second to last filter, etc. */
    public function getFilterAt(index:Int):FragmentFilter
    {
        if (index < 0) index += numFilters;
        return _filters[index];
    }

    /** Adds a filter to the chain. It will be appended at the very end. */
    public function addFilter(filter:FragmentFilter):Void
    {
        addFilterAt(filter, _filters.length);
    }

    /** Adds a filter to the chain at the given index. */
    public function addFilterAt(filter:FragmentFilter, index:Int):Void
    {
        _filters.insert(index, filter);
        filter.addEventListener(Event.CHANGE, setRequiresRedraw);
        setRequiresRedraw();
    }

    /** Removes a filter from the chain. If the filter is not part of the chain,
     *  nothing happens. If requested, the filter will be disposed right away. */
    public function removeFilter(filter:FragmentFilter, dispose:Bool=false):FragmentFilter
    {
        var filterIndex:Int = getFilterIndex(filter);
        if (filterIndex != -1) removeFilterAt(filterIndex, dispose);
        return filter;
    }

    /** Removes the filter at a certain index. The indices of any subsequent filters
     *  are decremented. If requested, the filter will be disposed right away. */
    public function removeFilterAt(index:Int, dispose:Bool=false):FragmentFilter
    {
        var filter:FragmentFilter = ArrayUtil.removeAt(_filters, index);
        filter.removeEventListener(Event.CHANGE, setRequiresRedraw);
        if (dispose) filter.dispose();
        setRequiresRedraw();
        return filter;
    }

    /** Returns the index of a filter within the chain, or "-1" if it is not found. */
    public function getFilterIndex(filter:FragmentFilter):Int
    {
        return _filters.indexOf(filter);
    }

    private function updatePadding():Void
    {
        sPadding.setTo();

        for (filter in _filters)
        {
            var padding:Padding = filter.padding;
            if (padding.left   > sPadding.left)   sPadding.left   = padding.left;
            if (padding.right  > sPadding.right)  sPadding.right  = padding.right;
            if (padding.top    > sPadding.top)    sPadding.top    = padding.top;
            if (padding.bottom > sPadding.bottom) sPadding.bottom = padding.bottom;
        }

        this.padding.copyFrom(sPadding);
    }

    /** Indicates the current chain length. */
    public var numFilters(get, never):Int;
    @:noCompletion private function get_numFilters():Int { return _filters.length; }
}

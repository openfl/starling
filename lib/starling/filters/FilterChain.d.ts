import FragmentFilter from "./../../starling/filters/FragmentFilter";
import Padding from "./../../starling/utils/Padding";
import Vector from "openfl/Vector";
import ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.filters
{
	/** The FilterChain allows you to combine several filters into one. The filters will be
	 *  processed in the given order, the number of draw calls per filter adding up.
	 *  Just like conventional filters, a chain may be attached to any display object.
	 */
	export class FilterChain extends FragmentFilter
	{
		/** Creates a new chain with the given filters. */
		public constructor(args:Array<FragmentFilter>);
	
		/** Disposes the filter chain itself as well as all contained filters. */
		/*override*/ public dispose():void;
	
		/** @protected */
		/*override*/ public process(painter:Painter, helper:IFilterHelper,
										 input0?:Texture, input1?:Texture,
										 input2?:Texture, input3?:Texture):Texture;
	
		/** Returns the filter at a certain index. If you pass a negative index,
		 *  '-1' will return the last filter, '-2' the second to last filter, etc. */
		public getFilterAt(index:number):FragmentFilter;
	
		/** Adds a filter to the chain. It will be appended at the very end. */
		public addFilter(filter:FragmentFilter):void;
	
		/** Adds a filter to the chain at the given index. */
		public addFilterAt(filter:FragmentFilter, index:number):void;
	
		/** Removes a filter from the chain. If the filter is not part of the chain,
		 *  nothing happens. If requested, the filter will be disposed right away. */
		public removeFilter(filter:FragmentFilter, dispose?:boolean):FragmentFilter;
	
		/** Removes the filter at a certain index. The indices of any subsequent filters
		 *  are decremented. If requested, the filter will be disposed right away. */
		public removeFilterAt(index:number, dispose?:boolean):FragmentFilter;
	
		/** Returns the index of a filter within the chain, or "-1" if it is not found. */
		public getFilterIndex(filter:FragmentFilter):number;
	
		/** Indicates the current chain length. */
		public readonly numFilters:number;
		protected get_numFilters():number;
	}
}

export default starling.filters.FilterChain;
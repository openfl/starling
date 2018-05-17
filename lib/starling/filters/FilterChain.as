package starling.filters {

	import starling.filters.FragmentFilter;
	import starling.utils.Padding;

	/**
	 * @externs
	 */
	public class FilterChain extends FragmentFilter {
		public function get numFilters():int { return 0; }
		public function FilterChain(args:Array):void {}
		public function addFilter(filter:FragmentFilter):void {}
		public function addFilterAt(filter:FragmentFilter, index:int):void {}
		public function getFilterAt(index:int):FragmentFilter { return null; }
		public function getFilterIndex(filter:FragmentFilter):int { return 0; }
		public function removeFilter(filter:FragmentFilter, dispose:Boolean = false):FragmentFilter { return null; }
		public function removeFilterAt(index:int, dispose:Boolean = false):FragmentFilter { return null; }
	}

}
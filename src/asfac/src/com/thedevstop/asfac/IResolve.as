package com.thedevstop.asfac 
{
	/**
	 * Ends the fluent resolution process.
	 */
	public interface IResolve 
	{
		/**
		 * Resolve a dependency.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		function resolve(type:Class):*
	}
}
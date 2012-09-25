package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
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
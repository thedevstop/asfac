package com.thedevstop.asfac 
{
	/**
	 * Allows the type being resolved to come from a specified scope.
	 */
	public interface IResolveFromScope 
	{
		/**
		 * Resolve a dependency from the default scope.
		 * @param	scope The name or Class of the scope.
		 * @return	An instance of the type.
		 */
		function fromScope(scope:*):IResolve
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	type The type of dependency to resolve. 
		 * @return	The ability to resolve from this scope.
		 */
		function resolve(type:Class):*
		
		/**
		 * Return all instances of a registered type from all scopes.
		 * @param	type The type being requested.
		 * @return An Array of all the resolved instances.
		 */
		function resolveAll(type:Class):Array
	}	
}
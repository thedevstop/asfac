package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public interface IResolveFromScope 
	{
		/**
		 * Resolve a dependency from the default scope.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		function fromScope(scopeName:String):IResolve
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scopeName The name of the scope.
		 * @return The ability to resolve from this scope.
		 */
		function resolve(type:Class):*
	}	
}
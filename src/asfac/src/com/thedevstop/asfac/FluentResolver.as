package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentResolver implements IResolve, IResolveFromScope
	{
		private var _factory:AsFactory;
		private var _scopeName:String = AsFactory.DefaultScopeName;
		
		public function FluentResolver(factory:AsFactory) 
		{
			_factory = factory;
		}
		
		/**
		 * Resolve a dependency.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolve(type:Class):*
		{
			return _factory.resolve(type, _scopeName);
		}
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scopeName The name of the scope.
		 * @return The ability to resolve from this scope.
		 */
		public function fromScope(scopeName:String):IResolve
		{
			_scopeName = scopeName;
			
			return this;
		}
	}
}
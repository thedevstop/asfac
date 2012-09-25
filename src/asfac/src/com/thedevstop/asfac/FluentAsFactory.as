package com.thedevstop.asfac 
{
	/**
	 * Use AsFactory to register and resolve depedencies in a fluent manner
	 */
	public class FluentAsFactory implements IRegisterInScope, IResolveFromScope
	{	
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		private var _resolver:FluentResolver;
		
		/**
		 * Constructs a new FluentAsFactory
		 * @param	factory The AsFactory that is used by the fluent interface.
		 */
		public function FluentAsFactory(factory:AsFactory = null)
		{
			_factory = factory || new AsFactory();
			_registrar = new FluentRegistrar(_factory);
			_resolver = new FluentResolver(_factory);
		}
		
		/**
		 * Register a dependency in the default scope.
		 * @param	instance How the dependency should be resolved.
		 * @return The ability to specify the type of dependency.
		 */
		public function register(instance:*):IRegisterAsType
		{
			return _registrar.register(instance);
		}
		
		/**
		 * Register a dependency in a specific scope
		 * @param	scopeName The name of the scope.
		 * @return The ability to register in the scope.
		 */
		public function inScope(scopeName:String):IRegister
		{
			return _registrar.inScope(scopeName);
		}
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scopeName The name of the scope.
		 * @return The ability to resolve from this scope.
		 */
		public function fromScope(scopeName:String):IResolve
		{
			return _resolver.fromScope(scopeName);
		}
		
		/**
		 * Resolve a dependency from the default scope.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolve(type:Class):*
		{
			return _resolver.resolve(type);
		}
	}
}

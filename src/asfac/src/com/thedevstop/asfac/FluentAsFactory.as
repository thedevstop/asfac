package com.thedevstop.asfac 
{
	import avmplus.getQualifiedClassName;
	/**
	 * AsFactory wrapped in a fluent interface.
	 */
	public class FluentAsFactory implements IRegisterInScope, IResolveFromScope
	{	
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		private var _resolver:FluentResolver;
		
		/**
		 * Constructs a new FluentAsFactory.
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
			_registrar.inScope(AsFactory.DefaultScopeName);
			return _registrar.register(instance);
		}
		
		/**
		 * Register a dependency in a specific scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to register in the scope.
		 */
		public function inScope(scope:*):IRegister
		{
			if (scope is Class)
				return _registrar.inScope(getQualifiedClassName(scope));
				
			return _registrar.inScope(scope);
		}
		
		/**
		 * Resolve a dependency from a specifc scope.
		 * @param	scope The name or Class of the scope.
		 * @return The ability to resolve from this scope.
		 */
		public function fromScope(scope:*):IResolve
		{
			if (scope is Class)
				return _resolver.fromScope(getQualifiedClassName(scope));
			
			return _resolver.fromScope(scope);
		}
		
		/**
		 * Resolve a dependency from the default scope.
		 * @param	type The type of dependency to resolve.
		 * @return An instance of the type.
		 */
		public function resolve(type:Class):*
		{
			_resolver.fromScope(AsFactory.DefaultScopeName);
			return _resolver.resolve(type);
		}
	}
}

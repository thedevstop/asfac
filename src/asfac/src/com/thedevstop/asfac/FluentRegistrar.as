package com.thedevstop.asfac 
{
	/**
	 * Handles the registration of Types for the FluentAsFactory.
	 */
	public class FluentRegistrar implements IRegister, IRegisterAsType, IRegisterAsSingleton, IRegisterInScope
	{
		private var _factory:AsFactory;
		private var _instance:*;
		private var _type:Class;
		private var _scopeName:String = AsFactory.DefaultScopeName;
		private var _asSingleton:Boolean = false;
		
		public function FluentRegistrar(factory:AsFactory)
		{
			_factory = factory;
		}
		
		/**
		 * Register a dependency.
		 * @param	instance How the dependency should be resolved.
		 * @return The ability to specify the type of dependency.
		 */
		public function register(instance:*):IRegisterAsType
		{
			_instance = instance;
			
			return this;
		}
		
		/**
		 * Register a dependency in a specific scope.
		 * @param	scopeName The name of the scope.
		 * @return The ability to register in the scope.
		 */
		public function inScope(scopeName:String):IRegister
		{
			_scopeName = scopeName;
			
			return this;
		}
		
		/**
		 * Continues the registration by specifying the type of dependency.
		 * @param	type The type of dependency this registration resolves.
		 * @return The ability to specify the resolution is a singleton.
		 */
		public function asType(type:Class):IRegisterAsSingleton
		{
			_type = type;
			
			updateRegistration();
			
			return this;
		}
		
		/**
		 * Finishes this registration by specifying that the instance should be treated as a singleton.
		 */
		public function asSingleton():void
		{
			_asSingleton = true;
			
			updateRegistration();
		}
		
		/**
		 * Registers the Type into the AsFactory instance.
		 */
		private function updateRegistration():void
		{
			_factory.register(_instance, _type, _scopeName, _asSingleton);
		}
	}
}
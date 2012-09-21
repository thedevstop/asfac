package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentRegistrar implements IRegister, IRegisterAs, IRegisterAsSingleton
	{
		private var _factory:AsFactory;
		private var _instance:*;
		private var _type:Class;
		
		public function FluentRegistrar(factory:AsFactory)
		{
			_factory = factory;
		}
		
		public function register(instance:*):IRegisterAs
		{
			_instance = instance;
			
			return this;
		}
		
		public function asType(type:Class):IRegisterAsSingleton
		{
			_type = type;
			
			if (_instance is Class)
				_factory.registerType(_instance, type);
			else if (_instance is Function)
				_factory.registerCallback(_instance, type);
			else
				_factory.registerInstance(_instance, type);
			
			return this;
		}
		
		public function asSingleton():void
		{
			if (_instance is Class)
				_factory.registerType(_instance, _type, true);
			else if (_instance is Function)
				_factory.registerCallback(_instance, _type, AsFactory.DefaultScopeName, true);
		}
	}
}
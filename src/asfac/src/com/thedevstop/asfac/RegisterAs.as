package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class RegisterAs implements IRegisterAs
	{
		private var _factory:AsFactory;
		private var _instance:*;
		
		public function RegisterAs(factory:AsFactory, instance:*)
		{
			_factory = factory;
			_instance = instance;
		}
		
		public function asType(type:Class):IRegisterAsSingleton
		{
			if (_instance is Class)
				_factory.registerType(_instance, type);
			else if (_instance is Function)
				_factory.registerCallback(_instance, type);
			else
				_factory.registerInstance(_instance, type);
			
			return new RegisterAsSingleton(_factory, _instance, type);
		}
	}
}
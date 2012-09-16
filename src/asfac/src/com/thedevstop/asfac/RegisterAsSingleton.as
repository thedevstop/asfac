package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class RegisterAsSingleton implements IRegisterAsSingleton
	{
		private var _factory:AsFactory;
		private var _instance:*;
		private var _type:Class;
		
		public function RegisterAsSingleton(factory:AsFactory, instance:*, type:Class)
		{
			_factory = factory;
			_instance = instance;
			_type = type;
		}
		
		public function singleton():void
		{
			if (_instance is Class)
				_factory.registerType(_instance, _type, true);
			else if (_instance is Function)
				_factory.registerCallback(_instance, _type, true);
		}
	}
}
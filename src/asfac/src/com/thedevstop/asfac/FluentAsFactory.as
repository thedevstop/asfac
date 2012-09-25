package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactory
	{
		private static var _instance:FluentAsFactory = null;
		
		static public function get instance():FluentAsFactory
		{
			_instance = _instance || new FluentAsFactory(AsFactory.instance);
			return _instance;
		}
		
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		
		public function FluentAsFactory(factory:AsFactory = null)
		{
			_factory = factory || new AsFactory();
			_registrar = new FluentRegistrar(_factory);
		}
		
		public function register(instance:*):IRegisterAs
		{
			return _registrar.register(instance);
		}
		
		public function resolve(type:Class):*
		{
			return _factory.resolve(type);
		}
	}
}
package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactory
	{
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		
		public function FluentAsFactory()
		{
			_factory = new AsFactory();
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
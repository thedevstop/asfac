package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactory implements IRegisterInScope
	{
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		
		public function FluentAsFactory()
		{
			_factory = new AsFactory();
			_registrar = new FluentRegistrar(_factory);
		}
		
		public function register(instance:*):IRegisterAsType
		{
			return _registrar.register(instance);
		}
		
		public function inScope(scopeName:String):IRegister
		{
			return _registrar.inScope(scopeName);
		}
		
		public function resolve(type:Class):*
		{
			return _factory.resolve(type);
		}
	}
}
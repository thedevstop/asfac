package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentAsFactory implements IRegisterInScope, IResolveFromScope
	{
		private var _factory:AsFactory;
		private var _registrar:FluentRegistrar;
		private var _resolver:FluentResolver;
		
		public function FluentAsFactory()
		{
			_factory = new AsFactory();
			_registrar = new FluentRegistrar(_factory);
			_resolver = new FluentResolver(_factory);
		}
		
		public function register(instance:*):IRegisterAsType
		{
			return _registrar.register(instance);
		}
		
		public function inScope(scopeName:String):IRegister
		{
			return _registrar.inScope(scopeName);
		}
		
		public function fromScope(scopeName:String):IResolve
		{
			return _resolver.fromScope(scopeName);
		}
		
		public function resolve(type:Class):*
		{
			return _resolver.resolve(type);
		}
	}
}
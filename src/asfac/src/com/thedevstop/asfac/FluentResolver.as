package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentResolver implements IResolve, IResolveFromScope
	{
		private var _factory:AsFactory;
		private var _scopeName:String = AsFactory.DefaultScopeName;
		
		public function FluentResolver(factory:AsFactory) 
		{
			_factory = factory;
		}
		
		public function resolve(type:Class):*
		{
			return _factory.resolve(type, _scopeName);
		}
		
		public function fromScope(scopeName:String):IResolve
		{
			_scopeName = scopeName;
			
			return this;
		}
	}

}
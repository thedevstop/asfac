package com.thedevstop.asfac 
{
	/**
	 * ...
	 * @author 
	 */
	public class FluentRegistrar implements IRegister, IRegisterAsType, IRegisterAsSingleton, IRegisterInScope, IRegisterCommit
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
		
		public function register(instance:*):IRegisterAsType
		{
			_instance = instance;
			
			return this;
		}
		
		public function asType(type:Class):IRegisterInScope
		{
			_type = type;
			
			return this;
		}
		
		public function inScope(scopeName:String):IRegisterAsSingleton
		{
			_scopeName = scopeName;
			
			return this;
		}
		
		public function asSingleton():IRegisterCommit
		{
			_asSingleton = true;
			
			return this;
		}
		
		public function commit():void
		{
			if (_instance is Class)
				_factory.registerType(_instance, _type, _scopeName, _asSingleton);
			else if (_instance is Function)
				_factory.registerCallback(_instance, _type, _scopeName, _asSingleton);
			else
				_factory.registerInstance(_instance, _type, _scopeName);	
		}
	}
}
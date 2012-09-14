package com.thedevstop.asfac
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author David Ruttka
	 */
	public class AsFactory
	{
		private var _registrations:Dictionary;
		
		public function AsFactory()
		{
			_registrations = new Dictionary();
		}
		
		public function registerInstance(instance:Object, type:Class):void
		{
			_registrations[type] = function():Object
			{
				return instance;
			};
		}
		
		public function registerType(instanceType:Class, type:Class):void 
		{
			_registrations[type] = function():Object
			{
				return new instanceType();
			};
		}
		
		public function resolve(type:Class):*
		{
			return _registrations[type]();
		}
		
	}

}